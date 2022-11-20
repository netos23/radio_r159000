import 'dart:async';
import 'dart:io';

import 'package:radio_r159000/feature/transport/mapper.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';

class ClientBase implements TransportBase {
  late final WebSocket socket;
  final String url;
  final StreamController<EventPocket> _eventController =
      StreamController.broadcast();
  late final StreamSubscription<EventPocket> _subscription;

  ClientBase(this.url);

  @override
  Future<void> init() async {
    socket = await WebSocket.connect(url);

    _subscription =
        socket.asyncMap(transformEvents).listen(_eventController.add);
  }

  @override
  Stream<EventPocket> get eventStream => _eventController.stream;

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
    _subscription.cancel();
    socket.close();
    _eventController.close();
  }
}
