void _setupServiceLocator({
  stt.SpeechToText Function()? speechToTextFactory,
  FlutterTts Function()? flutterTtsFactory,
  GoogleTranslator Function()? googleTranslatorFactory,
}) {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<stt.SpeechToText>(() => speechToTextFactory != null ? speechToTextFactory() : stt.SpeechToText());
  getIt.registerLazySingleton<FlutterTts>(() => flutterTtsFactory != null ? flutterTtsFactory() : FlutterTts());
  getIt.registerLazySingleton<GoogleTranslator>(() => googleTranslatorFactory != null ? googleTranslatorFactory() : GoogleTranslator(baseUrl: 'https://translate.googleapis.com'));
}