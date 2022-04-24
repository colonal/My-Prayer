import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/ayah_cubit.dart';
import 'package:my_prayer/business_logic/cubit/home_cubit.dart';
import 'package:my_prayer/presentation/screen/home_screen.dart';
import 'package:my_prayer/themes/app_thime.dart';

import 'business_logic/cubit/azkar_cubit.dart';
import 'business_logic/cubit/time_prayer_cubit.dart';
import 'custom_scroll_behavior.dart';
import 'data/repository/time_prayer_repo.dart';
import 'data/wepservices/time_prayer_services.dart';
import 'helpers/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return MaterialApp(
            title: 'My Prayer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            scrollBehavior: MyCustomScrollBehavior(),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<TimePrayerCubit>(
                  lazy: false,
                  create: (context) =>
                      TimePrayerCubit(TimeRepository(PlacesWebServices()))
                        ..emitTimePrayerCubit(),
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
