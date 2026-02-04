import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/network/core/response_parser.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:sample/src/core/session/logout_manager.dart';

class NetworkExceptions {
  const NetworkExceptions._();

  static Future<String> handleError({
    required int status,
    required dynamic responseBody,
    required String pathUrl,
  }) async {
    logger.warning("HTTP $status → $pathUrl");

    if (status == 401) {
      await locator<LogoutManager>().logout(
        message: "Session expired. Please log in again.",
        source: 'NetworkExceptions',
      );
      return Future.error(ApiException(
          "Your session has expired. Please log in again.",
          status: status));
    }

    if (status == 502 || status == 503) {
      final message = "Service temporarily unavailable (HTTP $status)";
      logger.error(message);
      return Future.error(ApiException(message, status: status));
    }

    final parsedError = await ResponseParser.parseErrorBody(responseBody);
    logger.error("Parsed error → ${parsedError ?? 'null'}");

    if (parsedError != null && parsedError.isNotEmpty) {
      return Future.error(ApiException(parsedError, status: status));
    }

    final String codeError = parseError(status);
    return Future.error(ApiException(
        codeError.isNotEmpty ? codeError : "Unexpected error",
        status: status));
  }

  static String parseError(int? status) {
    switch (status) {
      case 404:
        return "Something went wrong";
      case 500:
        return "Internal Server Error";
      case 501:
        return "Not Implemented";
      case 504:
        return "Gateway Timeout";
      case 408:
        return "Request Timeout";
      case 405:
        return "Method Not Allowed";
      default:
        return status != null
            ? "HTTP $status: Unexpected error"
            : "Unknown Error";
    }
  }
}
