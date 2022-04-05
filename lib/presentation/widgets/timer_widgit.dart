import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './text_responsive.dart';

import '../../business_logic/cubit/time_prayer_cubit.dart';

class TimerWidget extends StatefulWidget {
  final TimePrayerCubit cubit;
  final Size size;
  const TimerWidget({required this.cubit, required this.size, Key? key})
      : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer time;
  late TimePrayerCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = widget.cubit;
    dufrantTime(cubit);
  }

  @override
  void dispose() {
    time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextResponsive(
      text: "- ${cubit.nexttime![4].split(".")[0]}",
      maxSize: 20,
      size: widget.size,
    ).headline2(context);
  }

  void dufrantTime(cubit) {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      var to = (DateFormat('dd MMM yyyy HH:mm')
          .parse("${cubit.nexttime![3]} " + cubit.nexttime![2]));
      var from = DateTime.now();

      cubit.nexttime![4] = to.difference(from).toString();
      Duration v = to.difference(from);

      if (v.inSeconds == 0) {
        cubit.cancelTimer();
        cubit.nextTimePrayer();
      }
      setState(() {});
    });
  }
}
