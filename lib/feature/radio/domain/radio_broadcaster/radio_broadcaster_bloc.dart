import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:radio_r159000/feature/radio/domain/radio_event.dart';
import 'package:radio_r159000/util/logger.dart';

part 'radio_broadcaster_state.dart';

class RadioBroadcasterBloc extends Bloc<RadioEvent, RadioBroadcasterState> {
  final String callSign;
  final void Function(Object, StackTrace)? errorHandler;

  RadioBroadcasterBloc(
    this.callSign, [
    this.errorHandler,
  ]) : super(RadioBroadcasterInitial()) {
    on<BeginRadioEvent>(_handleBeginRadio);
    on<DataRadioEvent>(_handleDataRadio);
    on<EndRadioEvent>(_handleEndRadio);
    on<ErrorRadioEvent>(_handleError);
  }

  FutureOr<void> _handleBeginRadio(
    BeginRadioEvent event,
    Emitter<RadioBroadcasterState> emit,
  ) async {
    logger.d('receive event $event');
    final state = this.state;

    if (state is RadioBroadcasterInitial) {
      if (event.correspondent == callSign) {
        emit(
          BeginRadio(event.correspondent),
        );
      } else {
        emit(
          DataRadio(
            correspondent: event.correspondent,
            data: Uint8List(0),
          ),
        );
      }

      return;
    }

    if (state is DataRadio && state.correspondent == event.correspondent) {
      logger.d('skip event $event, already broadcasting');
      return;
    }

    if (state is! BeginRadio) {
      addError(
        ErrorRadioEvent(
          correspondent: event.correspondent,
          reason: 'The line is busy, please wait',
        ),
      );
      return;
    }

    if (state.correspondent != event.correspondent) {
      addError(
        ErrorRadioEvent(
          correspondent: event.correspondent,
          reason: 'The line is busy, another correspondent began broadcast',
        ),
      );
      return;
    }

    emit(
      DataRadio(
        correspondent: event.correspondent,
        data: Uint8List(0),
      ),
    );
  }

  FutureOr<void> _handleDataRadio(
    DataRadioEvent event,
    Emitter<RadioBroadcasterState> emit,
  ) async {
    final radioState = state;

    if (radioState is! DataRadio) {
      addError(
        ErrorRadioEvent(
          correspondent: event.correspondent,
          reason: 'The line is busy, unknown event',
        ),
      );
      return;
    }

    if (radioState.correspondent != event.correspondent) {
      addError(
        ErrorRadioEvent(
          correspondent: event.correspondent,
          reason: 'The line is busy, another correspondent began broadcast',
        ),
      );
      return;
    }

    emit(
      DataRadio(
        correspondent: event.correspondent,
        data: event.data,
      ),
    );
  }

  FutureOr<void> _handleEndRadio(
    EndRadioEvent event,
    Emitter<RadioBroadcasterState> emit,
  ) async {
    logger.d('receive event $event');
    final radioState = state;

    if (radioState is! DataRadio) {
      addError(
        ErrorRadioEvent(
          correspondent: event.correspondent,
          reason: 'The line is free, or status unknown',
        ),
      );
      return;
    }

    if (radioState.correspondent != event.correspondent) {
      addError(
        ErrorRadioEvent(
          correspondent: event.correspondent,
          reason: 'The line is busy',
        ),
      );
      return;
    }

    emit(EndRadio(event.correspondent));
    emit(RadioBroadcasterInitial());
  }

  FutureOr<void> _handleError(
    ErrorRadioEvent event,
    Emitter<RadioBroadcasterState> emit,
  ) async {
    if (event.correspondent != callSign) {
      return;
    }

    logger.e('error catch from remote  ${event.reason}');
    emit(RadioBroadcasterInitial());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (error is! ErrorRadioEvent) {
      logger.e(error);
    } else if (error.correspondent != callSign) {
      logger.e('error occurred  ${error.reason}');
    }

    errorHandler?.call(error, stackTrace);

    super.onError(error, stackTrace);
  }

  void addData(Uint8List data) {
    add(
      DataRadioEvent(
        correspondent: callSign,
        data: data,
      ),
    );
  }

  void begin() {
    add(
      BeginRadioEvent(callSign),
    );
  }

  void end() {
    add(
      EndRadioEvent(callSign),
    );
  }
}
