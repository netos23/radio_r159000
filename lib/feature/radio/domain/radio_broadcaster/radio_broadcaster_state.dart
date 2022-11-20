part of 'radio_broadcaster_bloc.dart';

@immutable
abstract class RadioBroadcasterState {}

class RadioBroadcasterInitial extends RadioBroadcasterState {}

@immutable
class BeginRadio implements RadioBroadcasterState {
  final String correspondent;

  const BeginRadio(this.correspondent);
}

@immutable
class DataRadio implements RadioBroadcasterState {
  final String correspondent;
  final Uint8List data;

  const DataRadio({
    required this.correspondent,
    required this.data,
  });
}

@immutable
class EndRadio implements RadioBroadcasterState {
  final String correspondent;

  const EndRadio(this.correspondent);
}

@immutable
class ErrorRadio implements RadioBroadcasterState {
  final String correspondent;
  final String reason;

  const ErrorRadio({
    required this.correspondent,
    required this.reason,
  });
}
