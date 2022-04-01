import 'package:flutter/material.dart';

import '../../../business_logic/cubit/time_prayer_cubit.dart';
import '../../widgets/text_responsive.dart';

class NatNatworckScreen extends StatelessWidget {
  final TimePrayerCubit cubit;
  const NatNatworckScreen({required this.cubit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextResponsive(
                      text: "No internet connection ...",
                      maxSize: 20,
                      size: size)
                  .headline3(context),
              SizedBox(height: size.height * 0.01),
              Image.asset("assets/images/noNetwork.gif",
                  height: size.height * 0.4),
              SizedBox(height: size.height * 0.01),
              Container(
                height: 50,
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  color: themeData.primaryColorDark.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  onPressed: () {
                    cubit.emitTimePrayerCubit();
                  },
                  child:
                      TextResponsive(text: "Try Again", maxSize: 20, size: size)
                          .headline2(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
