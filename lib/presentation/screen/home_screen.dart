import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/azkar_cubit.dart';
import 'package:my_prayer/business_logic/cubit/qoran_cubit.dart';
import 'package:my_prayer/presentation/screen/Qoran/quran_screen.dart';
import 'package:my_prayer/presentation/screen/ayah/ayah_screen.dart';
import 'package:my_prayer/presentation/screen/azkar/azkar_screen.dart';
import 'package:my_prayer/presentation/screen/Qoran/pdf_screen.dart';
import 'package:my_prayer/presentation/screen/ayah/qoran_screen.dart';
import '../../business_logic/cubit/ayah_cubit.dart';
import '../widgets/show_data_time.dart';
import './time_prayer/time_prayer_screen.dart';

import '../../business_logic/cubit/time_prayer_cubit.dart';
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

    return BlocConsumer<TimePrayerCubit, TimePrayerState>(
        listener: (_, __) {},
        builder: (ctx, state) {
          final cubit = TimePrayerCubit.get(ctx);
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
                  cubit.emitTimePrayerCubit(
                      country: _country.split("    ")[1],
                      city: _state.split(" ")[0]);
                }
              },
            );
          }
          if (!cubit.lodingTimePrayer!) {
            // return const TimePrayerScreen();
            return Scaffold(
              backgroundColor: themeData.primaryColor,
              body: SafeArea(
                  child: Column(
                children: [
                  ShowDataTime(cubit: cubit, size: size),
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
                              text: "Time Prayer",
                              image: "assets/images/pray.png",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      TimePrayerScreen(cubit: cubit),
                                ));
                              }),
                          buidGridItem(
                              context: context,
                              themeData: themeData,
                              size: size,
                              text: "Ayah",
                              image: "assets/images/qoran.png",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
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
                              text: "Qoran",
                              image: "assets/images/qoran.png",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const PdfScreen(),
                                ));
                              }),
                          buidGridItem(
                              context: context,
                              themeData: themeData,
                              size: size,
                              text: "Qoran",
                              image: "assets/images/qoran.png",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: QoranCubit()..getFavorite(),
                                    child: const QuranScreen(),
                                  ),
                                ));
                              }),
                          buidGridItem(
                              context: context,
                              themeData: themeData,
                              size: size,
                              text: "Azkar",
                              image: "assets/images/prayer.png",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: AzkarCubit()..readJson(),
                                    child: const AzkarScreen(),
                                  ),
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
            text: cubit.getText("Loading") ?? "Loading ...",
            isLTR: cubit.isEn,
          );
        });
  }

  GestureDetector buidGridItem(
      {required BuildContext context,
      required ThemeData themeData,
      required Size size,
      required String image,
      required String text,
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
                flex: 2,
                child: Image.asset(
                  image,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextResponsive(text: text, maxSize: 20, size: size)
                      .headline3(context, bold: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
