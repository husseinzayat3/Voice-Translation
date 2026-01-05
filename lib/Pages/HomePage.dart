import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:voice_translator/Pages/RecordingPage.dart';
import 'package:voice_translator/Phrase.dart';
import 'package:voice_translator/dbHelper.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  final PhraseDatabaseProvider dbProvider;
  final SharedPreferences sharedPreferences;

  HomePage({Key? key, @required this.dbProvider, @required this.sharedPreferences}) : assert(dbProvider != null), assert(sharedPreferences != null), super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Phrase> phrasesList = [];

  @override
  Widget build(BuildContext context) {

    // List already translated texts
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: phrasesList.isNotEmpty ? () async {
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete all phrases?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (confirmDelete) {
                  try {
                    await widget.dbProvider.deleteAllPhrases();
                    if (mounted) {
                      setState(() {
                        phrasesList.clear();
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete phrases: \\$e')),
                    );
                  }
                  }
                }
              } : null,
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: TextButton(
                child: Text("Record"),
                onPressed: () {
                  if (mounted) {
                  Navigator.push(
                      context,
                      const MaterialPageRoute(
                          builder: (context) => RecordingPage()));
                }
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
                        title: Text("${phrase.inputText}(${phrase.inputLang})"),
                        subtitle: Text("${phrase.outputText}(${phrase.outputLang})"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await widget.dbProvider
                                .deletePhraseWithId(phrase.id);
                            if (mounted) {
                              setState(() {
                                phrasesList.removeWhere((item) => item.id == phrase.id);
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else if (snapshot.data == null || snapshot.data.isEmpty) {
                  return Center(child: Text("No phrases available"));
                }
              },
            )
          ],
        )
          ],
        ));
  }

  final _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Read from shared prefs
    readPhrasesDb();
  }

  void readPhrasesDb() async {
    List<Phrase> phrases = await widget.dbProvider.getAllPhrases();
    if (mounted) {
      setState(() {
        phrasesList = phrases;
      });
    }
  }

  void readSharedPrefs() async {
    final key = 'audio';
    String encryptedAudio = await _secureStorage.read(key: key);
    if (encryptedAudio != null) {
      List<String> audio = encryptedAudio.split(',');
      // Process the decrypted audio list
    }
  }

  void saveToSharedPrefs(List<String> audio) async {
    final key = 'audio';
    String encryptedAudio = audio.join(',');
    await _secureStorage.write(key: key, value: encryptedAudio);
  }
}
