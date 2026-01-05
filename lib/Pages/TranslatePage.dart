String _newVoiceText = '';
String language = 'en';
String _targetLocaleId = 'en';
String translateTo = 'en';

void _setupServiceLocator({
  required stt.SpeechToText Function() speechToTextFactory,
  required FlutterTts Function() flutterTtsFactory,
  required GoogleTranslator Function() googleTranslatorFactory,
}) {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<stt.SpeechToText>(() => speechToTextFactory != null ? speechToTextFactory() : stt.SpeechToText());
  getIt.registerLazySingleton<FlutterTts>(() => flutterTtsFactory != null ? flutterTtsFactory() : FlutterTts());
  getIt.registerLazySingleton<GoogleTranslator>(() => googleTranslatorFactory != null ? googleTranslatorFactory() : GoogleTranslator(baseUrl: sanitizeUrl('https://translate.googleapis.com')));
}

String sanitizeInput(String input) {
  return input.replaceAll(RegExp(r'[<>\
  // Basic sanitization logic
  return input.replaceAll(RegExp(r'[<>"\
]'), '');
}

void processSelectedVal(String? selectedVal) {
  try {
    if (selectedVal == null) {
      selectedVal = 'default_value'; // Provide a default value
    }
    var parts = selectedVal.split(',');
    var cachedSplit = selectedVal.split('_')[0];
    // Further processing of parts
    if (mounted) {
      setState(() {
        // Update UI state here
        _localeNames = ...; // Assign appropriate value
        _targetLocaleId = ...; // Assign appropriate value
      });
    } else {
      // Handle the case where the widget is not mounted
    }
  } catch (e) {
    // Log the error
    print('Error processing selected value: $e');
    if (mounted) {
      setState(() {
        // Update UI to inform the user of the error
        _errorMessage = 'An error occurred while processing your request.';
      });
    }
  }
}

bool validateInput(String input) {
  // Basic validation logic
  return input.isNotEmpty && input.length < 1000;
}
