import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../constnats/language.dart';
import '../../helpers/cache_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  bool isEn = false;
  bool isDark = false;

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
    emit(GetLanguageState());
  }

  void getMode() {
    isDark = CacheHelper.getData(key: "isDark") ?? false;
    emit(GetModeState());
  }

  void changeLanguage() {
    isEn = !isEn;
    CacheHelper.saveData(key: "Language", value: isEn);
    emit(ChangeLanguageState());
  }

  void changeMode() {
    isDark = !isDark;
    CacheHelper.saveData(key: "isDark", value: isDark);
    emit(ChangeModeState());
  }
}
