part of 'ayah_cubit.dart';

@immutable
abstract class AyahState {}

class AyahInitial extends AyahState {}

class AyahLodingState extends AyahState {}

class GetAyahState extends AyahState {}

class IndexPageState extends AyahState {}

class ChangeSaveAyahState extends AyahState {}

class AddVersesFavoriteState extends AyahState {}

class ChangeIsFavoriteState extends AyahState {}
