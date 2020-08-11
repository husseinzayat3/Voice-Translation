import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_translator/Pages/RecordingPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: FlatButton(
          child: Text("Record"),
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => RecordingPage()));
          },
        ),
      ),
    );
    // TODO: List view of the already translated texts
  }

  @override
  void initState() {
    super.initState();
    // TODO: Read from shared prefs
  }
}
