String _newVoiceText = '';

void _setupServiceLocator({
  required stt.SpeechToText Function() speechToTextFactory,
  required FlutterTts Function() flutterTtsFactory,
  required GoogleTranslator Function() googleTranslatorFactory,
}) {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<stt.SpeechToText>(() => speechToTextFactory != null ? speechToTextFactory() : stt.SpeechToText());
  getIt.registerLazySingleton<FlutterTts>(() => flutterTtsFactory != null ? flutterTtsFactory() : FlutterTts());
  getIt.registerLazySingleton<GoogleTranslator>(() => googleTranslatorFactory != null ? googleTranslatorFactory() : GoogleTranslator(baseUrl: 'https://translate.googleapis.com'));
}

String sanitizeInput(String input) {
  // Basic sanitization logic
  return input.replaceAll(RegExp(r'[<>"\
]'), '');
}

bool validateInput(String input) {
  // Basic validation logic
  return input.isNotEmpty && input.length < 1000;
}
