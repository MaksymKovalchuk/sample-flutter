import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/rest/repositories/posts_repository.dart';
import 'package:sample/src/feature/home/bloc/home_event.dart';
import 'package:sample/src/feature/home/bloc/home_state.dart';
import 'package:sample/src/services/logging/logger.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._postsRepository) : super(const HomeState()) {
    on<HomeStarted>(_onStarted, transformer: droppable());
    on<HomeRefreshed>(_onRefreshed, transformer: droppable());
  }

  final PostsRepository _postsRepository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    await _fetch(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, error: null));
    await _fetch(emit, isRefresh: true);
  }

  Future<void> _fetch(Emitter<HomeState> emit, {bool isRefresh = false}) async {
    try {
      final posts = await _postsRepository.fetchPosts();
      emit(state.copyWith(posts: posts, isLoading: false, isRefreshing: false));
    } on ApiException catch (e) {
      logger.warning('Posts fetch failed: ${e.message}');
      emit(
        state.copyWith(isLoading: false, isRefreshing: false, error: e.message),
      );
    } catch (e, stack) {
      logger.error('Unexpected posts error', error: e, stackTrace: stack);
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: 'Failed to load posts',
        ),
      );
    }
  }
}
