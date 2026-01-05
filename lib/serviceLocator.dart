import 'package:get_it/get_it.dart';
import 'dbHelper.dart';
import 'package:some_database_package/database.dart';
import 'package:some_logging_package/logger.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Database>(() => Database());
  getIt.registerLazySingleton<Logger>(() => Logger());
  getIt.registerFactory(() => DbHelper(database: getIt<Database>(), logger: getIt<Logger>()));
}