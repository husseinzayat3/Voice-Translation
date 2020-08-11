import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_translator/Pages/TranslatePage.dart';

class RecordingPage extends StatefulWidget {
  RecordingPage({Key key}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

String text= "";
class _RecordingPageState extends State<RecordingPage> {
  get errorListener => null;

  get statusListener => null;

  bool available = true;
  stt.SpeechToText speech = stt.SpeechToText();

  // text to be translated


  bool recordingDone = false;

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  String _baseLocaleId = "";
  List<stt.LocaleName> _localeNames = [];

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Record Page"),),
      body: ListView(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.center,
      shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
          child:Text("Select your language",textAlign: TextAlign.center,),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton(
                onChanged: (selectedVal) => _baseLang(selectedVal),
                value: _baseLocaleId,
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
          alignment: Alignment.topCenter,
          width: 50,
          height: 50,
          margin: EdgeInsets.only(top: 50),
          child:FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
            ),
           child: Image.asset("assets/recording.png"),
            onPressed: () async {
              available = await speech.initialize(
                  onStatus: statusListener, onError: errorListener,debugLogging: true);
              if (available) {
                speech.listen(onResult: resultListener,localeId: _baseLocaleId);
              } else {
                print("The user has denied the use of speech recognition.");
              }
            },
          )),
      Container(
        alignment: Alignment.topCenter,
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 50),
        child:FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
          ),
          child: Image.asset("assets/stop-recording.png"),
          onPressed: () async {
              speech.stop();
            },
          )),
          recordingDone?
          Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
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
          FlatButton(
            child: Text("Translate"),
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => TranslationPage(text:text)));
            },
          )]):SizedBox()
        ],
      ),
    );
    // TODO: Recording icon button to start voice recording
    // TODO: On recording finish show translate button
    // TODO: select languages
    // TODO: translate button navigates to translation page
  }

  @override
  void initState() {
    super.initState();
//    setupRecording();
    if(!_hasSpeech){
    initSpeechState();
    }

  }

  void setupRecording() async{


  }
  void resultListener(SpeechRecognitionResult result) {

    debugPrint(result.recognizedWords);
    setState(() {
      recordingDone = true;
      text = result.recognizedWords;
    });


  }
  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
  _baseLang(selectedVal) {
    setState(() {
      _baseLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
