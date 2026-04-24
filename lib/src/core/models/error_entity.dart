import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_entity.freezed.dart';
part 'error_entity.g.dart';

@freezed
abstract class ErrorEntity with _$ErrorEntity {
  const factory ErrorEntity({String? error, String? detail}) = _ErrorEntity;

  factory ErrorEntity.fromJson(Map<String, dynamic> json) =>
      _$ErrorEntityFromJson(json);
}
