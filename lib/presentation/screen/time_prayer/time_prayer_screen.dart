import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_prayer/business_logic/cubit/time_prayer_cubit.dart';
import 'package:my_prayer/presentation/screen/time_prayer/select_country_screen.dart';
import 'package:my_prayer/presentation/widgets/text_responsive.dart';

import '../../widgets/icon_button_responsive.dart';
import '../../widgets/my_divider.dart';

class TimePrayerScreen extends StatefulWidget {
  const TimePrayerScreen({Key? key}) : super(key: key);

  @override
  State<TimePrayerScreen> createState() => _TimePrayerScreenState();
}

class _TimePrayerScreenState extends State<TimePrayerScreen> {
  bool toPage = false;
  int selectPage = 0;
  late PageController controller;
  late String _country;
  late String _state;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final cubit = TimePrayerCubit.get(context);
    debugPrint("${size.height}");
    debugPrint("${size.width}");
    debugPrint("lodingTimePrayer: ${cubit.lodingTimePrayer}");

    return BlocConsumer<TimePrayerCubit, TimePrayerState>(
      listener: ((context, state) {}),
      buildWhen: ((context, state) {
        if (state is DufrantTimeState) {
          return false;
        }
        return true;
      }),
      builder: (context, state) {
        if (!cubit.onLine) {}
        if ((state is UserLocationError)) {
          return SelectCountryScreen(
            context: context,
            cubit: cubit,
            size: size,
            onCountryChanged: (country) {
              _country = country;
            },
            onStateChanged: (state) {
              _state = state;
            },
            onSubmit: () {
              if (_country.isNotEmpty && _state.isNotEmpty) {
                cubit.emitTimePrayerCubit(
                    country: _country.split("    ")[1],
                    city: _state.split(" ")[0]);
              }
            },
          );
        }
        if (!cubit.lodingTimePrayer!) {
          return Scaffold(
            backgroundColor: themeData.primaryColor,
            body: SafeArea(
                child: Column(
              children: [
                Container(
                  height:
                      size.height > 530 ? size.height * 0.3 : size.height * 0.4,
                  width: size.width,
                  color: Colors.green[900],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextResponsive(
                              text: cubit.getText(cubit.nexttime![0]) ?? "",
                              maxSize: 20,
                              size: size)
                          .headline2(context),
                      SizedBox(height: size.height > 435 ? 5 : 0),
                      TextResponsive(
                              text: cubit.nexttime![1], maxSize: 60, size: size)
                          .headline1(context),
                      SizedBox(height: size.height > 435 ? 5 : 0),
                      BlocConsumer<TimePrayerCubit, TimePrayerState>(
                        listener: (context, state) {},
                        buildWhen: (context, state) {
                          if (state is DufrantTimeState) return true;
                          return true;
                        },
                        builder: (context, state) {
                          return TextResponsive(
                                  text: "- ${cubit.nexttime![4].split(".")[0]}",
                                  maxSize: 20,
                                  size: size)
                              .headline2(context);
                        },
                      ),
                      SizedBox(height: size.height > 435 ? 5 : 0),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            color: themeData.backgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Directionality(
                          textDirection: cubit.isEn
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          child: PageView.builder(
                              controller: controller,
                              itemCount: cubit.isHowInfo
                                  ? 1
                                  : cubit.timePrayers.length,
                              onPageChanged: (int indexSelect) {
                                setState(() {
                                  selectPage = indexSelect;
                                });
                              },
                              itemBuilder: (context, index) {
                                if (!toPage) {
                                  selectPage =
                                      cubit.timePrayers.indexOf(cubit.timeDay!);
                                  _toPage(cubit.timePrayers
                                      .indexOf(cubit.timeDay!));
                                }
                                return SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width > 220
                                            ? size.width > 480
                                                ? 40
                                                : 10
                                            : 0,
                                        vertical: 40),
                                    child: Column(
                                      children: cubit.isHowInfo
                                          ? [
                                              const SizedBox(height: 30),
                                              buildPrayer(
                                                  context,
                                                  cubit.getText("Country") ??
                                                      "Country",
                                                  cubit.myCountry,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  cubit.getText("City") ??
                                                      "City",
                                                  cubit.myCity,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  cubit.getText(
                                                          "latitude Adjustment Method") ??
                                                      "latitude Adjustment Method",
                                                  cubit.timeDay!.meta
                                                      .latitudeAdjustmentMethod,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  cubit.getText("Timezone") ??
                                                      "Timezone",
                                                  cubit.timeDay!.meta.timezone,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  cubit.getText("School") ??
                                                      "School",
                                                  cubit.timeDay!.meta.school,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  cubit.getText("Name") ??
                                                      "Name",
                                                  cubit.timeDay!.meta.name,
                                                  size),
                                              buildDivider(),
                                            ]
                                          : [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButtonResponsive(
                                                    icons: cubit.isEn
                                                        ? Icons
                                                            .arrow_back_ios_rounded
                                                        : Icons
                                                            .arrow_back_ios_rounded,
                                                    size: size,
                                                    opacity: true,
                                                    onPressed: selectPage != 1
                                                        ? () {
                                                            _toPage(
                                                                --selectPage);
                                                          }
                                                        : null,
                                                  ),
                                                  TextResponsive(
                                                          text: cubit
                                                              .timePrayers[
                                                                  index]
                                                              .date
                                                              .readable,
                                                          maxSize: 20,
                                                          size: size)
                                                      .headline3(context,
                                                          bold: true),
                                                  IconButtonResponsive(
                                                    icons: cubit.isEn
                                                        ? Icons
                                                            .arrow_forward_ios_rounded
                                                        : Icons
                                                            .arrow_forward_ios_rounded,
                                                    size: size,
                                                    onPressed: selectPage <
                                                            cubit.timePrayers
                                                                    .length -
                                                                1
                                                        ? () {
                                                            _toPage(
                                                                ++selectPage);
                                                          }
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
                                              buildPrayer(
                                                  context,
                                                  "Fajr",
                                                  cubit.timePrayers[selectPage]
                                                      .timings.fajr,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  "Sunrise",
                                                  cubit.timePrayers[selectPage]
                                                      .timings.sunrise,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  "Dhuhr",
                                                  cubit.timePrayers[selectPage]
                                                      .timings.dhuhr,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  "Asr",
                                                  cubit.timePrayers[selectPage]
                                                      .timings.asr,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  "Maghrib",
                                                  cubit.timePrayers[selectPage]
                                                      .timings.maghrib,
                                                  size),
                                              buildDivider(),
                                              buildPrayer(
                                                  context,
                                                  "Isha",
                                                  cubit.timePrayers[selectPage]
                                                      .timings.isha,
                                                  size),
                                            ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -15),
                        child: Container(
                          padding: EdgeInsets.all(size.width < 230 ? 0 : 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                themeData.backgroundColor,
                                themeData.primaryColor
                              ],
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width < 230 ? 0 : 20),
                            decoration: BoxDecoration(
                              color: themeData.backgroundColor,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButtonResponsive(
                                  icons: cubit.isHowInfo
                                      ? Icons.close
                                      : Icons.info_outline_rounded,
                                  size: size * 0.7,
                                  onPressed: () {
                                    cubit.showInfo();
                                    if (!cubit.isHowInfo) {
                                      selectPage = cubit.timePrayers
                                          .indexOf(cubit.timeDay!);
                                      _toPage(cubit.timePrayers
                                          .indexOf(cubit.timeDay!));
                                    }
                                  },
                                ),
                                if (size.width > 130)
                                  buildDivider(isVertical: true),
                                TextResponsive(
                                        text:
                                            "${cubit.myCountry} - ${cubit.myCity} ",
                                        maxSize: 14,
                                        size: size)
                                    .headline3(context, bold: false),
                                if (size.width > 130)
                                  buildDivider(isVertical: true),
                                IconButtonResponsive(
                                  icons: Icons.location_on,
                                  size: size * 0.7,
                                  onPressed: () {
                                    _toPage(cubit.timePrayers
                                        .indexOf(cubit.timeDay!));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildPrayer(
      BuildContext context, String text, String time, Size size) {
    TimePrayerCubit cubit = TimePrayerCubit.get(context);
    int index = 0;

    if (time.split(" ").length > 3) {
      String t = '';
      for (var item in time.split(" ")) {
        ++index;
        if (index == 3) {
          t += "$item\n";
          continue;
        }

        t += "$item ";
      }
      time = t;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: (cubit.nexttime![0] == text &&
              selectPage == cubit.timePrayers.indexOf(cubit.timeDay!))
          ? Colors.green[900]!.withOpacity(0.5)
          : null,
      child: Row(
        children: [
          TextResponsive(
                  text: cubit.getText(text) ?? text, maxSize: 20, size: size)
              .headline3(context),
          const Spacer(),
          TextResponsive(text: time, maxSize: 20, size: size)
              .headline3(context),
        ],
      ),
    );
  }

  void _toPage(int index) {
    debugPrint("index: $index");
    try {
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      toPage = true;
    } catch (e) {
      debugPrint("e: $e");
    }
  }
}
