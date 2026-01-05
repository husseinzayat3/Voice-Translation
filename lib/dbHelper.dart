  final Database database;
  final Logger _logger;

  DbHelper(ServiceLocator locator)
      : database = locator.get<Database>(),
        _logger = locator.get<Logger>();

  Future<T> _executeDbOperation<T>(Future<T> Function(Database db) operation, String errorMessage) async {
    if (database == null) {
      _logger.e(errorMessage, Exception('Database is null'));
      return null;
    }
    final db = await database;
    try {
      return await operation(db);
    } catch (e) {
      _logger.e(errorMessage, e);
      return null;
    }
  }