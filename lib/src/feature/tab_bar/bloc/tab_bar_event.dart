part of 'tab_bar_bloc.dart';

sealed class TabBarEvent extends Equatable {
  const TabBarEvent();
}

final class InitTabBar extends TabBarEvent {
  const InitTabBar();

  @override
  List<Object?> get props => const [];
}

final class TabSelected extends TabBarEvent {
  const TabSelected(this.page);
  final TabPage page;

  @override
  List<Object?> get props => [page];
}
