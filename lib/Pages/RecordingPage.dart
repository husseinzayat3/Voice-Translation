import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_translator/Pages/TranslatePage.dart';

class RecordingPage extends StatefulWidget {
  final FlutterSecureStorage secureStorage;
  final stt.SpeechToText speechToText;

  RecordingPage({Key? key, @required this.secureStorage, @required this.speechToText}) : assert(secureStorage != null, 'secureStorage must not be null'), assert(speechToText != null, 'speechToText must not be null'), super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}


class _RecordingPageState extends State<RecordingPage> {
  FlutterSecureStorage get _secureStorage => widget.secureStorage;

  Future<void> authenticate() async {
    final isAuthenticated = await LocalAuthentication().authenticate(
      localizedReason: 'Please authenticate to access secure storage',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (!isAuthenticated) {
      throw Exception('Authentication failed');
    }
  }


  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    if (!mounted) return;
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    if (!mounted) return;
    setState(() {
      lastStatus = "$status";
    });
  }

  bool available = true;
  stt.SpeechToText get speech => widget.speechToText;

  // text to be translated

  String text= "";
  bool recordingDone = false;

  bool _hasSpeech = false;
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

    return Scaffold(
      appBar: AppBar(title: Text("Record Page"),),
      body: ListView(
      shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          child:Text("Select your language",textAlign: TextAlign.center,),),
          // select the language to be translated
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton(
                onChanged: (selectedVal) => updateBaseLanguage(selectedVal),
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
          // Start recording message
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
              if (_hasSpeech) {
                await authenticate();
                speech.listen(onResult: resultListener, localeId: _baseLocaleId);
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
              if (mounted) {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => TranslationPage(text:text,translateFrom: _baseLocaleId.split("_")[0])));
              }
            },
          ))]):SizedBox()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  void resultListener(SpeechRecognitionResult result) {

    debugPrint(result.recognizedWords);
    if (!mounted) return;
    setState(() {
      recordingDone = true;
      text = result.recognizedWords;
    });
  }



  updateBaseLanguage(selectedVal) {
    if (selectedVal == null) return;
    setState(() {
      _baseLocaleId = selectedVal;
    });
  }
}
