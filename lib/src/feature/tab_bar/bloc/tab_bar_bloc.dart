import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/session/app_initializer.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';
import 'package:sample/src/services/logging/logger.dart';

part 'tab_bar_event.dart';
part 'tab_bar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  TabBarBloc(this._initializer) : super(const TabBarInit()) {
    on<InitTabBar>(_onInitTabBar);
    on<TabSelected>(_onPageTappedEvent);
  }

  final AppInitializer _initializer;

  Future<void> _onInitTabBar(
    InitTabBar event,
    Emitter<TabBarState> emit,
  ) async {
    try {
      await _initializer.ready;
    } catch (error) {
      logger.error("TabBar init failed", error: error);
    }
  }

  Future<void> _onPageTappedEvent(
    TabSelected event,
    Emitter<TabBarState> emit,
  ) async {
    emit(TabUpdated(event.page));
  }
}
