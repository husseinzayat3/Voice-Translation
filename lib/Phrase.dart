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

  Phrase(this.id,this.inputText, this.inputLang, this.outputText,
      this.outputLang, this.date);

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
    id = map[columnId];
    inputText = map[columnInputText];
    inputLang = map[columnInputLang];
    outputText = map[columnOutputText];
    outputLang = map[columnOutputLang];
    date = map[columnDate];
  }

}