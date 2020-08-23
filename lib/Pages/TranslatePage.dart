import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_translator/Phrase.dart';
import 'package:voice_translator/dbHelper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class TranslationPage extends StatefulWidget {
  final String text;
  final String translateFrom;

  TranslationPage({Key key, this.text, this.translateFrom}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {

  // speech to text
  stt.SpeechToText speech = stt.SpeechToText();

  // text to speech
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;


  // text translator
  final translator = GoogleTranslator();

  String _targetLocaleId = "";

  String translatedText = "";

  String translateTo = "";
  List<stt.LocaleName> _localeNames = [];

  bool _hasSpeech = false;
  String lastError = "";
  String lastStatus = "";

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Show the recorded message and the option of choosing the translate language
    return Scaffold(
      appBar: AppBar(
        title: Text("Translation"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Container(
              alignment: Alignment.center,
              child: Text("Original Text(${widget.translateFrom})")),
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: Colors.blueAccent)),
              alignment: Alignment.center,
              child: Text(widget.text)),
          Divider(color: Colors.black),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Translate to:",
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton(
                onChanged: (selectedVal) {
                  _switchLang(selectedVal);
                  translateText(selectedVal.split("_")[0]);
                },
                value: _targetLocaleId,
                items: _localeNames
                    .map(
                      (localeName) => DropdownMenuItem(
                        value: localeName.localeId,
                        child: Text(localeName.name),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: Colors.blueAccent)),
              alignment: Alignment.center,
              child: ListTile(
                trailing: IconButton(icon: Icon(isPressed?Icons.stop:Icons.record_voice_over),
                onPressed: () async{

                 if(isPressed){
                    _speak();
                 }else{
                   _stop();
                 }

                 setState(() {
                   isPressed=!isPressed;
                 });
                },),
                  title: Text(translatedText.isNotEmpty
                      ? translatedText
                      : "Please choose transalte language"))),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initTts();
    initSpeechState();
  }

  Future<Null> translateText(targetId) async {
    var translate = await translator.translate(widget.text,
        from: widget.translateFrom, to: targetId);
//    final prefs = await SharedPreferences.getInstance();
//    final key = 'audio';
//    List<String> audio = prefs.getStringList(key);
//    if(audio!=null){
//      audio.add("${widget.text}_${translate.text}");
//    prefs.setStringList(key, audio);
//    }else{
//      List<String> list = [];
//      list.add("${widget.text}_${translate.text}");
//      prefs.setStringList(key, list);
//    }

    int id = await PhraseDatabaseProvider.db.getId();
    Phrase phrase = new Phrase(id, widget.text, widget.translateFrom,
        translate.text, targetId, DateTime.now().toString());
    PhraseDatabaseProvider.db.addPhraseToDatabase(phrase);
    setState(() {
      translatedText = translate.text;
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _targetLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _targetLocaleId = systemLocale.localeId;
    }
    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
//      lastStatus = "$status";
    });
  }


  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      }
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (kIsWeb || Platform.isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }


}
