import 'dart:async';

import 'package:radio_r159000/feature/radio/data/mapper.dart';
import 'package:radio_r159000/feature/radio/domain/radio_broadcaster/radio_broadcaster_bloc.dart';
import 'package:radio_r159000/feature/radio/domain/radio_handler.dart';
import 'package:radio_r159000/feature/radio/domain/radio_event.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/util/logger.dart';

class RadioServer extends RadioHandler {
  RadioServer({
    required super.callSign,
    required super.radioBroadcaster,
    required super.radioSubscriber,
    required super.transportBase,
  });

  @override
  void handleBroadcastErrors(Object error, [StackTrace? stackTrace]) {
    super.handleBroadcastErrors(error, stackTrace);

    if (error is! ErrorRadioEvent) {
      return;
    }

    if (error.correspondent != callSign) {
      transportBase.notifyListeners(
        EventPocket(
          names.endRadio,
          mapErrorEventToErrorEventDto(error),
          callSign,
        ),
        _targetCorrespondent(error.correspondent),
      );
    } else {
      radioBroadcaster.add(error);
    }
  }

  bool Function(String) _excludeCorrespondent(String correspondent) {
    return (c) => c != correspondent;
  }

  bool Function(String) _targetCorrespondent(String correspondent) {
    return (c) => c == correspondent;
  }

  @override
  RadioEvent? handleRadioStateUpdate(RadioBroadcasterState state) {
    final event = super.handleRadioStateUpdate(state);

    if (event is BeginRadioEvent) {
      if (event.correspondent == callSign) {
        radioBroadcaster.add(event);
      }

      transportBase.notifyListeners(
          EventPocket(
            names.beginRadio,
            mapRadioEventToNamedEventDto(event),
            callSign,
          ),
          _excludeCorrespondent(event.correspondent));
    }

    if (event is DataRadioEvent) {
      transportBase.notifyListeners(
        EventPocket(
          names.dataRadio,
          mapRadioDataToDataEventDto(event),
          callSign,
        ),
        _excludeCorrespondent(event.correspondent),
      );
    }

    if (event is EndRadioEvent) {
      transportBase.notifyListeners(
        EventPocket(
          names.endRadio,
          mapRadioEventToNamedEventDto(event),
          callSign,
        ),
        _excludeCorrespondent(event.correspondent),
      );
    }

    return event;
  }
}
