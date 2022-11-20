import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:radio_r159000/feature/location/mapper.dart';
import 'package:radio_r159000/feature/location/model/location_info.dart';
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;

class LocationHandler {
  final String callId;
  final TransportBase transportBase;
  final Map<String, int> _locations = {};
  late final StreamSubscription<LocationInfo> _locationInfoSubscription;

  final StreamController<Map<String, int>> _controller =
      StreamController.broadcast();

  LocationHandler(
    this.transportBase,
    this.callId,
  );

  void init() {
    _locationInfoSubscription = transportBase.eventStream
        .where(_filterLocationEvents)
        .asyncMap(mapLocationEvents)
        .listen(handleEvent);
  }

  bool _filterLocationEvents(event) => event.eventName == names.location;

  Stream<Map<String, int>> get locations => _controller.stream;

  @mustCallSuper
  void handleEvent(LocationInfo info) {
    notifyLocations(info);
  }

  void notifyLocations(LocationInfo info) {
     _locations[info.name] = info.signal;
    _controller.add(_locations);
  }

  void addLocationInfo(LocationInfo info) {
    transportBase.notifyListeners(
      EventPocket(
        names.location,
        info,
        callId,
      ),
    );
  }

  void dispose() {
    _controller.close();
    _locationInfoSubscription.cancel();
  }
}
