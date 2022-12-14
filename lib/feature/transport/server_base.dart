import 'dart:async';
import 'dart:io';

import 'package:radio_r159000/feature/transport/mapper.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;

class ServerBase implements TransportBase {
  late final HttpServer _server;
  late final StreamSubscription<HttpRequest> _subscription;
  final List<WebSocket> _clients = [];
  final Map<WebSocket, Set<String>> _names = {};
  final List<StreamSubscription<EventPocket>> _clientsSubscriptions = [];
  final StreamController<EventPocket> _eventController =
      StreamController.broadcast();

  @override
  Stream<EventPocket> get eventStream => _eventController.stream;

  ServerBase();

  @override
  Future<void> init() async {
    _server = await HttpServer.bind(
      InternetAddress('0.0.0.0'),
      3000,
    );
    _subscription = _server.listen(_handleRequests);
  }

  Future<void> _handleRequests(HttpRequest request) async {
    if (request.uri.path == names.ping) {
      request.response.write('ok');
      await request.response.close();
    }
    if (request.uri.path == names.ws) {
      // logger.d('Handle new connection');

      final socket = await WebSocketTransformer.upgrade(request);
      _clients.add(socket);

      final subscription = socket
          .asyncMap(transformEvents)
          .map((p) => _captureNames(p, socket))
          .listen(_eventController.add);

      _clientsSubscriptions.add(subscription);
    }
  }

  EventPocket _captureNames(EventPocket pocket, WebSocket socket) {
    final names = _names.putIfAbsent(socket, () => {});
    final name = pocket.owner;

    if (!names.contains(name)) {
      names.add(name);
    }

    return pocket;
  }

  @override
  Future<void> notifyListeners(
    EventPocket data, [
    bool Function(String)? selector,
  ]) async {
    final json = await serializeJson(data);
    selector ??= (_) => true;

    for (final client in _clients) {
      final selected = _names[client]?.any(selector) ?? true;

      if (selected) {
        client.add(json);
      }
    }
  }

  @override
  Future<void> dispose() async {
    for (final clientsSubscription in _clientsSubscriptions) {
      await clientsSubscription.cancel();
    }
    await _subscription.cancel();
    await _eventController.close();
    await _server.close();
  }
}
