final String tableTodo = 'Phrase';
final String columnId = '_id';
final String columnInputText = 'inputText';
final String columnInputLang = 'inputLang';
final String columnOutputText = 'outputText';
final String columnOutputLang = 'outputLang';
final String columnDate = 'date';


class Phrase{
  int id;
  String inputText;
  String inputLang;
  String outputText;
  String outputLang;
  String date;

  Phrase({int id = 0, String inputText = '', String inputLang = '', String outputText = '',
      String outputLang = '', String date = ''}) {
    this.id = id;
    this.inputText = _sanitizeInput(inputText);
    this.inputLang = _sanitizeInput(inputLang);
    this.outputText = outputText.trim();
    this.outputLang = outputLang.trim();
    this.date = date.trim();
  
  String _sanitizeInput(String input) {
    if (input == null || input.isEmpty) {
      throw ArgumentError('Input cannot be null or empty');
    }
    // Basic sanitization: remove any non-alphanumeric characters
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '').trim();
  }
}

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnInputText: inputText,
      columnInputLang: inputLang,
      columnOutputText: outputText,
      columnOutputLang: outputLang,
      columnDate: date
    };
//    if (id != null)  {
//      map[columnId] = id;
//    }
    return map;
  }


  Phrase.fromMap(Map<String, dynamic> map) {
    id = map[columnId] ?? 0;
    inputText = map[columnInputText] ?? '';
    inputLang = map[columnInputLang] ?? '';
    outputText = map[columnOutputText] ?? '';
    outputLang = map[columnOutputLang] ?? '';
    date = map[columnDate] ?? '';
  }

}