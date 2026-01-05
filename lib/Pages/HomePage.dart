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
                if (mounted) {
                  setState(() {
                  });
                }
              },
            )
          ],
        ),
        body: ListView(
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
            FutureBuilder<List<Phrase>>(
              future: PhraseDatabaseProvider.db.getAllPhrases(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Phrase>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Column(
                    children: snapshot.data.map((phrase) {
                      return ListTile(
                        title: Text("${phrase.inputText}(${phrase.inputLang})"),
                        subtitle: Text("${phrase.outputText}(${phrase.outputLang})"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await PhraseDatabaseProvider.db
                                .deletePhraseWithId(phrase.id);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Center(child: Text("No phrases available"));
                }
              },
            )
          ],
        )
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
    if (mounted) {
      setState(() {
        list = phrases;
      });
    }
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
