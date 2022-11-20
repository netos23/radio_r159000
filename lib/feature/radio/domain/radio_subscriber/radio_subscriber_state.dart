part of 'radio_subscriber_bloc.dart';

@immutable
abstract class RadioSubscriberState {}

class RadioSubscriberInitial extends RadioSubscriberState {}

class RadioSubscriberData extends RadioSubscriberState {
  final String correspondent;
  final Uint8List data;

  RadioSubscriberData({
    required this.correspondent,
    Uint8List? data,
  }) : data = data ?? Uint8List(0);
}
