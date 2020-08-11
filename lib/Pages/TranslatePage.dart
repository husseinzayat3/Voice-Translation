
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TranslationPage extends StatefulWidget {

  final String text;
  TranslationPage({Key key, this.text}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}


class _TranslationPageState extends State<TranslationPage> {

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
         child:Text(widget.text))
       ],
     ),
   );
    // TODO: Text of the text recorded
    // TODO: Text of the translation of text
  }

  @override
  void initState() {
    super.initState();
  }
}
