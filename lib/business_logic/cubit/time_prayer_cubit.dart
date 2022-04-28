// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import 'package:my_prayer/constnats/language.dart';
import 'package:my_prayer/helpers/location_helper.dart';

import '../../data/models/times_prayers.dart';
import '../../data/repository/time_prayer_repo.dart';
import '../../data/wepservices/time_prayer_services.dart';
import '../../helpers/cache_helper.dart';
import '../../helpers/contato_dao.dart';

part 'time_prayer_state.dart';

class TimePrayerCubit extends Cubit<TimePrayerState> {
  TimeRepository timeRepository;
  TimePrayerCubit(this.timeRepository) : super(TimePrayerInitial());
  static TimePrayerCubit get(context) =>
      BlocProvider.of<TimePrayerCubit>(context);

  List<TimesPrayers> timePrayers = [];

  Timer? time;

  bool isOnline = false;

  bool? lodingTimePrayer;
  List<String>? nexttime;
  TimesPrayers? timeDay;
  int index = 0;
  bool isEn = false;
  String? myCountry;
  String? myCity;
  bool isHowInfo = false;
  PlacesWebServices placesWebServices = PlacesWebServices();

  Map months = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "July",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
  }

  void showInfo() {
    isHowInfo = !isHowInfo;
    emit(ShowInfoState());
  }

  void emitTimePrayerCubit1({String? city, String? country}) async {
    lodingTimePrayer = true;
    emit(EmitTimePrayerLodingState());
    bool inData = await selectAll();
    if (inData) {
      try {
        print("Is Data");
        lodingTimePrayer = false;
        emit(EmitTimePrayerState());
      } catch (_) {
        print("Is Not Data");
        getDataApi(city: city, country: country);
      }
    } else {
      print("Is Not Data1");
      getDataApi(city: city, country: country);
    }
  }

  void getDataApi({String? city, String? country}) async {
    isOnline = await hasNetwork();
    bool isLocation = true;
    if (isOnline) {
      print("Online");
      try {
        await getLocation(city: city, country: country)
            .onError((error, stackTrace) {
          emit(UserLocationError());
          isLocation = false;
        });
        if (!isLocation) return;
        final times = await runApi();
        timePrayers = await timeRepository.getTimesPrayers(times);
        insertData(items: timePrayers);
        nextTimePrayer();
        lodingTimePrayer = false;
        emit(EmitTimePrayerState());
      } catch (E) {
        print("Is On Line Error: $E");
        emit(NatNetworkState());
      }
    }
  }

  void nextTimePrayer() {
    var t = TimeOfDay.now();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-y').format(now);

    timeDay = timePrayers.firstWhere((element) {
      print(
          "element: ${element.date.gregorian.date} formattedDate:$formattedDate");
      return element.date.gregorian.date == formattedDate;
    });
    print("timeDay: $timeDay");
    bool check = false;
    // TODO timeDay!.timingsJson["Fajr"] = "21:42";
    // timeDay!.timingsJson["Fajr"] = "4:55";
    timeDay!.timingsJson.forEach((key, value) {
      print("t.hour: ${t.hour}");
      if (((t.hour < int.parse(value.toString().split(":")[0])) ||
              ((t.hour == int.parse(value.toString().split(":")[0]))
                  ? (t.minute < int.parse(value.toString().split(":")[1]))
                  : false)) &&
          !check &&
          key != "Sunset") {
        check = true;
        nexttime = [
          key,
          (int.parse(value.toString().split(":")[0]) > 12
              ? "${int.parse(value.toString().split(":")[0]) - 12}:${int.parse(value.toString().split(":")[1]) < 10 ? 0 : ''}${int.parse(value.toString().split(":")[1])} PM"
              : "$value AM"),
          value,
          timeDay!.date.readable,
          ""
        ];
      }
    });
    if (!check) {
      index = timePrayers.indexOf(timeDay!);
      TimesPrayers tomorrow;
      if ((index + 1) != timePrayers.length) {
        tomorrow = timePrayers[index + 1];
      } else {
        tomorrow = timePrayers[index];
        String m = months[DateTime.now().month + 1];
        tomorrow.date.readable = "01 $m " + DateTime.now().year.toString();
      }
      String formatTime = tomorrow.timingsJson["Fajr"];
      nexttime = [
        "Fajr",
        (int.parse(formatTime.toString().split(":")[0]) > 12
            ? "${int.parse(formatTime.toString().split(":")[0]) - 12}:${int.parse(formatTime.toString().split(":")[1])} PM"
            : "$formatTime AM"),
        formatTime,
        tomorrow.date.readable,
        ""
      ];
    }
    print("check: $check");
    print("Next: $nexttime");
    // try {
    //   dufrantTime();
    // } catch (e) {
    //   print("E: $e");
    // }
    emit(DufrantTimeState());
  }

  void cancelTimer() {
    if (time != null) {
      time!.cancel();
    }
  }

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }

  final ContatoDAO _contatoDAO = ContatoDAO();

  Future<bool> selectAll() async {
    try {
      List times = await _contatoDAO.select();
      // print("retorno: ${times}");
      try {
        timePrayers =
            await timeRepository.getTimesPrayers(times, isQuery: true);
      } catch (e) {
        print("ERROR selectAll: $e");
      }
      print("timePrayers: ${timePrayers.length}");
      if (timePrayers.isNotEmpty) {
        print(
            "XxX: ${timePrayers[timePrayers.length - 1].date.gregorian.month} == ${(DateTime.now().month - 1)} bool ${timePrayers[timePrayers.length - 1].date.gregorian.month == (DateTime.now().month - 1)}");
        if (timePrayers[timePrayers.length - 1].date.gregorian.month ==
            (DateTime.now().month)) {
          print("XxXx");
          nextTimePrayer();
          return true;
        }
        return false;
      }

      return false;
    } catch (E) {
      print("EEE: $E");
      return false;
    }
  }

  void insertData({required List<TimesPrayers> items}) async {
    await _contatoDAO.delete();
    print(":insertData");

    for (var item in items) {
      await _contatoDAO.insert(
        timesPrayers: item,
      );
    }
  }

  Future<void> getLocation({String? city, String? country}) async {
    if (country == null || city == null) {
      try {
        var first = await LocationHelper.getUserLocation();
        myCountry = first.country;
        myCity = first.administrativeArea;
      } catch (e) {
        print("Error location: $e");
        throw ("Erroe Location");
      }
    } else {
      myCountry = country;
      myCity = city;
    }
  }

  Future<List<dynamic>> runApi() async {
    return await placesWebServices.frtchSuggestion(myCity!, myCountry!);
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
