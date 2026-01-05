void _setupServiceLocator() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<stt.SpeechToText>(() => stt.SpeechToText());
  getIt.registerLazySingleton<FlutterTts>(() => FlutterTts());
  getIt.registerLazySingleton<GoogleTranslator>(() => GoogleTranslator());
}