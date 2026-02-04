part of 'tab_bar_bloc.dart';

abstract class TabBarState extends Equatable {
  const TabBarState();
  @override
  List<Object> get props => [];
}

class TabBarInit extends TabBarState {}

class TabUpdated extends TabBarState {
  const TabUpdated(this.page);
  final TabPage page;
  @override
  List<Object> get props => [page];
  @override
  String toString() => 'TabUpdated(page: $page)';
}
