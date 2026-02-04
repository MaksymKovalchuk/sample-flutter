import 'package:sample/src/core/models/base/base_model.dart';
import 'package:sample/src/core/network/constants/api_router.dart';

// A model class to represent the details of an API request.
class ApiModel {
  ApiModel({
    required this.method,
    required this.pathUrl,
    required this.serviceType,
    this.body,
    this.model,
    this.token = "",
  });

  final String method;
  final String pathUrl;
  final dynamic body;
  final BaseModel? model;
  final String token;
  final ServiceType serviceType;
}
