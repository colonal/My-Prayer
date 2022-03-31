import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/themes/app_thime.dart';

import 'business_logic/cubit/time_prayer_cubit.dart';
import 'custom_scroll_behavior.dart';
import 'data/repository/time_prayer_repo.dart';
import 'data/wepservices/time_prayer_services.dart';
import 'presentation/screen/time_prayer/time_prayer_screen.dart';
import 'package:flutter_offline/flutter_offline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Prayer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      scrollBehavior: MyCustomScrollBehavior(),
      home: OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) {
          return BlocProvider(
            create: (context) {
              final bool connected = connectivity != ConnectivityResult.none;
              TimePrayerCubit(TimeRepository(PlacesWebServices())).onLine =
                  connected;
              if (connected) {
                return TimePrayerCubit(TimeRepository(PlacesWebServices()))
                  ..emitTimePrayerCubit();
              } else {
                return TimePrayerCubit(TimeRepository(PlacesWebServices()));
              }
            },
            child: const TimePrayerScreen(),
          );
        },
      ),
    );
  }
}
