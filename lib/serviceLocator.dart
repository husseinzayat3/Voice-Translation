import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Database>(() => Database());
  locator.registerLazySingleton<Logger>(() => Logger());
}