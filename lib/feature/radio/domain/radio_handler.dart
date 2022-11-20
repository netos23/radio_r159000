import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:radio_r159000/feature/radio/data/mapper.dart';
import 'package:radio_r159000/feature/radio/domain/radio_broadcaster/radio_broadcaster_bloc.dart';
import 'package:radio_r159000/feature/radio/domain/radio_event.dart';
import 'package:radio_r159000/feature/radio/domain/radio_subscriber/radio_subscriber_bloc.dart';
import 'package:radio_r159000/feature/common/constant.dart' as names;
import 'package:radio_r159000/feature/transport/model/event_pocket.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';
import 'package:radio_r159000/util/logger.dart';

abstract class RadioHandler {
  static const Set<String> allowedEvents = {
    names.beginRadio,
    names.endRadio,
    names.dataRadio,
    names.errorRadio,
  };

  final String callSign;
  final RadioSubscriberBloc radioSubscriber;
  final RadioBroadcasterBloc radioBroadcaster;
  final TransportBase transportBase;

  late final StreamSubscription _broadcasterSubscription;
  late final StreamSubscription _eventSubscription;

  RadioHandler({
    required this.transportBase,
    required this.callSign,
    required this.radioBroadcaster,
    required this.radioSubscriber,
  });

  void init(){
    _eventSubscription = transportBase.eventStream
        .where(_filterReceivedEvents)
        .map(mapRadioEvents)
        .listen(radioBroadcaster.add);

    _broadcasterSubscription = radioBroadcaster.stream
        .map(handleRadioStateUpdate)
        .where(_filterBroadcastEvents)
        .cast<RadioEvent>()
        .listen(
      radioSubscriber.add,
      onError: handleBroadcastErrors,
    );
  }

  bool _filterBroadcastEvents(RadioEvent? event) =>
      event != null && callSign != event.correspondent;

  bool _filterReceivedEvents(EventPocket event) =>
      allowedEvents.contains(event.eventName);

  @mustCallSuper
  void handleBroadcastErrors(Object error, [StackTrace? stackTrace]) {
    logger.w('The line is busy, please wait');
  }

  @mustCallSuper
  RadioEvent? handleRadioStateUpdate(RadioBroadcasterState state) {
    if (state is BeginRadio) {
      return BeginRadioEvent(
        state.correspondent,
      );
    }

    if (state is DataRadio) {
      return DataRadioEvent(
        correspondent: state.correspondent,
        data: state.data,
      );
    }

    if (state is EndRadio) {
      return EndRadioEvent(
        state.correspondent,
      );
    }

    return null;
  }

  void dispose() {
    _eventSubscription.cancel();
    _broadcasterSubscription.cancel();
  }
}
