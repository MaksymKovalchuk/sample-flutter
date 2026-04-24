import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:sample/src/core/di/injection.dart';
import 'package:sample/src/core/network/api_model.dart';
import 'package:sample/src/core/network/constants/api_keys.dart';
import 'package:sample/src/core/network/constants/api_router.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/network_exceptions.dart';
import 'package:sample/src/core/network/response_parser.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/app_initializer.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/services/helpers/retry_helper.dart';
import 'package:sample/src/services/logging/logger.dart';

@lazySingleton
class RestClient {
  const RestClient();

  Future<T> request<T>({
    required ApiModel apiModel,
    bool isProto = false,
    int retryCount = 1,
    bool bypassInitializer = false,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!bypassInitializer) await getIt<AppInitializer>().ready;

    // Retrieve the base URL using the service type.
    final baseUrl = ApiRouter.getRestUrl(apiModel.serviceType);
    if (baseUrl.isEmpty) {
      logger.warning("Base URL is empty for service: ${apiModel.serviceType}");
      throw Exception("Invalid API URL");
    }

    final fullUrl = "$baseUrl${apiModel.pathUrl}";

    _logRequest(apiModel, apiModel.pathUrl);

    final attempts = retryCount < 1 ? 1 : retryCount;

    return RetryHelper.run(
      task: () async {
        final stopwatch = Stopwatch()..start();

        try {
          // Obtain a valid token either from the provided one or fetch it.
          final token = await _getToken(apiModel.token);
          // Build the appropriate headers for the request.
          final headers = await _buildHeaders(token, isProto);

          // Create the HTTP request with method, URL, and headers.
          final request = Request(apiModel.method, Uri.parse(fullUrl))
            ..headers.addAll(headers);
          if (apiModel.body != null) {
            if (isProto) {
              request.bodyBytes = apiModel.body as List<int>;
            } else {
              request.body = json.encode(apiModel.body);
            }
          }

          // Send the request and wait for a response with a timeout.
          final streamedResponse = await request.send().timeout(timeout);
          final response = await Response.fromStream(streamedResponse);
          final status = response.statusCode;

          // Parse the response data accordingly.
          final parsedResponse = ResponseParser.parseResponse(
            response,
            isProto: isProto,
          );

          stopwatch.stop();
          // logger.info("Request duration: ${stopwatch.elapsedMilliseconds}ms");

          if (_isSuccess(status)) {
            return parsedResponse as T;
          } else {
            if (status == 401) {
              logger.info("Unauthorized (401) for $fullUrl");

              if (getIt<LogoutManager>().isLoggingOut) {
                logger.info("Ignored 401 during logout");
                throw ApiException(
                  "Unauthorized during logout",
                  status: status,
                );
              }

              throw ApiException("Unauthorized access", status: status);
            }

            // Handle error responses and return an error future.
            return Future<T>.error(
              await NetworkExceptions.handleError(
                status: status,
                responseBody: parsedResponse,
                pathUrl: apiModel.pathUrl,
              ),
            );
          }
        } on TimeoutException {
          logger.warning("Timeout for $fullUrl after ${timeout.inSeconds}s");
          throw ApiException("Request timed out", status: 408);
        } on SessionExpiredException catch (e) {
          if (!getIt<LogoutManager>().isLoggingOut) {
            await getIt<LogoutManager>().logout(
              message: e.message,
              source: 'RestClient',
            );
          }
          throw ApiException(e.message);
        } on ClientException catch (e) {
          logger.error("HTTP client error: ${e.message}");
          throw ApiException("Unexpected connection issue. Please try again.");
        } on ApiException catch (e) {
          throw ApiException(e.message, status: e.status ?? 500);
        } on Exception catch (e) {
          logger.error("Unexpected error", error: e);
          throw ApiException("Something went wrong. Please try again.");
        }
      },
      maxAttempts: attempts,
    );
  }

  Future<String> _getToken(String token) async {
    if (token.isNotEmpty) return token;

    try {
      return await getIt<TokenProvider>().getValidAccessToken();
    } on SessionExpiredException catch (_) {
      rethrow;
    }
  }

  Future<Map<String, String>> _buildHeaders(String token, bool isProto) async =>
      {
        "Content-Type": isProto ? "application/protobuf" : "application/json",
        if (token.isNotEmpty) Keys.auth: token,
      };

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode <= 299;

  void _logRequest(ApiModel apiModel, String fullUrl) {
    logger.info("Request: ${apiModel.method} $fullUrl");
    if (apiModel.body != null) {
      logger.debug("Body: ${jsonEncode(apiModel.body)}");
    }
  }
}
