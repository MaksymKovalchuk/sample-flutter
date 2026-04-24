import 'package:sample/src/core/network/constants/api_router.dart';

class ApiModel {
  ApiModel({
    required this.method,
    required this.pathUrl,
    required this.serviceType,
    this.body,
    this.token = "",
  });

  final String method;
  final String pathUrl;
  final dynamic body;
  final String token;
  final ServiceType serviceType;
}
