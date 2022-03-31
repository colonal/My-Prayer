// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import 'package:my_prayer/constnats/language.dart';
import 'package:my_prayer/helpers/location_helper.dart';

import '../../data/models/times_prayers.dart';
import '../../data/repository/time_prayer_repo.dart';
import '../../data/wepservices/time_prayer_services.dart';
import '../../helpers/contato_dao.dart';

part 'time_prayer_state.dart';

class TimePrayerCubit extends Cubit<TimePrayerState> {
  TimeRepository timeRepository;
  TimePrayerCubit(this.timeRepository) : super(TimePrayerInitial());
  static TimePrayerCubit get(context) => BlocProvider.of(context);

  List<TimesPrayers> timePrayers = [];

  Timer? time;

  bool onLine = false;

  bool? lodingTimePrayer;
  List<String>? nexttime;
  TimesPrayers? timeDay;
  int index = 0;
  bool isEn = false;
  late String myCountry = "Jordan";
  late String myCity = "Irbid";
  bool isHowInfo = false;
  PlacesWebServices placesWebServices = PlacesWebServices();

  void showInfo() {
    isHowInfo = !isHowInfo;
    emit(ShowInfoState());
  }

  void emitTimePrayerCubit({String? city, String? country}) async {
    lodingTimePrayer = true;
    emit(EmitTimePrayerLodingState());
    if (country == null || city == null) {
      try {
        var first = await LocationHelper.getUserLocation();
        myCountry = first.countryName;
        myCity = first.adminArea;
      } catch (e) {
        print("Error location: $e");
        emit(UserLocationError());
        // return;
      }
    } else {
      myCountry = country;
      myCity = city;
    }
    try {
      // selectAll();
      print("start: $lodingTimePrayer");
      final times = await placesWebServices.frtchSuggestion(myCity, myCountry);
      timePrayers = await timeRepository.getTimesPrayers(times);
      insertData(items: times);
      nextTimePrayer();
      lodingTimePrayer = false;
      print("start1: $lodingTimePrayer");
    } catch (_) {
      selectAll();
      return;
    }
    emit(EmitTimePrayerState());
  }

  void nextTimePrayer() {
    var t = TimeOfDay.now();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-y').format(now);

    timeDay = timePrayers
        .firstWhere((element) => element.date.gregorian.date == formattedDate);

    bool check = false;
    // TODO timeDay!.timingsJson["Fajr"] = "21:42";
    timeDay!.timingsJson.forEach((key, value) {
      print("t.hour: ${t.hour}");
      // print("value: $value\tkey: $key");
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

      TimesPrayers tomorrow = timePrayers[index + 1];

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
    try {
      dufrantTime();
    } catch (e) {
      print("E: $e");
    }
  }

  void dufrantTime() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      var to = (DateFormat('dd MMM yyyy HH:mm')
          .parse("${nexttime![3]} " + nexttime![2]));
      var from = DateTime.now();

      nexttime![4] = to.difference(from).toString();
      Duration v = to.difference(from);

      if (v.inSeconds == 0) {
        cancelTimer();
        nextTimePrayer();
      }
      emit(DufrantTimeState());
    });
  }

  void cancelTimer() {
    time!.cancel();
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
      nextTimePrayer();
      lodingTimePrayer = false;
      emit(EmitTimePrayerState());
      return timePrayers.isEmpty ? false : true;
    } catch (_) {
      return false;
    }
  }

  void insertData({required List items}) async {
    await _contatoDAO.delete();
    print(":insertData");

    for (var item in items) {
      await _contatoDAO.insert(
        timings: jsonEncode(item["timings"]),
        date: jsonEncode(item["date"]),
        meta: jsonEncode(item["meta"]),
      );
    }
  }
}
