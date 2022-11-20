import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';

FutureOr<EventPocket> transformEvents(dynamic encodedEventDto) async {
  if (encodedEventDto is! String) {
    throw ArgumentError('Support only text messages');
  }

  final json = await compute(jsonDecode, encodedEventDto);
  final eventPocket = EventPocket.fromJson(json);

  return eventPocket;
}

Future<String> serializeJson(EventPocket data) async => await compute(
      jsonEncode,
      data.toJson(),
    );
