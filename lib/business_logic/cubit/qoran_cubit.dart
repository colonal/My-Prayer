import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../data/models/qoran.dart';

part 'qoran_state.dart';

class QoranCubit extends Cubit<QoranState> {
  QoranCubit() : super(QoranInitial());

  List qurans = [];

  Future<void> readJson() async {
    emit(QoranLodingState());
    final String responsr =
        await rootBundle.loadString("assets/quran/Quran.json");
    final data = await json.decode(responsr);

    qurans = data.map((data) => Qoran.fromJson(data)).toList();
    emit(GetQoranState());
  }
}
