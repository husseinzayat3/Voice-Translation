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
                speech.listen(onResult: resultListener);
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
          recordingDone?FlatButton(
            child: Text("Translate"),
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => TranslationPage(text:text)));
            },
          ):SizedBox()
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
}
