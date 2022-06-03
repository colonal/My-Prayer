part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetLanguageState extends HomeState {}

class GetModeState extends HomeState {}

class ChangeLanguageState extends HomeState {}

class ChangeModeState extends HomeState {}
