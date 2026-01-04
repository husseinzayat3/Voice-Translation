//You can reference this document https://medium.com/flutterdevs/data-persistence-with-sqlite-flutter-47a6f67b973f
//
//Github code https://github.com/ashishrawat2911/flutter_sqlite
//
//database helper for CRUD, you can change model per your request

import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voice_translator/Phrase.dart';

class PhraseDatabaseProvider {
  final Logger _logger = Logger('PhraseDatabaseProvider');
  PhraseDatabaseProvider._();

  static final PhraseDatabaseProvider db = PhraseDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    try {
      _database = await getDatabaseInstance();
    } catch (e) {
      _logger.severe('Error opening database', e);
      return null;
    }
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
    try {
      var raw = await db.insert(
        "Phrase",
        phrase.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return raw;
    } catch (e) {
      _logger.severe('Error adding phrase', e);
      return null;
    }
    return raw;
  }

  updatePhrase(Phrase phrase) async {
    final db = await database;
    try {
      var response = await db.update("Phrase", phrase.toMap(),
          where: "_id = ?", whereArgs: [phrase.id]);
      return response;
    } catch (e) {
      _logger.severe('Error updating phrase', e);
      return null;
    }
    return response;
  }

  Future<Phrase> getPhraseWithId(int id) async {
    final db = await database;
    try {
      var response = await db.query("Phrase", where: "_id = ?", whereArgs: [id]);
      return response.isNotEmpty ? Phrase.fromMap(response.first) : null;
    } catch (e) {
      _logger.severe('Error fetching phrase with id $id', e);
      return null;
    }
  }

  Future<List<Phrase>> getAllPhrases() async {
    final db = await database;
    try {
      var response = await db.query("Phrase");
      _logger.info('Fetched all phrases: ${response.toString()}');
      List<Phrase> list = response.map((c) => Phrase.fromMap(c)).toList();
      return list;
    } catch (e) {
      _logger.severe('Error fetching all phrases', e);
      return [];
    }
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
    try {
      return db.delete("Phrase", where: "_id = ?", whereArgs: [id]);
    } catch (e) {
      _logger.severe('Error deleting phrase with id $id', e);
      return null;
    }
  }

  deleteAllPhrases() async {
    final db = await database;
    try {
      db.delete("Phrase");
    } catch (e) {
      _logger.severe('Error deleting all phrases', e);
    }
  }
}
