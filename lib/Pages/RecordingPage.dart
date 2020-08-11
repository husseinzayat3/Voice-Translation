import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_translator/Pages/TranslatePage.dart';

class RecordingPage extends StatefulWidget {
  RecordingPage({Key key}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}


class _RecordingPageState extends State<RecordingPage> {


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
      lastStatus = "$status";
    });
  }

  bool available = true;
  stt.SpeechToText speech = stt.SpeechToText();

  // text to be translated

  String text= "";
  bool recordingDone = false;

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  String _baseLocaleId = "";
  List<stt.LocaleName> _localeNames = [];

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _baseLocaleId = systemLocale.localeId;
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
            padding: EdgeInsets.only(top: 50),
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
          width: 80,
          height: 80,
          margin: EdgeInsets.only(top: 50),
          child:FlatButton(
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.blueAccent)
            ),
           child: Image.asset("assets/recording.png",color: Colors.blueAccent),
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
              width: 80,
              height: 80,
              margin: EdgeInsets.only(top: 50),
              child:FlatButton(
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)
                ),
              child:  Image.asset("assets/stop-recording.png",color: Colors.blueAccent,),
          onPressed: () async {
              speech.stop();
            },
          )),
          recordingDone?
          Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top:40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: Colors.blueAccent)
                    ),
            child:  FlatButton(
            child: Text("Translate",style: TextStyle(fontSize: 20),),
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => TranslationPage(text:text,translateFrom: _baseLocaleId.split("_")[0])));
            },
          ))]):SizedBox()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    if(!_hasSpeech){
      initSpeechState();
//    }

  }

  void resultListener(SpeechRecognitionResult result) {

    debugPrint(result.recognizedWords);
    setState(() {
      recordingDone = true;
      text = result.recognizedWords;
    });
  }



  _baseLang(selectedVal) {
    setState(() {
      _baseLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
