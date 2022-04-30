import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_prayer/presentation/screen/onboarding_screen.dart';
import 'package:my_prayer/presentation/widgets/build_material_app.dart';

import 'business_logic/cubit/time_prayer_cubit.dart';

import 'helpers/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  bool onboarding = CacheHelper.getData(key: "onboarding") ?? false;
  BlocOverrides.runZoned(
    () => runApp(MyApp(onboarding)),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp(this.onboarding, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !onboarding
        ? const MaterialApp(
            home: OnboardingScreen(), debugShowCheckedModeBanner: false)
        : const BuildMaterialApp();
  }
}
