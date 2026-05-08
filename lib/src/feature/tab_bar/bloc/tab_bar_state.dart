part of 'tab_bar_bloc.dart';

sealed class TabBarState extends Equatable {
  const TabBarState();
}

final class TabBarInit extends TabBarState {
  const TabBarInit();

  @override
  List<Object?> get props => const [];
}

final class TabUpdated extends TabBarState {
  const TabUpdated(this.page);
  final TabPage page;

  @override
  List<Object?> get props => [page];
}
