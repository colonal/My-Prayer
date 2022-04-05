import 'package:flutter/material.dart';

import '../../business_logic/cubit/time_prayer_cubit.dart';
import 'text_responsive.dart';
import 'timer_widgit.dart';

class ShowDataTime extends StatelessWidget {
  final TimePrayerCubit cubit;
  final Size size;
  const ShowDataTime({required this.cubit, required this.size, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height > 530 ? size.height * 0.3 : size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.green[900],
          image: const DecorationImage(
              image: AssetImage("assets/images/backgound.png"),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextResponsive(
                  text: cubit.getText(cubit.nexttime![0]) ?? "",
                  maxSize: 20,
                  size: size)
              .headline2(context),
          SizedBox(height: size.height > 435 ? 5 : 0),
          TextResponsive(text: cubit.nexttime![1], maxSize: 60, size: size)
              .headline1(context),
          SizedBox(height: size.height > 435 ? 5 : 0),
          TimerWidget(cubit: cubit, size: size),
          SizedBox(height: size.height > 435 ? 5 : 0),
        ],
      ),
    );
  }
}
