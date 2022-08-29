// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/business_logic/cubit/listen/listen_state.dart';
import 'package:my_prayer/data/models/audio_files.dart';
import 'package:my_prayer/data/wepservices/audio_files_services.dart';

import '../../../constnats/language.dart';
import '../../../constnats/quran.dart';
import '../../../data/models/recitations.dart';
import '../../../helpers/cache_helper.dart';

class ListenCubit extends Cubit<ListenState> {
  final AudioFilesServices audioFilesServices;
  ListenCubit({required this.audioFilesServices}) : super(ListenInitialState());

  static ListenCubit get(context) => BlocProvider.of(context);

  bool isEn = false;
  bool? isDark;
  int recitationId = CacheHelper.getData(key: "recitationId") ?? 1;
  String recitationNameEn =
      CacheHelper.getData(key: "recitationNameEn") ?? "AbdulBaset AbdulSamad";
  String recitationNameAr =
      CacheHelper.getData(key: "recitationNameAr") ?? "عبد الباسط عبد الصمد";
  int index = 0;

  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  bool isLoob = false;
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String url = "";
  bool isClose = false;
  String name = "";
  static List<AudioFiles> audioFiles = [];
  static List<Recitations> recitations = [];

  void getData() {
    getLanguage();
  }

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
  }

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }

  void initAudio() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;

      emit(PlayerStateChangedState());
    }).onError((e) {
      print("\nE  onPlayerStateChanged: $e");
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      // emit(DurationChangedState());
    }).onError((e) {
      print("\nE  onDurationChanged: $e");
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      print(
          "Duration: $duration\t\t position: $position \t\t${duration.toString().split(".")[0] == position.toString().split(".")[0]}");
      if (!isClose) emit(PositionChangedState());
      if (duration.toString().split(".")[0] ==
          position.toString().split(".")[0]) setAudoi(++index);
    }).onError((e) {
      print("\nE  onPositionChanged: $e");
    });
  }

  Future setAudoi(index) async {
    try {
      index = index;
      name = quranInfo[index]["Name"];
      url = audioFiles[index].audioUrl;
      print("audioFiles[index].audioUrl: ${audioFiles[index].audioUrl}");
      changeStateLoading();
      audioPlayer
          .play(UrlSource(url))
          .then((value) => changeStateLoading())
          .catchError((onError) {
        changeStateLoading();
        print("onError: $onError");
      });
    } catch (e) {
      print("E: $e");
    }
  }

  void changeMode() {
    isLoob != isLoob;
  }

  void sliderChanged(value) async {
    try {
      final position = Duration(seconds: value.toInt());
      changeStateLoading();
      await audioPlayer.seek(position).then((value) => changeStateLoading());
      // await audioPlayer.resume();
      if (!isPlaying) {
        await audioPlayer.resume();
      }
    } catch (e) {
      print("E: $e");
    }
  }

  void playOnPressed() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
  }

  void getAudioFiles() async {
    emit(LoadingAudioFiles());
    if (audioFiles.isEmpty) {
      audioFilesServices.getAudioFiles(recitationId).then((value) {
        for (var element in value) {
          audioFiles.add(AudioFiles.fromMap(element));
        }
        print(audioFiles.length);
        print("audioFiles: $audioFiles");
        initAudio();
        emit(GetDataAudioFiles());
      }).catchError((e) {
        print("ErrorAudioFiles: $e");
        emit(ErrorAudioFiles());
      });
    } else {
      print("audioFiles1: $audioFiles");
      emit(GetDataAudioFiles());
      initAudio();
    }
  }

  void nextAudio() {
    if (index != audioFiles.length - 1) {
      audioPlayer.pause();
      setAudoi(++index);
    }
  }

  void previousAudio() {
    if (index != 0) {
      audioPlayer.pause();
      setAudoi(--index);
    }
  }

  void changeStateLoading() {
    isLoading = !isLoading;
    emit(LoadingState());
  }

  void replay10() async {
    changeStateLoading();
    int replay = 0;
    Duration? position = await audioPlayer.getCurrentPosition();
    if (position != null) {
      if (position.inSeconds > 10) {
        replay = 10;
      } else {
        replay = position.inSeconds;
      }

      position = Duration(
          days: position.inDays,
          hours: position.inHours,
          minutes: position.inMinutes,
          seconds: position.inSeconds - replay);
      await audioPlayer.seek(position);
    }

    changeStateLoading();
  }

  void forward10() async {
    changeStateLoading();
    Duration? position = await audioPlayer.getCurrentPosition();
    print("old position: $position");
    if (position != null) {
      if (position.inSeconds > 50) {
        position = Duration(
            days: position.inDays,
            hours: position.inHours,
            minutes: position.inMinutes + 1,
            seconds: (position.inSeconds - 50));
        print(
            "new position: $position || ${position.inSeconds}|${position.inSeconds - 50}");
      } else {
        position = Duration(
            days: position.inDays,
            hours: position.inHours,
            minutes: position.inMinutes,
            seconds: position.inSeconds + 10);
      }

      await audioPlayer.seek(position);
    }
    changeStateLoading();
  }

  void getRecitations() {
    emit(LoadingRecitationsState());
    if (recitations.isEmpty) {
      audioFilesServices.getRecitations().then((value) {
        for (var element in value) {
          recitations.add(Recitations.fromJson(element));
        }
        print("getRecitations: $audioFiles");

        emit(GetRecitationsState());
      }).catchError((e) {
        print("ErrorRecitationsState: $e");
        emit(ErrorRecitationsState());
      });
    } else {
      emit(GetRecitationsState());
    }
  }

  void changeRecitations(Recitations recitation) {
    recitationId = recitation.id;
    recitationNameEn = recitation.reciterName;
    recitationNameAr = recitation.nameAr;
    CacheHelper.saveData(key: "recitationId", value: recitationId);
    CacheHelper.saveData(key: "recitationNameEn", value: recitationNameEn);
    CacheHelper.saveData(key: "recitationNameAr", value: recitationNameAr);

    restartData();
    getAudioFiles();
    emit(ChangeRecitationsState());
  }

  void restartData({isEmit = false}) {
    isPlaying = false;
    isLoob = false;
    isLoading = false;
    duration = Duration.zero;
    position = Duration.zero;
    url = "";
    isClose = false;
    name = "";
    if (isEmit) {
      emit(RestartDataState());
    } else {
      audioFiles = [];
    }
  }

  @override
  Future<void> close() async {
    isClose = true;
    await audioPlayer.dispose();
    return super.close();
  }
}
