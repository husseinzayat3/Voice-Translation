//You can reference this document https://medium.com/flutterdevs/data-persistence-with-sqlite-flutter-47a6f67b973f
//
//Github code https://github.com/ashishrawat2911/flutter_sqlite
//
//database helper for CRUD, you can change model per your request

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voice_translator/Phrase.dart';

class PhraseDatabaseProvider {
  PhraseDatabaseProvider._();

  static final PhraseDatabaseProvider db = PhraseDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "phrase.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Phrase ("
              "_id integer primary key AUTOINCREMENT,"
              "inputText TEXT,"
              "inputLang TEXT,"
              "outputText TEXT,"
              "outputLang TEXT,"
              "date TEXT"
              ")");
        });
  }

  addPhraseToDatabase(Phrase phrase) async {
    final db = await database;
    var raw = await db.insert(
      "Phrase",
      phrase.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updatePhrase(Phrase phrase) async {
    final db = await database;
    var response = await db.update("Phrase", phrase.toMap(),
        where: "_id = ?", whereArgs: [phrase.id]);
    return response;
  }

  Future<Phrase> getPhraseWithId(int id) async {
    final db = await database;
    var response = await db.query("Phrase", where: "_id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Phrase.fromMap(response.first) : null;
  }

  Future<List<Phrase>> getAllPhrases() async {
    final db = await database;
    var response = await db.query("Phrase");
    print(response.toString());
    List<Phrase> list = response.map((c) => Phrase.fromMap(c)).toList();
    return list;
  }
  Future<int> getId() async {
    final db = await database;
    var response = await db.query("Phrase");
    List<Phrase> list = response.map((c) => Phrase.fromMap(c)).toList();
   int count = 0;
    if(list.isNotEmpty){
      count = list.last.id;
    }


//    int count = response.map((c) => Phrase.fromMap(c)).length;

    return count +1;
  }


  deletePhraseWithId(int id) async {
    final db = await database;
    return db.delete("Phrase", where: "_id = ?", whereArgs: [id]);
  }

  deleteAllPhrases() async {
    final db = await database;
    db.delete("Phrase");
  }
}
