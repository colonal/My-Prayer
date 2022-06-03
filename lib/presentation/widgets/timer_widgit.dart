import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'text_responsive.dart';

import '../../business_logic/cubit/time_prayer/time_prayer_cubit.dart';

class TimerWidget extends StatelessWidget {
  final TimePrayerCubit cubit;
  final Size size;
  const TimerWidget({required this.cubit, required this.size, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimePrayerCubit, TimePrayerState>(
        listener: (_, __) {},
        builder: (context, _) {
          return TextResponsive(
            text: "- ${cubit.nexttime![4].split(".")[0]}",
            maxSize: 20,
            size: size,
          ).headline2(context);
        });
  }
}
