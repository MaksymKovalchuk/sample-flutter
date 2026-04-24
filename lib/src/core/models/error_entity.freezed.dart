// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ErrorEntity {

 String? get error; String? get detail;
/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorEntityCopyWith<ErrorEntity> get copyWith => _$ErrorEntityCopyWithImpl<ErrorEntity>(this as ErrorEntity, _$identity);

  /// Serializes this ErrorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorEntity&&(identical(other.error, error) || other.error == error)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error,detail);

@override
String toString() {
  return 'ErrorEntity(error: $error, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $ErrorEntityCopyWith<$Res>  {
  factory $ErrorEntityCopyWith(ErrorEntity value, $Res Function(ErrorEntity) _then) = _$ErrorEntityCopyWithImpl;
@useResult
$Res call({
 String? error, String? detail
});




}
/// @nodoc
class _$ErrorEntityCopyWithImpl<$Res>
    implements $ErrorEntityCopyWith<$Res> {
  _$ErrorEntityCopyWithImpl(this._self, this._then);

  final ErrorEntity _self;
  final $Res Function(ErrorEntity) _then;

/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = freezed,Object? detail = freezed,}) {
  return _then(_self.copyWith(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorEntity].
extension ErrorEntityPatterns on ErrorEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorEntity value)  $default,){
final _that = this;
switch (_that) {
case _ErrorEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? error,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorEntity() when $default != null:
return $default(_that.error,_that.detail);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? error,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _ErrorEntity():
return $default(_that.error,_that.detail);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? error,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _ErrorEntity() when $default != null:
return $default(_that.error,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ErrorEntity implements ErrorEntity {
  const _ErrorEntity({this.error, this.detail});
  factory _ErrorEntity.fromJson(Map<String, dynamic> json) => _$ErrorEntityFromJson(json);

@override final  String? error;
@override final  String? detail;

/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorEntityCopyWith<_ErrorEntity> get copyWith => __$ErrorEntityCopyWithImpl<_ErrorEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorEntity&&(identical(other.error, error) || other.error == error)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error,detail);

@override
String toString() {
  return 'ErrorEntity(error: $error, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$ErrorEntityCopyWith<$Res> implements $ErrorEntityCopyWith<$Res> {
  factory _$ErrorEntityCopyWith(_ErrorEntity value, $Res Function(_ErrorEntity) _then) = __$ErrorEntityCopyWithImpl;
@override @useResult
$Res call({
 String? error, String? detail
});




}
/// @nodoc
class __$ErrorEntityCopyWithImpl<$Res>
    implements _$ErrorEntityCopyWith<$Res> {
  __$ErrorEntityCopyWithImpl(this._self, this._then);

  final _ErrorEntity _self;
  final $Res Function(_ErrorEntity) _then;

/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? detail = freezed,}) {
  return _then(_ErrorEntity(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
