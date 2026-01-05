import 'package:flutter/material.dart';
import 'package:voice_translator/Phrase.dart';
import 'package:voice_translator/dbHelper.dart';

class PhraseProvider with ChangeNotifier {
  List<Phrase> _phrases = [];
  bool _isLoading = false;

  List<Phrase> get phrases => _phrases;
  bool get isLoading => _isLoading;

  void loadPhrases(PhraseDatabaseProvider dbProvider) async {
    _isLoading = true;
    notifyListeners();
    _phrases = await dbProvider.getAllPhrases();
    _isLoading = false;
    notifyListeners();
  }

  void clearPhrases() {
    _phrases.clear();
    notifyListeners();
  }

  void removePhrase(int id) {
    _phrases.removeWhere((phrase) => phrase.id == id);
    notifyListeners();
  }
}