import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_prayer/data/models/azkar.dart';

part 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());
  static AzkarCubit get(context) => BlocProvider.of(context);

  Map azkars = {};

  Future<void> readJson() async {
    print("readJson");
    emit(AzkarLodingState());
    final String responsr =
        await rootBundle.loadString("assets/quran/azkar.json");
    final data = await json.decode(responsr);

    for (var i in data) {
      if (!azkars.containsKey(i["category"])) {
        azkars[i["category"]] = [
          Azkar.fromJson(i),
        ];
      } else {
        azkars[i["category"]].add(Azkar.fromJson(i));
      }
    }
    emit(GetAzkarState());
  }
}
