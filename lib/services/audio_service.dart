import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int playingVerse = -1;
  Function()? onStateChanged;

  Future<void> playVerse(int verse) async {
    try {
      if (isPlaying) {
        await _audioPlayer.stop();
        isPlaying = false;
        playingVerse = -1;
        onStateChanged?.call();
        return;
      }

      await _audioPlayer.play(UrlSource(
          "https://cdn.islamic.network/quran/audio/128/ar.alafasy/$verse.mp3"));

      isPlaying = true;
      playingVerse = verse;
      onStateChanged?.call();

      _audioPlayer.onPlayerComplete.listen((event) {
        isPlaying = false;
        playingVerse = -1;
        onStateChanged?.call();
      });
    } catch (e) {
      print(" خطأ أثناء تشغيل الصوت: $e");
    }
  }

  Future<void> stopAudio() async {
    if (isPlaying) {
      await _audioPlayer.stop();
      isPlaying = false;
      playingVerse = -1;
      onStateChanged?.call();
    }
  }
}
