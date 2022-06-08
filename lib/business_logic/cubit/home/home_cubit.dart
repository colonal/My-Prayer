import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constnats/language.dart';
import '../../../helpers/cache_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  bool isEn = false;
  bool? isDark;

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }

  void getData() {
    getMode();
    getLanguage();
  }

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
    emit(GetLanguageState());
  }

  void getMode() {
    isDark = CacheHelper.getData(key: "isDark");
    emit(GetModeState());
  }

  void changeLanguage() {
    isEn = !isEn;
    CacheHelper.saveData(key: "Language", value: isEn);
    emit(ChangeLanguageState());
  }

  void changeMode(context) {
    if (isDark != null) {
      isDark = !isDark!;
    } else {
      isDark = !isDarkModeSystem(context);
    }
    CacheHelper.saveData(key: "isDark", value: isDark);
    emit(ChangeModeState());
  }

  bool isDarkModeSystem(context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }
}
