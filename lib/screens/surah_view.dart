// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quraanapp/components/side_menu.dart';
import 'package:quraanapp/constants/color.dart';
import '../services/audio_service.dart';
import '../services/recorder_service.dart';

class SurahView extends StatefulWidget {
  final int surahNumber;

  const SurahView({super.key, required this.surahNumber});

  @override
  _SurahViewState createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  bool isDarkMode = false;
  double fontSize = 24.0;
  List<dynamic> ayahs = [];
  bool isLoading = true;
  String surahName = "تحميل...";
  AudioService audioService = AudioService();
  RecorderService recorderService = RecorderService();
  bool isRecording = false;
  int recordingVerse = -1;

  @override
  void initState() {
    super.initState();
    _fetchSurah();
    recorderService.initializeRecorder();

    audioService.onStateChanged = () {
      setState(() {});
    };
  }

  Future<void> _fetchSurah() async {
    final response = await http.get(Uri.parse(
        'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/editions/quran-uthmani'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ayahs = data['data'][0]['ayahs'];
        surahName = data['data'][0]['name'];
        isLoading = false;
      });
    }
  }

  Future<void> _toggleRecording(int verse) async {
    if (isRecording) {
      await recorderService.stopRecording();
      setState(() {
        isRecording = false;
        recordingVerse = -1;
      });

      final recognizedText = await recorderService.analyzeWithWhisper();
      if (recognizedText != null) {
        final correctText =
            ayahs.firstWhere((ayah) => ayah['number'] == verse)['text'].trim();

        print(
            " النص الصحيح بعد المعالجة: ${recorderService.cleanQuranicText(correctText)}");
        print(
            " النص المنطوق بعد المعالجة: ${recorderService.cleanQuranicText(recognizedText)}");

        if (recorderService.cleanQuranicText(recognizedText) !=
            recorderService.cleanQuranicText(correctText)) {
          _showMessage(" خطأ في التلاوة! سيتم تشغيل التلاوة الصحيحة.");
          await audioService.playVerse(verse);
        } else {
          _showMessage(" تلاوة صحيحة! استمر في القراءة.");
        }
      }
    } else {
      setState(() {
        isRecording = true;
        recordingVerse = verse;
      });

      await recorderService.startRecording();
    }
  }

  void _showMessage(String message) {
    Future.delayed(Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : offWhite,
      appBar: AppBar(
        title: Text(surahName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: lightGreen,
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        ayahs[index]['text'],
                        style: TextStyle(
                          fontSize: fontSize,
                          fontFamily: 'AmiriQuran',
                          color: isDarkMode ? Colors.white : black,
                          height: 2.0,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              isRecording &&
                                      recordingVerse == ayahs[index]['number']
                                  ? Icons.mic_off
                                  : Icons.mic,
                              color: recordingVerse == ayahs[index]['number']
                                  ? isDarkMode
                                      ? Colors.white
                                      : Colors.black
                                  : isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () =>
                                _toggleRecording(ayahs[index]['number']),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              audioService.isPlaying &&
                                      audioService.playingVerse ==
                                          ayahs[index]['number']
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color: audioService.isPlaying &&
                                      audioService.playingVerse ==
                                          ayahs[index]['number']
                                  ? isDarkMode
                                      ? Colors.white
                                      : Colors.black
                                  : isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () =>
                                audioService.playVerse(ayahs[index]['number']),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
