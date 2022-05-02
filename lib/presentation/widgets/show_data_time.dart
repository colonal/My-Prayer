import 'package:flutter/material.dart';
import 'package:my_prayer/presentation/widgets/icon_button_responsive.dart';

import '../../business_logic/cubit/time_prayer_cubit.dart';
import 'text_responsive.dart';
import 'timer_widgit.dart';

class ShowDataTime extends StatelessWidget {
  final TimePrayerCubit cubit;
  final Size size;
  final String name;
  final bool isEn;
  final bool show;
  const ShowDataTime(
      {required this.cubit,
      required this.size,
      required this.name,
      required this.isEn,
      this.show = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: size.height > 530 ? size.height * 0.35 : size.height * 0.4,
      
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.green[900],
          image: const DecorationImage(
              image: AssetImage("assets/images/backgound.png"),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          TextResponsive(text: name, maxSize: 18, size: size)
              .headline2(context),
          SizedBox(height: size.height > 435 ? 5 : 0),
          TextResponsive(
                  text: cubit.nexttime![1], maxSize: 50, size: size)
              .headline1(context),
          SizedBox(height: size.height > 435 ? 5 : 0),
          TimerWidget(cubit: cubit, size: size),
          SizedBox(height: size.height > 435 ? 5 : 0),
          
          if(show)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
          IconButtonResponsive(
              icons: Icons.location_on_outlined, size: size,isBackGroundColor: true,),
          TextResponsive(
                  text:
                      "${isEn ? cubit.timeDay!.hijri.monthEn : cubit.timeDay!.hijri.monthAr} : ${cubit.timeDay!.hijri.date}",
                  maxSize: 15,
                  size: size)
              .headline2(context,bold: false),
          ],
        )
        ],
      ),
    );
  }
}
