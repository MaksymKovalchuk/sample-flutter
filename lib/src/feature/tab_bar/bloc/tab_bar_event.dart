part of 'tab_bar_bloc.dart';

abstract class TabBarEvent extends Equatable {
  const TabBarEvent();
  @override
  List<Object> get props => [];
}

class InitTabBar extends TabBarEvent {}

class TabSelected extends TabBarEvent {
  const TabSelected(this.page);
  final TabPage page;
  @override
  List<Object> get props => [page];
}
