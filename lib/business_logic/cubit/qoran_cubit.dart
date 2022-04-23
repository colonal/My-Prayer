import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constnats/quran.dart';
import '../../data/models/qoran.dart';
import '../../helpers/cache_helper.dart';

part 'qoran_state.dart';

class QoranCubit extends Cubit<QoranState> {
  QoranCubit() : super(QoranInitial());

  static QoranCubit get(context) => BlocProvider.of(context);

  List qurans = [];

  Future<void> readJson() async {
    emit(QoranLodingState());
    final String responsr =
        await rootBundle.loadString("assets/quran/Quran.json");
    final data = await json.decode(responsr);

    qurans = data.map((data) => Qoran.fromJson(data)).toList();
    emit(GetQoranState());
  }

  int page = 1;
  double opacity = 1;
  bool showMenu = true;
  int indexQuranInfo = 0;
  int? indexFavorite;

  void getFavorite() {
    indexFavorite = CacheHelper.getData(key: 'favoriteQuran');
  }

  void saveFavorite() {
    indexFavorite = page;
    CacheHelper.saveData(key: 'favoriteQuran', value: page);
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
      const Duration(milliseconds: 400),
      () {
        showMenu = !showMenu;
        emit(ChangeShowMenuState());
      },
    );
  }

  void changePage(indexPage) {
    page = indexPage + 1;
    // debugPrint("=" * 10);
    // debugPrint("index: $indexPage");
    // debugPrint("quranInfo.length: ${quranInfo.length}");
    for (int index = 0; index < quranInfo.length; ++index) {
      debugPrint("index: $index");
      // debugPrint(
      //     "${quranInfo[index]["Number_Page"] <= page && page < quranInfo[index + 1]["Number_Page"]}");
      if (quranInfo[index]["Number_Page"] <= page &&
          page < quranInfo[index + 1]["Number_Page"]) {
        indexQuranInfo = index;
        // debugPrint("indexQuranInfo 0: $indexQuranInfo");
        break;
      }
    }
    debugPrint("indexQuranInfo: $indexQuranInfo");
    debugPrint("page: $page");
    emit(ChangePageState());
  }
}
