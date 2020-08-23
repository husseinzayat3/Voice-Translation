import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_translator/Pages/RecordingPage.dart';
import 'package:voice_translator/Phrase.dart';
import 'package:voice_translator/dbHelper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Phrase> list = [];

  @override
  Widget build(BuildContext context) {
//    readSharedPrefs();
//  readPhrasesDb();
    // List already translated texts
    // TODO: show the original and translated language
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () async {
                await PhraseDatabaseProvider.db.deleteAllPhrases();
                setState(() {
                });
              },
            )
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: FlatButton(
                child: Text("Record"),
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RecordingPage()));
                },
              ),
            ),
            (list != null)
                ? FutureBuilder<List<Phrase>>(
                    future: PhraseDatabaseProvider.db.getAllPhrases(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Phrase>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                  title: Text(
                                      "${snapshot.data[index].inputText}(${snapshot.data[index].inputLang})"),
                                  subtitle: Text(
                                      "${snapshot.data[index].outputText}(${snapshot.data[index].outputLang})"),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await PhraseDatabaseProvider.db
                                          .deletePhraseWithId(list[index].id);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            });
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
                : SizedBox()
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    // Read from shared prefs
    readPhrasesDb();
  }

  void readPhrasesDb() async {
    List<Phrase> phrases = await PhraseDatabaseProvider.db.getAllPhrases();
    setState(() {
      list = phrases;
    });
  }

  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'audio';
    List<String> audio = prefs.getStringList(key);

    setState(() {
//      list = audio;
    });
  }
}
