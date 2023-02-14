import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: AppColor.bodyColorDark,
  scaffoldBackgroundColor: AppColor.bodyColorDark,
  hintColor: AppColor.textColorDark,
  primaryColorLight: AppColor.buttonBackgroundColorDark,
  primaryColor: AppColor.buttonBackgroundColorDark,
  primaryColorDark: AppColor.bodyColor,
  cardColor: AppColor.buttonBackgroundColor,
  dividerColor: const Color(0xff2e2e2e).withOpacity(0.8),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 60,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: AppColor.buttonBackgroundColorDark),
);
