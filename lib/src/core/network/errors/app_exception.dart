class AppException implements Exception {
  AppException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  final int? status;
  ApiException(this.message, {this.status});
  @override
  String toString() => message;
}

class RestFailure extends AppException {
  RestFailure(super.message);
}

class SessionExpiredException implements Exception {
  SessionExpiredException([
    this.message = "Session expired. Please log in again.",
  ]);
  final String message;
  @override
  String toString() => message;
}
