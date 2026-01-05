import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  getIt.registerLazySingleton<stt.SpeechToText>(() => stt.SpeechToText());
}