  final Database database;
  final Logger _logger;

  DbHelper({required this.database, required Logger logger}) : _logger = logger;

  Future<T?> _executeDbOperation<T>(Future<T> Function(Database db) operation, String errorMessage) async {
    try {
      final db = await database;
      if (db == null) {
        _logger.e(errorMessage, 'Database is null');
        return null;
      }
      return await operation(db);
    } catch (e) {
      _logger.e(errorMessage, e);
      return null;
    }
  }