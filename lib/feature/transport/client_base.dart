import 'dart:io';

import 'package:radio_r159000/feature/transport/mapper.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';

class ClientBase implements TransportBase {
  late final WebSocket socket;
  final String url;

  ClientBase(this.url);

  @override
  Future<void> init() async {
    socket = await WebSocket.connect(url);
  }

  @override
  Stream<EventPocket> get eventStream => socket.asyncMap(transformEvents).asBroadcastStream();

  @override
  Future<void> notifyListeners(
    EventPocket data, [
    bool Function(String)? selector,
  ]) async {
    final json = await serializeJson(data);
    socket.add(json);
  }

  @override
  void dispose() {
    socket.close();
  }
}
