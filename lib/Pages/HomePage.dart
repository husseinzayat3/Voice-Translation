import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_translator/Pages/RecordingPage.dart';
import 'package:voice_translator/Phrase.dart';
import 'package:voice_translator/dbHelper.dart';

class HomePage extends StatefulWidget {
  final PhraseDatabaseProvider dbProvider;
  final SharedPreferences sharedPreferences;

  HomePage({Key key, @required this.dbProvider, @required this.sharedPreferences}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Phrase> list = [];

  @override
  Widget build(BuildContext context) {

    // List already translated texts
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () async {
                if (mounted) {
                  await widget.dbProvider.deleteAllPhrases();
                  if (list.isNotEmpty) {
                    setState(() {
                      list.clear();
                    });
                  }
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
              future: widget.dbProvider.getAllPhrases(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Phrase>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data != null && snapshot.data.isNotEmpty) {
                  return Column(
                    children: snapshot.data.map((phrase) {
                      return ListTile(
                        title: Text(Uri.encodeComponent(phrase.inputText) + "(${phrase.inputLang})"),
                        subtitle: Text(Uri.encodeComponent(phrase.outputText) + "(${phrase.outputLang})"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              if (mounted) {
                                await widget.dbProvider
                                    .deletePhraseWithId(phrase.id);
                                if (list.isNotEmpty) {
                                  setState(() {
                                    list.removeWhere((item) => item.id == phrase.id);
                                  });
                                }
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to delete phrase: \\$e')),
                              );
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
    try {
      List<Phrase> phrases = await widget.dbProvider.getAllPhrases();
      if (mounted && phrases != null) {
        setState(() {
          list = phrases;
        });
      }
    } catch (e) {
      print('Error fetching phrases: $e');
    }
  }

  void readSharedPrefs() async {
    final key = 'audio';
    try {
      List<String> audio = widget.sharedPreferences.getStringList(key) ?? [];
      if (audio.isEmpty) {
        print('No audio data found in shared preferences.');
      }
    } catch (e) {
      print('Error reading shared preferences: $e');
    }

    
  }
}
