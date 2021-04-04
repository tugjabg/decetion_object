import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech{
  static FlutterTts flutterTts;
  static initTts() {
    flutterTts = FlutterTts();
    setLanguage();
    speechSetting();
  }

  static setLanguage() async {
    await flutterTts.setLanguage("en-US");

  }

  static speechSetting() {
    //flutterTts.setVoice('');
    flutterTts.setPitch(0.1);
    flutterTts.setSpeechRate(0.5);
  }

  static Future speak(String text) async{
    print(text);
    if(text.isNotEmpty){
      var result = await flutterTts.speak(text);
      print(result);
      // ignore: unrelated_type_equality_checks
      if(result == 1){
      }
    }
  }
}