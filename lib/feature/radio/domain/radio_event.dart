import 'dart:typed_data';
import 'package:meta/meta.dart';

@immutable
abstract class RadioEvent {
  final String correspondent;

  const RadioEvent(this.correspondent);
}

@immutable
class BeginRadioEvent extends RadioEvent {
  const BeginRadioEvent(super.correspondent);
}

@immutable
class DataRadioEvent extends RadioEvent {
  final Uint8List data;

  const DataRadioEvent({
    required String correspondent,
    required this.data,
  }) : super(correspondent);
}

@immutable
class EndRadioEvent extends RadioEvent {
  const EndRadioEvent(super.correspondent);
}

@immutable
class ErrorRadioEvent extends RadioEvent {
  final String reason;

  const ErrorRadioEvent({
    required String correspondent,
    required this.reason,
  }) : super(correspondent);
}
