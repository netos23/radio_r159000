import 'package:raw_sound/raw_sound_player.dart';

enum PcmType { pcm8Bit, pcm16Bit, pcm32Bit }

class AudioConfig {
  final int bufferSize;

  final int nChannels;
  final int sampleRate;
  final PcmType pcmType;

  const AudioConfig({
    this.bufferSize = 4096 << 3,
    this.nChannels = 1,
    this.sampleRate = 16000,
    this.pcmType = PcmType.pcm16Bit,
  });
}
