abstract class BaseModel {
  dynamic fromJson(Map<String, dynamic>? json);
  Map<String, dynamic>? toJson();
}
