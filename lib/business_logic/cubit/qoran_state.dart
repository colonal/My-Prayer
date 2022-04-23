part of 'qoran_cubit.dart';

@immutable
abstract class QoranState {}

class QoranInitial extends QoranState {}

class QoranLodingState extends QoranState {}

class GetQoranState extends QoranState {}

class ChangeShowMenuState extends QoranState {}

class ChangePageState extends QoranState {}
