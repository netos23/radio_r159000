import 'package:radio_r159000/feature/transport/model/event_pocket.dart';

abstract class TransportBase {
  Stream<EventPocket> get eventStream;

  Future<void> init();

  Future<void> notifyListeners(
    EventPocket data, [
    bool Function(String)? selector,
  ]);

  void dispose();
}
