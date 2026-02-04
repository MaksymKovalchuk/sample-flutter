import 'dart:convert';
import 'package:sample/src/core/models/base/base_model.dart';
import 'package:sample/src/core/models/error_entity.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:http/http.dart';

class ResponseParser {
  const ResponseParser._();

  static dynamic parseResponse(Response response, bool isProto) {
    if (isProto) return response.bodyBytes;

    if (response.body.isEmpty) return {};

    try {
      return jsonDecode(response.body);
    } catch (e) {
      return {};
    }
  }

  static Future<T> handleSuccess<T>(dynamic parsed, BaseModel? model) async {
    if (model != null && parsed != null) {
      return parsedJson<T>(parsed, model);
    }
    return parsed as T;
  }

  static Future<T> parsedJson<T>(dynamic body, BaseModel? model) async {
    if (model == null || body == null) return Future.error("Invalid response");

    try {
      if (body is List) {
        final result = body
            .map((item) => model.fromJson(item))
            .whereType<BaseModel>()
            .toList();
        return result as T;
      }

      return model.fromJson(body) as T;
    } catch (err, stack) {
      logger.error("Parsing error", error: "$err\n$stack");
      return Future.error("Parsing error");
    }
  }

  static Future<String?> parseErrorBody(dynamic body) async {
    if (body == null) return null;

    try {
      Map<String, dynamic>? jsonMap;

      if (body is Map<String, dynamic>) {
        jsonMap = body;
      } else if (body is String) {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          jsonMap = decoded;
        }
      }

      if (jsonMap != null) {
        final errorEntity = ErrorEntity().fromJson(jsonMap);
        return errorEntity?.error ?? errorEntity?.detail;
      }

      return null;
    } catch (e, stack) {
      logger.error("Parsing error in parseErrorBody", error: "$e\n$stack");
      return null;
    }
  }
}
