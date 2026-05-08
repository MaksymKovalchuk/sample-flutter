import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/rest/repositories/posts_repository.dart';
import 'package:sample/src/feature/home/bloc/home_event.dart';
import 'package:sample/src/feature/home/bloc/home_state.dart';
import 'package:sample/src/services/logging/logger.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._postsRepository) : super(const HomeInitial()) {
    on<HomeStarted>(_onStarted, transformer: droppable());
    on<HomeRefreshed>(_onRefreshed, transformer: droppable());
  }

  final PostsRepository _postsRepository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    await _fetch(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;
    if (current is HomeSuccess) {
      emit(current.copyWith(isRefreshing: true));
    }
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<HomeState> emit) async {
    try {
      final posts = await _postsRepository.fetchPosts();
      emit(HomeSuccess(posts: posts));
    } on ApiException catch (e) {
      logger.warning('Posts fetch failed: ${e.message}');
      emit(HomeFailure(e.message));
    } catch (e, stack) {
      logger.error('Unexpected posts error', error: e, stackTrace: stack);
      emit(HomeFailure('Failed to load posts'));
    }
  }
}
