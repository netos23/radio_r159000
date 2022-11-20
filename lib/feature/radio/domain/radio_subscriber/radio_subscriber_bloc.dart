import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:radio_r159000/feature/radio/domain/radio_event.dart';

part 'radio_subscriber_state.dart';

class RadioSubscriberBloc extends Bloc<RadioEvent, RadioSubscriberState> {
  final String callSign;

  RadioSubscriberBloc(this.callSign) : super(RadioSubscriberInitial()) {
    on<BeginRadioEvent>(_handleBeginRadio);
    on<DataRadioEvent>(_handleDataRadio);
    on<EndRadioEvent>(_handleEndRadio);
  }

  FutureOr<void> _handleBeginRadio(
    BeginRadioEvent event,
    Emitter<RadioSubscriberState> emit,
  ) async {
    if (state is! RadioSubscriberData) {
      emit(
        RadioSubscriberData(
          correspondent: event.correspondent,
        ),
      );
    }

    //todo handle errors
  }

  FutureOr<void> _handleDataRadio(
    DataRadioEvent event,
    Emitter<RadioSubscriberState> emit,
  ) async {
    final radioState = state;
    // if (radioState is! RadioSubscriberData) {
    //   //todo handle errors
    //   return;
    // }
    //
    // if (radioState.correspondent != event.correspondent) {
    //   //todo handle errors
    //   return;
    // }

    emit(
      RadioSubscriberData(
        correspondent: event.correspondent,
        data: event.data,
      ),
    );
  }

  FutureOr<void> _handleEndRadio(
    EndRadioEvent event,
    Emitter<RadioSubscriberState> emit,
  ) async {
    final radioState = state;
    if (radioState is! RadioSubscriberData) {
      //todo handle errors
      return;
    }

    if (radioState.correspondent != event.correspondent) {
      //todo handle errors
      return;
    }

    emit(RadioSubscriberInitial());
  }

  Stream<Uint8List> get dataStream => stream.map(_mapToByteList);

  Stream<Uint8List> get rawDataStream => stream.map(_mapToRawByteList);

  Stream<String?> get correspondentStream => stream.map(_mapCorrespondent);

  Uint8List _mapToByteList(RadioSubscriberState event) {
    if (event is RadioSubscriberData && event.correspondent != callSign) {
      return event.data;
    }

    return Uint8List(0);
  }

  Uint8List _mapToRawByteList(RadioSubscriberState event) {
    if (event is RadioSubscriberData) {
      return event.data;
    }

    return Uint8List(0);
  }

  String? _mapCorrespondent(RadioSubscriberState event) {
    if (event is RadioSubscriberData) {
      return event.correspondent;
    }

    return null;
  }
}
