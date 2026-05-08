import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sample/src/feature/home/model/post.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => const [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => const [];
}

final class HomeSuccess extends HomeState {
  const HomeSuccess({required this.posts, this.isRefreshing = false});

  final List<Post> posts;
  final bool isRefreshing;

  HomeSuccess copyWith({List<Post>? posts, bool? isRefreshing}) => HomeSuccess(
    posts: posts ?? this.posts,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );

  @override
  List<Object?> get props => [posts, isRefreshing];
}

final class HomeFailure extends HomeState {
  HomeFailure(this.message, {Key? id}) : id = id ?? UniqueKey();

  final String message;
  final Key id;

  @override
  List<Object?> get props => [message, id];
}
