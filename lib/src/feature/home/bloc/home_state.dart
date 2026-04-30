import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sample/src/feature/home/model/post.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(<Post>[]) List<Post> posts,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? error,
  }) = _HomeState;
}
