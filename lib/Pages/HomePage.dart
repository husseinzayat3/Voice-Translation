import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_translator/Pages/RecordingPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    readSharedPrefs();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: FlatButton(
              child: Text("Record"),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => RecordingPage()));
              },
            ),
          ),
          (list!=null)?ListView.builder(
            shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context,index){
            return GestureDetector(
              child: ListTile(
                title: Text(list[index].split("_")[0]!=null?list[index].split("_")[0]:" "),
                subtitle: Text(list[index].split("_")[1]!=null?list[index].split("_")[1]:" "),
              ),
            );

              }):SizedBox()
        ],
      )
    );
    // TODO: List view of the already translated texts
  }

  @override
  void initState() {
    super.initState();
    readSharedPrefs();
    // TODO: Read from shared prefs
  }

  void readSharedPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'audio';
    List<String> audio = prefs.getStringList(key);

    setState(() {
      list = audio;
    });

  }
}
