
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslationPage extends StatefulWidget {

  final String text;
  final String translateFrom;
  final String translateTo;
  TranslationPage({Key key, this.text,this.translateFrom,this.translateTo}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}


class _TranslationPageState extends State<TranslationPage> {

  final translator = GoogleTranslator();

  String translatedText = "";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Text("Translation"),
     ),
     body: Column(
       children: <Widget>[
         Container(
             alignment: Alignment.center,
             child:Text("Original Text(${widget.translateFrom}")),
         Container(
           alignment: Alignment.center,
         child:Text(widget.text)),
         Divider(
             color: Colors.black
         ),
         Container(
             alignment: Alignment.center,
             child:Text("Translated Text(${widget.translateTo})")),
         Container(
             alignment: Alignment.center,
             child:Text(translatedText)),
       ],
     ),
   );
    // TODO: Text of the text recorded
    // TODO: Text of the translation of text
  }

  @override
  void initState() {
    super.initState();
    translateText();
  }

  Future<Null> translateText() async{
    var translate = await translator.translate(widget.text, from: widget.translateFrom, to: widget.translateTo);
    setState(() {
      translatedText = translate.text;
    });

  }
}
