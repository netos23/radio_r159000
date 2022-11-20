import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_r159000/feature/audio_player/audio_player.dart';
import 'package:radio_r159000/feature/location/location_handler.dart';
import 'package:radio_r159000/feature/radio/domain/radio_broadcaster/radio_broadcaster_bloc.dart';
import 'package:radio_r159000/feature/radio/domain/radio_client.dart';
import 'package:radio_r159000/feature/radio/domain/radio_subscriber/radio_subscriber_bloc.dart';
import 'package:radio_r159000/feature/recorder/recorder.dart';
import 'package:radio_r159000/feature/transport/client_base.dart';
import 'package:radio_r159000/feature/transport/server_base.dart';
import 'package:radio_r159000/presentation/navigation/navigation.dart';
import 'package:radio_r159000/presentation/screen/connect/model/client_configuration.dart';
import 'package:radio_r159000/presentation/screen/radio/models/radio_client.dart';
import 'radio_screen_model.dart';
import 'radio_screen_widget.dart';

abstract class IRadioScreenWidgetModel extends IWidgetModel {
  Stream<List<int>> get soundStream;

  EntityStateNotifier<List<ConnectedRadioClient>> get clientsState;

  void beginBroadcast();

  void endBroadcast();

  Color getSignalColor(int signal);
}

WidgetModelFactory createClientRadioScreenWidgetModelFactory(
  ClientConfiguration configuration,
) {
  final subscriber = RadioSubscriberBloc(configuration.name);
  final broadcaster = RadioBroadcasterBloc(configuration.name);
  final player = AudioPlayer(audioStream: subscriber.dataStream);
  final recorder = Recorder(sink: broadcaster.addData);
  final transport = ClientBase('ws://${configuration.ip}:3000/ws');
  final handler = RadioClient(
    callSign: configuration.name,
    radioBroadcaster: broadcaster,
    radioSubscriber: subscriber,
    transportBase: transport,
  );
  final location = LocationHandler(transport, configuration.name);

  return (context) {
    return RadioScreenWidgetModel(
      RadioScreenModel(
        errorHandler: context.read(),
        subscriber: subscriber,
        broadcaster: broadcaster,
        player: player,
        recorder: recorder,
        handler: handler,
        transportBase: transport,
        locationHandler: location,
      ),
      context.read(),
    );
  };
}

WidgetModelFactory createServerRadioScreenWidgetModelFactory(
  String name,
) {
  return (context) {
    final subscriber = RadioSubscriberBloc(name);
    final broadcaster = RadioBroadcasterBloc(name);
    final player = AudioPlayer(audioStream: subscriber.dataStream);
    final recorder = Recorder(sink: broadcaster.addData);
    final transport = ServerBase();
    final handler = RadioClient(
      callSign: name,
      radioBroadcaster: broadcaster,
      radioSubscriber: subscriber,
      transportBase: transport,
    );
    final location = LocationHandler(transport, name);

    return RadioScreenWidgetModel(
      RadioScreenModel(
        errorHandler: context.read(),
        subscriber: subscriber,
        broadcaster: broadcaster,
        player: player,
        recorder: recorder,
        handler: handler,
        transportBase: transport,
        locationHandler: location,
      ),
      context.read(),
    );
  };
}

// TODO: cover with documentation
/// Default widget model for RadioScreenWidget
class RadioScreenWidgetModel
    extends WidgetModel<RadioScreenWidget, RadioScreenModel>
    implements IRadioScreenWidgetModel {
  RadioScreenWidgetModel(
    RadioScreenModel model,
    this.navigation,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    model.locationHandler.locations
        .map(
          (event) => event.entries
              .map(
                (v) => ConnectedRadioClient(
                    name: v.key, mute: false, signal: v.value),
              )
              .toList(),
        )
        .listen(clientsState.content);
  }

  @override
  void dispose() {
    clientsState.dispose();
    super.dispose();
  }

  final Navigation navigation;

  @override
  Stream<List<int>> get soundStream => model.subscriber.rawDataStream;

  @override
  void beginBroadcast() {
    model.begin();
  }

  @override
  void endBroadcast() {
    model.end();
  }

  @override
  final EntityStateNotifier<List<ConnectedRadioClient>> clientsState =
      EntityStateNotifier();

  @override
  Color getSignalColor(int signal) {
    if (signal > 70) {
      return Colors.green;
    } else if (signal > 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
