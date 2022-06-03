import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/home/home_cubit.dart';
import '../widgets/my_divider.dart';

import '../../business_logic/cubit/time_prayer/time_prayer_cubit.dart';
import '../widgets/icon_button_responsive.dart';
import '../widgets/text_responsive.dart';

class SettingScreen extends StatelessWidget {
  final TimePrayerCubit cubitTime;
  const SettingScreen({required this.cubitTime, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    HomeCubit cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 40,
              centerTitle: true,
              title: TextResponsive(
                      text: cubit.getText("Settings") ?? "Settings",
                      maxSize: 20,
                      size: size)
                  .headline3(context),
              leading: IconButtonResponsive(
                icons: cubit.isEn
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_back_ios_rounded,
                size: size,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      cubit.changeMode(context);
                    },
                    child: Row(
                      children: [
                        TextResponsive(
                                text: cubit.isDark == null
                                    ? cubit.isDarkModeSystem(context)
                                        ? cubit.getText("lightMode") ??
                                            "Light Mode"
                                        : cubit.getText("darkMode") ??
                                            "Dark Mode"
                                    : cubit.isDark!
                                        ? cubit.getText("lightMode") ??
                                            "Light Mode"
                                        : cubit.getText("darkMode") ??
                                            "Dark Mode",
                                maxSize: 30,
                                size: size)
                            .headline3(context, bold: true),
                        const Spacer(),
                        Image.asset(
                          "assets/images/mode.gif",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: buildDivider1(),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.changeLanguage();
                    },
                    child: Row(
                      children: [
                        TextResponsive(
                                text: cubit.getText("language") ?? "Language",
                                maxSize: 30,
                                size: size)
                            .headline3(context, bold: true),
                        const Spacer(),
                        Image.asset(
                          "assets/images/language.png",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: buildDivider1(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      cubitTime.emitTimePrayerCubit1(update: false);
                    },
                    child: Row(
                      children: [
                        TextResponsive(
                                text: cubit.getText("updateLocation") ??
                                    "Update Location",
                                maxSize: 30,
                                size: size)
                            .headline3(context, bold: true),
                        const Spacer(),
                        Image.asset(
                          "assets/images/location.gif",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
