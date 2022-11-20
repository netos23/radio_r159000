import 'package:flutter/foundation.dart';
import 'package:radio_r159000/feature/radio/data/model/error_event.dart';
import 'package:radio_r159000/feature/radio/data/model/name_event.dart';
import 'package:radio_r159000/feature/radio/data/model/name_with_data_event.dart';
import 'package:radio_r159000/feature/radio/domain/radio_event.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;
import 'package:radio_r159000/util/logger.dart';

BeginRadioEvent mapNameEventDtoToBeginEvent(NameEventDto data) {
  return BeginRadioEvent(data.name);
}

DataRadioEvent mapDataEventDtoToDataEvent(NameWithDataEventDto data) {
  return DataRadioEvent(
    correspondent: data.name,
    data: Uint8List.fromList(data.bytes),
  );
}

EndRadioEvent mapNameEventDtoToEndEvent(NameEventDto data) {
  return EndRadioEvent(data.name);
}

ErrorRadioEvent mapErrorEventDtoToErrorEvent(ErrorEventDto data) {
  return ErrorRadioEvent(
    correspondent: data.name,
    reason: data.reason,
  );
}

NameEventDto mapRadioEventToNamedEventDto(RadioEvent event) {
  return NameEventDto(
    event.correspondent,
  );
}

NameWithDataEventDto mapRadioDataToDataEventDto(DataRadioEvent event) {
  return NameWithDataEventDto(
    event.correspondent,
    event.data,
  );
}

ErrorEventDto mapErrorEventToErrorEventDto(ErrorRadioEvent event) {
  return ErrorEventDto(
    event.correspondent,
    event.reason,
  );
}

RadioEvent mapRadioEvents(EventPocket pocket) {
  // logger.d('map event ${pocket.payload}');
  switch (pocket.eventName) {
    case names.beginRadio:
      final data = NameEventDto.fromJson(pocket.payload);
      return mapNameEventDtoToBeginEvent(data);
    case names.dataRadio:
      final data = NameWithDataEventDto.fromJson(pocket.payload);
      return mapDataEventDtoToDataEvent(data);
    case names.endRadio:
      final data = NameEventDto.fromJson(pocket.payload);
      return mapNameEventDtoToEndEvent(data);
    case names.errorRadio:
      final data = ErrorEventDto.fromJson(pocket.payload);
      return mapErrorEventDtoToErrorEvent(data);
  }

  throw ArgumentError('Unsupported event type');
}
