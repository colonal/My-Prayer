import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/qoran_cubit.dart';
import 'package:my_prayer/presentation/screen/home_screen.dart';
import 'package:my_prayer/themes/app_thime.dart';

import 'business_logic/cubit/time_prayer_cubit.dart';
import 'custom_scroll_behavior.dart';
import 'data/repository/time_prayer_repo.dart';
import 'data/wepservices/time_prayer_services.dart';

void main() => BlocOverrides.runZoned(
      () => runApp(const MyApp()),
      blocObserver: MyBlocObserver(),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Prayer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      scrollBehavior: MyCustomScrollBehavior(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TimePrayerCubit>(
            lazy: false,
            create: (context) =>
                TimePrayerCubit(TimeRepository(PlacesWebServices()))
                  ..emitTimePrayerCubit(),
          ),
          BlocProvider<QoranCubit>(
            lazy: false,
            create: (context) => QoranCubit()..readJson(),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
