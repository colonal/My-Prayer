import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/listen/listen_cubit.dart';
import 'package:my_prayer/presentation/screen/listen/listen_screen.dart';
import '../../business_logic/cubit/azkar/azkar_cubit.dart';
import '../../business_logic/cubit/qoran/qoran_cubit.dart';
import '../../business_logic/cubit/time_prayer/time_prayer_cubit.dart';
import 'Qoran/quran_screen.dart';
import 'ayah/ayah_screen.dart';
import 'azkar/azkar_screen.dart';
import 'setting_screen.dart';
import '../../business_logic/cubit/ayah/ayah_cubit.dart';
import '../../business_logic/cubit/home/home_cubit.dart';
import '../widgets/show_data_time.dart';
import 'time_prayer/time_prayer_screen.dart';

import '../widgets/text_responsive.dart';
import 'loading_screen.dart';
import 'time_prayer/net_networck_screen.dart';
import 'time_prayer/select_country_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _country;

  late String _state;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<TimePrayerCubit, TimePrayerState>(
            listener: (_, __) {},
            buildWhen: (_, state) {
              return state is! DufrantTimeState;
            },
            builder: (ctx, state) {
              final cubit = TimePrayerCubit.get(ctx);
              final cubitHome = HomeCubit.get(ctx);
              if (state is NatNetworkState) {
                return NatNatworckScreen(cubit: cubit);
              }
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
                      cubit.emitTimePrayerCubit1(
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
                      ShowDataTime(
                        cubit: cubit,
                        size: size,
                        name: cubitHome.getText(cubit.nexttime![0]) ?? "",
                        isEn: cubitHome.isEn,
                      ),
                      Expanded(
                        child: Container(
                          color: themeData.backgroundColor,
                          width: size.width,
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            padding: const EdgeInsets.all(8),
                            children: [
                              buidGridItem(
                                  context: context,
                                  themeData: themeData,
                                  size: size,
                                  text: cubitHome.getText("TimePrayer") ??
                                      "Time Prayer",
                                  image: "assets/images/pray.png",
                                  isEn: cubitHome.isEn,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: cubit..getLanguage(),
                                        child: TimePrayerScreen(cubit: cubit),
                                      ),
                                    ));
                                  }),
                              buidGridItem(
                                  context: context,
                                  themeData: themeData,
                                  size: size,
                                  text: cubitHome.getText("Ayah") ?? "Ayah",
                                  image: "assets/images/ayah.png",
                                  isEn: cubitHome.isEn,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => BlocProvider<AyahCubit>(
                                          create: (context) =>
                                              AyahCubit()..readJson(),
                                          child: const AyahScreen()),
                                    ));
                                  }),
                              buidGridItem(
                                  context: context,
                                  themeData: themeData,
                                  size: size,
                                  text: cubitHome.getText("Quran") ?? "Quran",
                                  image: "assets/images/qoran.png",
                                  isEn: cubitHome.isEn,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (_) => QoranCubit()
                                          ..getLanguage()
                                          ..getFavorite(),
                                        child: const QuranScreen(),
                                      ),
                                    ));
                                  }),
                              buidGridItem(
                                  context: context,
                                  themeData: themeData,
                                  size: size,
                                  text: cubitHome.getText("Azkar") ?? "Azkar",
                                  image: "assets/images/prayer.png",
                                  isEn: cubitHome.isEn,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: AzkarCubit()
                                          ..getLanguage()
                                          ..readJson(),
                                        child: const AzkarScreen(),
                                      ),
                                    ));
                                  }),
                              buidGridItem(
                                  context: context,
                                  themeData: themeData,
                                  size: size,
                                  text: cubitHome.getText("listen") ?? "Listen",
                                  image: "assets/images/voice.png",
                                  isEn: cubitHome.isEn,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => const ListenScreen(),
                                    ));
                                  }),
                              buidGridItem(
                                  context: context,
                                  themeData: themeData,
                                  size: size,
                                  text: cubitHome.getText("Settings") ??
                                      "Settings",
                                  image: "assets/images/setting.png",
                                  isEn: cubitHome.isEn,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) =>
                                          SettingScreen(cubitTime: cubit),
                                    ));
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                );
              }
              return LoadingScreen(
                text: cubitHome.getText("Loading") ?? "Loading ...",
                isLTR: cubitHome.isEn,
              );
            });
      },
    );
  }

  GestureDetector buidGridItem(
      {required BuildContext context,
      required ThemeData themeData,
      required Size size,
      required String image,
      required String text,
      required bool isEn,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: themeData.backgroundColor.withOpacity(0.5),
        shadowColor: themeData.primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.only(top: 5),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Expanded(
                flex: isEn ? 2 : 1,
                child: Image.asset(
                  image,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextResponsive(text: text, maxSize: 20, size: size)
                      .headline3(
                    context,
                    bold: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
