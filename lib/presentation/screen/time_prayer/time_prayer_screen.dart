import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/time_prayer/time_prayer_cubit.dart';

import '../../widgets/show_data_time.dart';

import '../../../presentation/widgets/text_responsive.dart';

import '../../widgets/icon_button_responsive.dart';
import '../../widgets/my_divider.dart';

class TimePrayerScreen extends StatefulWidget {
  final TimePrayerCubit cubit;
  const TimePrayerScreen({required this.cubit, Key? key}) : super(key: key);

  @override
  State<TimePrayerScreen> createState() => _TimePrayerScreen1State();
}

class _TimePrayerScreen1State extends State<TimePrayerScreen> {
  bool toPage = false;
  int selectPage = 0;
  late PageController controller;
  late TimePrayerCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = widget.cubit;
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  Widget buildPrayer(BuildContext context, String text, String time, Size size,
      TimePrayerCubit cubit) {
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

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    debugPrint("1");
    return BlocProvider<TimePrayerCubit>.value(
      value: cubit,
      child: BlocConsumer<TimePrayerCubit, TimePrayerState>(
        listener: ((context, state) {}),
        buildWhen: (_, state) {
          return state is! DufrantTimeState;
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: themeData.primaryColor,
            body: SafeArea(
                child: Column(
              children: [
                Stack(
                  children: [
                    ShowDataTime(
                      cubit: cubit,
                      size: size,
                      name: cubit.getText(cubit.nexttime![0]) ?? "",
                      isEn: cubit.isEn,
                      show: false,
                    ),
                    Positioned(
                        top: 5,
                        left: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Theme.of(context).backgroundColor,
                          ),
                        )),
                  ],
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
                                                cubit.myCountry!,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                cubit.getText("City") ?? "City",
                                                cubit.myCity!,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                cubit.getText(
                                                        "latitude Adjustment Method") ??
                                                    "latitude Adjustment Method",
                                                cubit.timeDay!.meta
                                                    .latitudeAdjustmentMethod,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                cubit.getText("Timezone") ??
                                                    "Timezone",
                                                cubit.timeDay!.meta.timezone,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                cubit.getText("School") ??
                                                    "School",
                                                cubit.timeDay!.meta.school,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                cubit.getText("Name") ?? "Name",
                                                cubit.timeDay!.meta.name,
                                                size,
                                                cubit,
                                              ),
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
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                "Sunrise",
                                                cubit.timePrayers[selectPage]
                                                    .timings.sunrise,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                "Dhuhr",
                                                cubit.timePrayers[selectPage]
                                                    .timings.dhuhr,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                "Asr",
                                                cubit.timePrayers[selectPage]
                                                    .timings.asr,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                "Maghrib",
                                                cubit.timePrayers[selectPage]
                                                    .timings.maghrib,
                                                size,
                                                cubit,
                                              ),
                                              buildDivider(),
                                              buildPrayer(
                                                context,
                                                "Isha",
                                                cubit.timePrayers[selectPage]
                                                    .timings.isha,
                                                size,
                                                cubit,
                                              ),
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
        },
      ),
    );
  }
}
