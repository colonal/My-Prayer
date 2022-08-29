import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constnats/language.dart';

import '../../../constnats/quran.dart';
import '../../../helpers/cache_helper.dart';

part 'qoran_state.dart';

class QoranCubit extends Cubit<QoranState> {
  QoranCubit() : super(QoranInitial());

  static QoranCubit get(context) => BlocProvider.of(context);

  int page = 1;
  double opacity = 1;
  bool showMenu = true;
  int indexQuranInfo = 0;
  int? indexFavorite;
  bool isEn = false;

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
  }

  void getFavorite() {
    indexFavorite = CacheHelper.getData(key: 'favoriteQuran');
  }

  void saveFavorite() {
    indexFavorite = page - 1;
    CacheHelper.saveData(key: 'favoriteQuran', value: page - 1);
    emit(SaveFavoriteState());
  }

  void closeMenu() {
    opacity = opacity == 1 ? 0 : 1;
    showMenu = !showMenu;
    emit(ChangeShowMenuState());
  }

  void openMenu() {
    opacity = opacity == 1 ? 0 : 1;
    emit(ChangeShowMenuState());

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        showMenu = !showMenu;
        emit(ChangeShowMenuState());
      },
    );
  }

  void changePage(indexPage) {
    page = indexPage + 1;

    for (int index = 0; index < quranInfo.length; ++index) {
      if (quranInfo[index]["Number_Page"] <= page &&
          page <
              quranInfo[index + 1 >= 114 ? index : index + 1]["Number_Page"]) {
        indexQuranInfo = index;
        break;
      } else {
        indexQuranInfo = 113;
      }
    }

    emit(ChangePageState());
  }

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }
}
