class RetryHelper {
  const RetryHelper._();

  static Future<T> run<T>({
    required Future<T> Function() task,
    int maxAttempts = 3,
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await task();
      } catch (_) {
        if (attempt == maxAttempts - 1) rethrow;
        await Future.delayed(delay);
      }
    }
    throw Exception('Unreachable retry logic');
  }
}
