import 'package:radio_r159000/feature/radio/data/mapper.dart';
import 'package:radio_r159000/feature/radio/domain/radio_broadcaster/radio_broadcaster_bloc.dart';
import 'package:radio_r159000/feature/radio/domain/radio_handler.dart';
import 'package:radio_r159000/feature/radio/domain/radio_event.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';

class RadioClient extends RadioHandler {
  RadioClient({
    required super.callSign,
    required super.radioBroadcaster,
    required super.radioSubscriber,
    required super.transportBase,
  });

  @override
  RadioEvent? handleRadioStateUpdate(RadioBroadcasterState state) {
    final event = super.handleRadioStateUpdate(state);
    // logger.d('handle event $event');

    if (event is BeginRadioEvent && event.correspondent == callSign) {
      transportBase.notifyListeners(
        EventPocket(
          names.beginRadio,
          mapRadioEventToNamedEventDto(event),
          callSign,
        ),
      );
    }

    if (event is DataRadioEvent && event.correspondent == callSign) {
      transportBase.notifyListeners(
        EventPocket(
          names.dataRadio,
          mapRadioDataToDataEventDto(event),
          callSign,
        ),
      );
    }

    if (event is EndRadioEvent && event.correspondent == callSign) {
      transportBase.notifyListeners(
        EventPocket(
          names.endRadio,
          mapRadioEventToNamedEventDto(event),
          callSign,
        ),
      );
    }

    if (event is ErrorRadioEvent && event.correspondent == callSign) {
      transportBase.notifyListeners(
        EventPocket(
          names.endRadio,
          mapErrorEventToErrorEventDto(event),
          callSign,
        ),
      );
    }

    return event;
  }
}
