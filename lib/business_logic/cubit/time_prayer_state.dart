part of 'time_prayer_cubit.dart';

@immutable
abstract class TimePrayerState {}

class TimePrayerInitial extends TimePrayerState {}

class EmitTimePrayerState extends TimePrayerState {}

class EmitTimePrayerLodingState extends TimePrayerState {}

class DufrantTimeState extends TimePrayerState {}

class UserLocationError extends TimePrayerState {}

class ShowInfoState extends TimePrayerState {}
