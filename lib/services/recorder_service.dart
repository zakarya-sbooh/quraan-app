import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  late FlutterSoundRecorder _recorder;
  bool isRecorderReady = false;
  final String apiKey =
      "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";

  String? recordedFilePath;

  // تنظيف النصوص القرآنية
  String cleanQuranicText(String text) {
    return text
        .replaceAll(RegExp(r'[\u0670\u0671]'), 'ا') // الألف الخنجرية والمقصورة
        .replaceAll(RegExp(r'[\u064B-\u0652]'), '') // الحركات والتشكيل
        .replaceAll(
            RegExp(r'[\u06D6-\u06DC\u06DF-\u06E4\u06E7-\u06E8\u06EA-\u06ED]'),
            '') // الرموز العثمانية
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('ء', '')
        .replaceAll('ٓ', '')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ٰ', 'ا');
  }

  Future<void> initializeRecorder() async {
    try {
      _recorder = FlutterSoundRecorder();
      final status = await Permission.microphone.request();

      if (!status.isGranted) {
        print(' يجب منح إذن الميكروفون');
        return;
      }

      await _recorder.openRecorder();
      isRecorderReady = true;
      print(" مسجل الصوت جاهز للعمل");
    } catch (e) {
      print(' خطأ في إعداد مسجل الصوت: $e');
    }
  }

  Future<String?> startRecording() async {
    if (!isRecorderReady) {
      print(" المسجل غير جاهز");
      return null;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      recordedFilePath = '${directory.path}/recording.wav';

      await _recorder.startRecorder(
        toFile: recordedFilePath,
        codec: Codec.pcm16WAV,
      );
      print(" بدأ التسجيل في: $recordedFilePath");

      return recordedFilePath;
    } catch (e) {
      print(' خطأ أثناء التسجيل: $e');
      return null;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecorderReady) return;

    try {
      await Future.delayed(Duration(seconds: 2));
      await _recorder.stopRecorder();
      print(" تم إيقاف التسجيل");
    } catch (e) {
      print(' خطأ أثناء إيقاف التسجيل: $e');
    }
  }

  Future<String?> analyzeWithWhisper() async {
    if (recordedFilePath == null || !File(recordedFilePath!).existsSync()) {
      print(" الملف غير موجود: $recordedFilePath");
      return null;
    }

    final url = Uri.parse("https://api.openai.com/v1/audio/transcriptions");

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['model'] = 'whisper-1'
      ..fields['language'] = 'ar'
      ..files.add(await http.MultipartFile.fromPath('file', recordedFilePath!));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        String recognizedText = jsonResponse["text"];
        recognizedText = cleanQuranicText(recognizedText);
        print(" تحليل Whisper: $recognizedText");
        return recognizedText;
      } else {
        print(" خطأ في Whisper API: ${jsonResponse}");
        return null;
      }
    } catch (e) {
      print(" خطأ أثناء تحليل الصوت بواسطة Whisper: $e");
      return null;
    }
  }

  void compareRecitation(String recognizedText, String correctText) {
    String cleanedRecognized = cleanQuranicText(recognizedText);
    String cleanedCorrect = cleanQuranicText(correctText);

    if (cleanedRecognized == cleanedCorrect) {
      print(" تلاوة صحيحة!");
    } else {
      print(" خطأ في التلاوة! النص المتوقع: $cleanedCorrect");
    }
  }
}
