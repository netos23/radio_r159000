import 'dart:io';

import 'package:radio_r159000/feature/transport/mapper.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';

class ClientBase implements TransportBase{
  final WebSocket socket;

  ClientBase(this.socket);

  @override
  Stream<EventPocket> get eventStream =>
      socket.asyncMap(transformEvents);

  @override
  Future<void> notifyListeners(
    EventPocket data, [
    bool Function(String)? selector,
  ]) async {
    final json = await serializeJson(data);
    socket.add(json);
  }
}
