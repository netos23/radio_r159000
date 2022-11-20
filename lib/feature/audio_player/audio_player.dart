import 'dart:async';
import 'dart:typed_data';

import 'package:radio_r159000/feature/common/audio_config.dart';
import 'package:raw_sound/raw_sound_player.dart';

class AudioPlayer {
  final Stream<Uint8List> audioStream;
  late final StreamSubscription<Uint8List> _subscription;
  final _player = RawSoundPlayer();
  final AudioConfig config;

  AudioPlayer({
    required this.audioStream,
    this.config = const AudioConfig(),
  }) {
    _initPlayer();
  }

  void dispose() {
    _subscription.cancel();

    _player.stop();
    _player.release();
  }

  Future<void> _initPlayer() async {
    assert(
      config.pcmType == PcmType.pcm16Bit || config.pcmType == PcmType.pcm32Bit,
      'Player support only 16 and 32 bits pcm stream',
    );

    await _player.initialize(
      bufferSize: config.bufferSize,
      nChannels: config.nChannels,
      sampleRate: config.sampleRate,
      pcmType: config.pcmType == PcmType.pcm16Bit
          ? RawSoundPCMType.PCMI16
          : RawSoundPCMType.PCMF32,
    );

    _subscription = audioStream.listen((event)async {
      await _player.feed(event);
    });
    await _player.play();
  }
}
