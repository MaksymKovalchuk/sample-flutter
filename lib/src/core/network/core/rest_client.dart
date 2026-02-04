import 'dart:async';
import 'dart:convert';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/network/constants/api_keys.dart';
import 'package:sample/src/core/network/constants/api_router.dart';
import 'package:sample/src/core/network/core/network_exceptions.dart';
import 'package:sample/src/core/network/core/response_parser.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/app_initializer/app_initializer.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/services/helpers/retry_helper.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:http/http.dart';
import 'api_model.dart';

class RestClient {
  const RestClient();

  Future<T> request<T>({
    required ApiModel apiModel,
    bool isProto = false,
    int retryCount = 1,
    bool bypassInitializer = false,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!bypassInitializer) await locator<AppInitializer>().ready;

    // Retrieve the base URL using the service type and environment type.
    final String baseUrl = ApiRouter.getRestUrl(apiModel.serviceType, envType);
    if (baseUrl.isEmpty) {
      logger.warning("Base URL is empty for service: ${apiModel.serviceType}");
      throw Exception("Invalid API URL");
    }

    final String fullUrl = "$baseUrl${apiModel.pathUrl}";

    _logRequest(apiModel, apiModel.pathUrl);

    if (retryCount < 1) retryCount = 1;

    return await RetryHelper.run(
      task: () async {
        final stopwatch = Stopwatch()..start();

        try {
          // Obtain a valid token either from the provided one or fetch it.
          final token = await _getToken(apiModel.token);
          // Build the appropriate headers for the request.
          final Map<String, String> headers =
              await _buildHeaders(token, isProto);

          // Create the HTTP request with method, URL, and headers.
          final request = Request(apiModel.method, Uri.parse(fullUrl))
            ..headers.addAll(headers);
          if (apiModel.body != null) {
            isProto
                ? request.bodyBytes = apiModel.body
                : request.body = json.encode(apiModel.body);
          }

          // Send the request and wait for a response with a timeout.
          final streamedResponse = await request.send().timeout(timeout);
          final response = await Response.fromStream(streamedResponse);
          final status = response.statusCode;

          // Parse the response data accordingly.
          final parsedResponse =
              ResponseParser.parseResponse(response, isProto);

          stopwatch.stop();
          // logger.info("Request duration: ${stopwatch.elapsedMilliseconds}ms");

          if (_isSuccess(status)) {
            // Handle successful responses and return the parsed result.
            return ResponseParser.handleSuccess<T>(
              parsedResponse,
              apiModel.model,
            );
          } else {
            if (status == 401) {
              logger.info("Unauthorized (401) for $fullUrl");

              if (locator<LogoutManager>().isLoggingOut) {
                logger.info("Ignored 401 during logout");
                throw ApiException("Unauthorized during logout",
                    status: status);
              }

              throw ApiException("Unauthorized access", status: status);
            }

            // Handle error responses and return an error future.
            return Future<T>.error(await NetworkExceptions.handleError(
              status: status,
              responseBody: parsedResponse,
              pathUrl: apiModel.pathUrl,
            ));
          }
        } on TimeoutException {
          logger.warning("Timeout for $fullUrl after ${timeout.inSeconds}s");
          throw ApiException("Request timed out", status: 408);
        } on SessionExpiredException catch (e) {
          if (!locator<LogoutManager>().isLoggingOut) {
            await locator<LogoutManager>()
                .logout(message: e.message, source: 'RestClient');
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
      maxAttempts: retryCount,
    );
  }

  Future<String> _getToken(String token) async {
    if (token.isNotEmpty) return token;

    try {
      return await locator<TokenProvider>().getValidAccessToken();
    } on SessionExpiredException catch (_) {
      rethrow;
    }
  }

  Future<Map<String, String>> _buildHeaders(
    String token,
    bool isProto,
  ) async =>
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
