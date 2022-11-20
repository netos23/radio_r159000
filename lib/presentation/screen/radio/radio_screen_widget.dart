import 'dart:math';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:radio_r159000/presentation/screen/radio/components/waves.dart';
import 'radio_screen_wm.dart';

// TODO: cover with documentation
/// Main widget for RadioScreen module
class RadioScreenWidget extends ElementaryWidget<IRadioScreenWidgetModel> {
  const RadioScreenWidget({
    Key? key,
    required WidgetModelFactory wmFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IRadioScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Text('Радиостанция'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              RadioButton(
                soundData: wm.soundStream,
                beginBroadcast: wm.beginBroadcast,
                endBroadcast: wm.endBroadcast,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: EntityStateNotifierBuilder(
                  listenableEntityState: wm.clientsState,
                  builder: (context, data) {
                    if (data == null || data.isEmpty) {
                      return const Center(
                        child: Text(
                          'Здесь будут появляться данные о людях '
                          'подключенных к одной радиосети',
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final client = data[index];
                        return RadioClientTile(
                          name: client.name,
                          signalColor: wm.getSignalColor(client.signal),
                          signal: client.signal,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 10,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioClientTile extends StatelessWidget {
  const RadioClientTile({
    Key? key,
    required this.name,
    this.mute = false,
    this.onMute,
    required this.signalColor,
    required this.signal,
  }) : super(key: key);

  final String name;
  final bool mute;
  final VoidCallback? onMute;
  final Color signalColor;
  final int signal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide()),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Flexible(
            child: Text(name),
          ),
          Flexible(
            child: MuteButton(
              mute: mute,
              onMute: onMute,
            ),
          ),
        ],
      ),
    );
  }
}

class MuteButton extends StatelessWidget {
  const MuteButton({
    Key? key,
    required this.mute,
    this.onMute,
  }) : super(key: key);

  final bool mute;
  final VoidCallback? onMute;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: mute ? Colors.green : Colors.red,
      ),
      onPressed: onMute,
      icon: Icon(
        mute ? Icons.mic : Icons.mic_off,
      ),
    );
  }
}

class SignalInfo extends StatelessWidget {
  const SignalInfo({
    Key? key,
    required this.signalColor,
    required this.signal,
  }) : super(key: key);

  final Color signalColor;
  final int signal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(signal.toString()),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: signalColor,
          ),
        )
      ],
    );
  }
}

class RadioButton extends StatefulWidget {
  const RadioButton({
    Key? key,
    this.beginBroadcast,
    this.endBroadcast,
    this.waveRadius = 0,
    this.waveGap = 30,
    this.soundData,
  }) : super(key: key);

  final VoidCallback? beginBroadcast;
  final VoidCallback? endBroadcast;
  final double waveRadius;
  final double waveGap;
  final Stream<List<int>>? soundData;

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween(begin: 0.0, end: widget.waveGap).animate(controller);

    return SizedBox(
      height: 300,
      child: WavesIndicator(
        color: Colors.black,
        listenable: animation,
        radiusStep: widget.waveGap,
        opacityStep: 0.2,
        child: RepaintBoundary(
          child: StreamBuilder(
            stream: widget.soundData,
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];
              final maxRadius = data.isEmpty ? 0 : data.reduce(min);
              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 100,
                ),
                padding: EdgeInsets.all(maxRadius.toDouble()),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      Colors.transparent
                    ],
                  ),
                ),
                child: GestureDetector(
                  onLongPress: widget.beginBroadcast,
                  onLongPressUp: widget.endBroadcast,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 0,
                      padding: const EdgeInsets.all(30),
                    ),
                    onPressed: () {},
                    child: const Icon(
                      Icons.mic,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
