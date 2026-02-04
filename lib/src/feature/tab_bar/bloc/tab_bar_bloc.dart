import 'dart:async';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';
import 'package:sample/src/core/app_initializer/app_initializer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/services/logging/logger.dart';

part 'tab_bar_event.dart';
part 'tab_bar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  TabBarBloc() : super(TabBarInit()) {
    on<InitTabBar>(_onInitTabBar);
    on<TabSelected>(_onPageTappedEvent);
  }

  Future<void> _onInitTabBar(
    InitTabBar event,
    Emitter<TabBarState> emit,
  ) async {
    try {
      await _initializeAuth();
    } catch (error) {
      logger.error("TabBar error:", error: error);
    }
  }

  Future<void> _initializeAuth() async {
    try {
      await locator<AppInitializer>().ready;
    } catch (e) {
      logger.error("Auth failed", error: e);
    }
  }

  Future<void> _onPageTappedEvent(
    TabSelected event,
    Emitter<TabBarState> emit,
  ) async {
    emit(TabUpdated(event.page));
  }
}
