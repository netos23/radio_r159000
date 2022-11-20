import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radio_r159000/feature/audio_player/audio_player.dart';
import 'package:radio_r159000/feature/radio/domain/radio_broadcaster/radio_broadcaster_bloc.dart';
import 'package:radio_r159000/feature/radio/domain/radio_client.dart';
import 'package:radio_r159000/feature/radio/domain/radio_handler.dart';
import 'package:radio_r159000/feature/radio/domain/radio_server.dart';
import 'package:radio_r159000/feature/radio/domain/radio_subscriber/radio_subscriber_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:radio_r159000/feature/recorder/recorder.dart';
import 'package:radio_r159000/feature/transport/client_base.dart';
import 'package:radio_r159000/feature/transport/server_base.dart';
import 'package:radio_r159000/presentation/app/app.dart';
import 'package:radio_r159000/presentation/app/app_dependencies.dart';
import 'package:radio_r159000/presentation/screen/radio/components/waves.dart';
import 'package:radio_r159000/util/logger.dart';
import 'package:uuid/uuid.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.microphone,
    Permission.camera,
  ].request();

  runApp(
    const AppDependencies(
      app: RadioApp(),
    ),
  );
}

class MyAppTest extends StatelessWidget {
  const MyAppTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => const MenuScreen(),
        '/server': (_) => const ServerScreen(),
        '/client': (_) => const ClientScreen(),
      },
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/client');
              },
              child: const Text(
                'client',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/server');
              },
              child: const Text(
                'server',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final callId = '';
  late final RadioSubscriberBloc subscriber = RadioSubscriberBloc(callId);
  late final RadioBroadcasterBloc broadcaster = RadioBroadcasterBloc(callId);
  late final WebSocket socket;
  late final RadioHandler client;
  late final ClientBase clientBase;
  late final AudioPlayer player;
  late final Recorder recorder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () async {
                broadcaster.begin();
                await recorder.startRecord();
              },
              onLongPressUp: () {
                broadcaster.end();
                recorder.stopRecorder();
              },
              child: Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(100),
                child: const Text('ping'),
              ),
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    NetworkInfo().getWifiGatewayIP().then((value) async {
      logger.i(value);
      /*socket.cast<List<int>>().transform(utf8.decoder).listen((e) {
        print('begin pocket:');
        print(e);
        print('end pocket:');
      });*/
      clientBase = ClientBase('ws://$value:3000/ws');
      client = RadioClient(
        callSign: callId,
        radioBroadcaster: broadcaster,
        radioSubscriber: subscriber,
        transportBase: clientBase,
      );
      player = AudioPlayer(audioStream: subscriber.dataStream);
      recorder = Recorder(sink: broadcaster.addData);
      // client = RadioClient(bloc, socket);
    });
  }

//10.136.61.210
  //192.168.192.226
  //255.255.255.0
  @override
  void dispose() {
    super.dispose();
    subscriber.close();
    broadcaster.close();
    client.dispose();
    player.dispose();
    socket.close();
  }
}

class ServerScreen extends StatefulWidget {
  const ServerScreen({Key? key}) : super(key: key);

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  final callId = '';
  late final RadioSubscriberBloc subscriber = RadioSubscriberBloc(callId);
  late final RadioBroadcasterBloc broadcaster = RadioBroadcasterBloc(callId);
  late final HttpServer socket;
  late final RadioServer client;
  late final ServerBase clientBase;
  late final AudioPlayer player;
  late final Recorder recorder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () async {
                broadcaster.begin();
                await recorder.startRecord();
              },
              onLongPressUp: () {
                broadcaster.end();
                recorder.stopRecorder();
              },
              child: Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(100),
                child: const Text('ping'),
              ),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    subscriber.close();
    broadcaster.close();
    client.dispose();
    player.dispose();
    socket.close();
  }

  Future<void> _init() async {
    clientBase = ServerBase();
    client = RadioServer(
      callSign: callId,
      radioBroadcaster: broadcaster,
      radioSubscriber: subscriber,
      transportBase: clientBase,
    );
    player = AudioPlayer(audioStream: subscriber.dataStream);
    recorder = Recorder(sink: broadcaster.addData);
    /*socket.listen((HttpRequest req) async {
      if (req.uri.path == '/ws') {
        var socket = await WebSocketTransformer.upgrade(req);
        socket.listen((e) {
          print('begin pocket:');
          print(e);
          print('end pocket:');
        });
        connections.add(socket);
      }
    });*/
    /*socket = await ServerSocket.bind(
      InternetAddress('0.0.0.0'),
      3000,
    );

    print('start server 0.0.0.0');
    socket.listen((connection) {
      connection.cast<List<int>>().transform(utf8.decoder).listen((e) {
        print('begin pocket:');
        print(e);
        print('end pocket:');
      });
      connections.add(connection);
    });*/
  }
}
