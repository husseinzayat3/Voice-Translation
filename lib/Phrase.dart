final String tableTodo = 'Phrase';
final String columnId = '_id';
final String columnInputText = 'inputText';
final String columnInputLang = 'inputLang';
final String columnOutputText = 'outputText';
final String columnOutputLang = 'outputLang';
final String columnDate = 'date';


/// Represents a translation entry with input and output text and languages.
class TranslationEntry{
  int id;
  String inputText;
  String inputLang;
  String outputText;
  String outputLang;
  DateTime date;

  Phrase({int id = 0, String inputText = '', String inputLang = '', String outputText = '',
      String outputLang = '', DateTime? date  }

  String sanitize(String text) {
    return text.replaceAll("'", "\'").replaceAll('"', '\"').replaceAll('\\', '\\\\');
  }) {
    this.id = id;
    this.inputText = sanitize(inputText.trim());
    this.inputLang = inputLang.trim();
    this.outputText = sanitize(outputText.trim());
    this.outputLang = outputLang.trim();
    this.date = date ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnInputText: inputText,
      columnInputLang: inputLang,
      columnOutputText: outputText,
      columnOutputLang: outputLang,
      columnDate: date.toIso8601String()
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
    date = DateTime.parse(map[columnDate] ?? DateTime.now().toIso8601String());
  }

}