  final Database database;
  final Logger _logger;
  final List<Completer> _operationQueue = [];

  DbHelper(ServiceLocator locator)
      : database = locator.get<Database>(),
        _logger = locator.get<Logger>();

  Future<T> _executeDbOperation<T>(Future<T> Function(Database db) operation, String errorMessage) async {
    if (database == null || !database.isOpen) {
      _logger.e(errorMessage, Exception('Database is null or closed'));
      return null;
    }

    final completer = Completer<T>();
    _operationQueue.add(completer);

    if (_operationQueue.length == 1) {
      _processQueue();
    }

    return completer.future;
  }

  void _processQueue() async {
    while (_operationQueue.isNotEmpty) {
      final completer = _operationQueue.first;
      final db = await database;
      try {
        final result = await operation(db);
        completer.complete(result);
      } catch (e) {
        _logger.e('Error executing DB operation', e);
        completer.completeError(e);
      } finally {
        _operationQueue.removeAt(0);
      }
    }
  }