import 'dart:convert';

import 'package:http/http.dart';
import 'package:sample/src/core/models/error_entity.dart';
import 'package:sample/src/services/logging/logger.dart';

class ResponseParser {
  const ResponseParser._();

  static dynamic parseResponse(Response response, {required bool isProto}) {
    if (isProto) return response.bodyBytes;

    if (response.body.isEmpty) return <String, dynamic>{};

    try {
      return jsonDecode(response.body);
    } catch (_) {
      return <String, dynamic>{};
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
        final errorEntity = ErrorEntity.fromJson(jsonMap);
        return errorEntity.error ?? errorEntity.detail;
      }

      return null;
    } catch (e, stack) {
      logger.error("Parsing error in parseErrorBody", error: "$e\n$stack");
      return null;
    }
  }
}
