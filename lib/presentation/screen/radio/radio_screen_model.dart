import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:radio_r159000/feature/audio_player/audio_player.dart';
import 'package:radio_r159000/feature/location/location_handler.dart';
import 'package:radio_r159000/feature/location/model/location_info.dart';
import 'package:radio_r159000/feature/radio/domain/radio_broadcaster/radio_broadcaster_bloc.dart';
import 'package:radio_r159000/feature/radio/domain/radio_handler.dart';
import 'package:radio_r159000/feature/radio/domain/radio_subscriber/radio_subscriber_bloc.dart';
import 'package:radio_r159000/feature/recorder/recorder.dart';
import 'package:radio_r159000/feature/transport/transport_base.dart';
import 'package:wifi_iot/wifi_iot.dart';

// TODO: cover with documentation
/// Default Elementary model for RadioScreen module
class RadioScreenModel extends ElementaryModel {
  RadioScreenModel({
    required ErrorHandler errorHandler,
    required this.subscriber,
    required this.broadcaster,
    required this.handler,
    required this.player,
    required this.recorder,
    required this.transportBase,
    required this.locationHandler,
  }) : super(errorHandler: errorHandler);

  final RadioSubscriberBloc subscriber;
  final RadioBroadcasterBloc broadcaster;
  final RadioHandler handler;
  final AudioPlayer player;
  final Recorder recorder;
  final TransportBase transportBase;
  final LocationHandler locationHandler;
  late final Timer _locationPuller;

  @override
  void init() {
    super.init();
    _init();
  }

  Future<void> _init() async {
    await transportBase.init();
    handler.init();
    locationHandler.init();
    _locationPuller = Timer.periodic(
      const Duration(seconds: 2),
      addLocation,
    );
  }

  Future<void> addLocation(Timer timer) async {
    final signal = (await WiFiForIoTPlugin.getCurrentSignalStrength()) ?? 0;
    locationHandler.addLocationInfo(
      LocationInfo(
        locationHandler.callId,
        signal,
      ),
    );
  }

  @override
  void dispose() {
    _locationPuller.cancel();
    transportBase.dispose();
    player.dispose();
    recorder.dispose();
    handler.dispose();
    locationHandler.dispose();
    broadcaster.close();
    subscriber.close();
    super.dispose();
  }

  void begin() async {
    broadcaster.begin();
    await recorder.startRecord();
  }

  void end() {
    broadcaster.end();
    recorder.stopRecorder();
  }
}
