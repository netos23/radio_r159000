import 'dart:async';
import 'dart:typed_data';

import 'package:radio_r159000/feature/common/audio_config.dart';
import 'package:mic_stream/mic_stream.dart';

typedef AudioSink = void Function(Uint8List);

class Recorder {
  Stream<Uint8List>? _stream;
  StreamSubscription<Uint8List>? _listener;
  final AudioConfig config;
  final AudioSink sink;

  Recorder({
    required this.sink,
    this.config = const AudioConfig(),
  }) : assert(
          config.pcmType == PcmType.pcm8Bit ||
              config.pcmType == PcmType.pcm16Bit,
          'Player support only 8 and 16 bits pcm stream',
        );

  Future<void> startRecord() async {
    _stream = await MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: config.sampleRate,
      channelConfig: config.nChannels == 1
          ? ChannelConfig.CHANNEL_IN_MONO
          : ChannelConfig.CHANNEL_IN_STEREO,
      audioFormat: config.pcmType == PcmType.pcm8Bit
          ? AudioFormat.ENCODING_PCM_8BIT
          : AudioFormat.ENCODING_PCM_16BIT,
    );

    _listener = _stream?.listen(sink);
  }

  void stopRecorder() {
    _listener?.cancel();
  }

  void dispose() {
    _listener?.cancel();
  }
}
