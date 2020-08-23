
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_translator/Phrase.dart';
import 'package:voice_translator/dbHelper.dart';


class TranslationPage extends StatefulWidget {

  final String text;
  final String translateFrom;
  TranslationPage({Key key, this.text,this.translateFrom}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}


class _TranslationPageState extends State<TranslationPage> {


  stt.SpeechToText speech = stt.SpeechToText();

  final translator = GoogleTranslator();

  String _targetLocaleId = "";

  String translatedText = "";

  String translateTo="";
  List<stt.LocaleName> _localeNames = [];


  bool _hasSpeech = false;
  String lastError = "";
  String lastStatus = "";

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
         SizedBox(height: 40,),
         Container(
             alignment: Alignment.center,
             child:Text("Original Text(${widget.translateFrom})")),
         Container(
           margin: EdgeInsets.all(20),
           padding: EdgeInsets.all(20),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(50)),
             border: Border.all(color: Colors.blueAccent)
           ),
           alignment: Alignment.center,
         child:Text(widget.text)),
         Divider(
             color: Colors.black
         ),
         Padding(
           padding: EdgeInsets.only(top: 20),
           child:Text("Translate to:",textAlign: TextAlign.center,),),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
             DropdownButton(
               onChanged: (selectedVal){
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
                 border: Border.all(color: Colors.blueAccent)
             ),
             alignment: Alignment.center,
             child:Text(translatedText.isNotEmpty?translatedText:"Please choose transalte language")),
       ],
     ),
   );
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<Null> translateText(targetId) async{
    var translate = await translator.translate(widget.text, from: widget.translateFrom, to: targetId);
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
    Phrase phrase = new Phrase(id,widget.text, widget.translateFrom, translate.text, targetId, DateTime.now().toString());
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

}
