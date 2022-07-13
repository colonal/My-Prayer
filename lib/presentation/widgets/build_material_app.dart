import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/listen/listen_cubit.dart';
import '../screen/home_screen.dart';

import '../../business_logic/cubit/ayah/ayah_cubit.dart';
import '../../business_logic/cubit/azkar/azkar_cubit.dart';
import '../../business_logic/cubit/home/home_cubit.dart';
import '../../business_logic/cubit/time_prayer/time_prayer_cubit.dart';
import '../../custom_scroll_behavior.dart';
import '../../data/repository/time_prayer_repo.dart';
import '../../data/wepservices/time_prayer_services.dart';
import '../../themes/app_thime.dart';

class BuildMaterialApp extends StatelessWidget {
  const BuildMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getData(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return MaterialApp(
            title: 'My Prayer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: cubit.isDark == null
                ? ThemeMode.system
                : (cubit.isDark! ? ThemeMode.dark : ThemeMode.light),
            scrollBehavior: MyCustomScrollBehavior(),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<TimePrayerCubit>(
                  lazy: false,
                  create: (context) =>
                      TimePrayerCubit(TimeRepository(PlacesWebServices()))
                        ..getLanguage()
                        ..emitTimePrayerCubit1(),
                ),
                BlocProvider<AzkarCubit>(
                    create: (context) => AzkarCubit()..readJson()),
                BlocProvider<AyahCubit>(
                    create: (context) => AyahCubit()..readJson()),
              ],
              child: const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
