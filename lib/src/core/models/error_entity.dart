import 'base/base_model.dart';

class ErrorEntity extends BaseModel {
  ErrorEntity({this.error, this.detail});

  String? error;
  String? detail;

  @override
  fromJson(Map<String, dynamic>? json) {
    if (json == null) throw const FormatException("Null JSON");
    return ErrorEntity(
      error: json['error'] as String?,
      detail: json['detail'] as String?,
    );
  }

  @override
  Map<String, dynamic>? toJson() => null;
}
