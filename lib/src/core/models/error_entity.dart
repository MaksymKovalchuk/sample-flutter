import 'package:equatable/equatable.dart';

class ErrorEntity extends Equatable {
  const ErrorEntity({this.error, this.detail});

  factory ErrorEntity.fromJson(Map<String, dynamic> json) => ErrorEntity(
    error: json['error'] as String?,
    detail: json['detail'] as String?,
  );

  final String? error;
  final String? detail;

  @override
  List<Object?> get props => [error, detail];
}
