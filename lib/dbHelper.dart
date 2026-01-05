  final Database database;
  final Logger _logger;

  DbHelper(this.database, this._logger);

  Future<T?> _executeDbOperation<T>(Future<T> Function(Database db) operation, String errorMessage) async {
    final db = await database;
    try {
      return await operation(db);
    } catch (e) {
      _logger.e(errorMessage, e);
      return null;
    }
  }