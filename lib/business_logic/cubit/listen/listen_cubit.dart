import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/listen/listen_state.dart';
import 'package:my_prayer/data/models/audio_files.dart';
import 'package:my_prayer/data/wepservices/audio_files_services.dart';

import '../../../constnats/language.dart';
import '../../../helpers/cache_helper.dart';

class ListenCubit extends Cubit<ListenState> {
  final AudioFilesServices audioFilesServices;
  ListenCubit({required this.audioFilesServices}) : super(ListenInitialState());

  static ListenCubit get(context) => BlocProvider.of(context);

  bool isEn = false;
  bool? isDark;
  int id = 1;
  int index = 0;

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoob = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String url = "";
  bool isClose = false;
  static List<AudioFiles> audioFiles = [];

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
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      emit(DurationChangedState());
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      if (!isClose) emit(PositionChangedState());
    });

    audioPlayer.onPlayerComplete.listen((event) {});
    audioPlayer.onSeekComplete.listen((event) {
      print("isPlaying: $isPlaying");
      isPlaying = isPlaying ? false : isPlaying;
      setAudoi(++index);
    });
  }

  Future setAudoi(index) async {
    index = index;
    url = "https://download.quranicaudio.com/qdc/abdul_baset/mujawwad/1.mp3";
    audioPlayer.setReleaseMode(isLoob ? ReleaseMode.loop : ReleaseMode.stop);
    audioPlayer.setVolume(1.0);
    print("audioFiles[index].audioUrl: ${audioFiles[index].audioUrl}");
    audioPlayer.setSourceUrl(audioFiles[index].audioUrl);
    playOnPressed();
  }

  void changeMode() {
    isLoob != isLoob;
  }

  void sliderChanged(value) async {
    final position = Duration(seconds: value.toInt());
    await audioPlayer.seek(position);
    await audioPlayer.resume();
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
      audioFilesServices.getAudioFiles(id).then((value) {
        for (var element in value) {
          audioFiles.add(AudioFiles.fromMap(element));
        }
        print(audioFiles.length);
        emit(GetDataAudioFiles());
      }).catchError((_) {
        emit(ErrorAudioFiles());
      });
    } else {
      emit(GetDataAudioFiles());
    }
  }

  @override
  Future<void> close() async {
    isClose = true;
    await audioPlayer.dispose();
    return super.close();
  }
}
