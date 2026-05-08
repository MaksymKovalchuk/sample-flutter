import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/feature/home/home_page.dart';
import 'package:sample/src/feature/profile/profile_page.dart';
import 'package:sample/src/feature/settings/settings_page.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/feature/tab_bar/components/bottom_horizontal_bar.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';

class TabBarContent extends StatefulWidget {
  const TabBarContent({required this.uuid, super.key});
  final String? uuid;

  @override
  State<StatefulWidget> createState() => _TabBarContentState();
}

class _TabBarContentState extends State<TabBarContent> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TabBarBloc _tabBloc;

  static const _pages = <Widget>[HomePage(), ProfilePage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    _tabBloc = context.read<TabBarBloc>();
    _tabBloc.add(const InitTabBar());
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: context.colors.cBgMain,
      bottomNavigationBar: BottomHorizontalBar(bloc: _tabBloc),
      body: BlocBuilder<TabBarBloc, TabBarState>(
        buildWhen: (previous, current) =>
            current is TabBarInit || current is TabUpdated,
        builder: (context, state) {
          final page = state is TabUpdated ? state.page : initialTab;
          return IndexedStack(index: page.index, children: _pages);
        },
      ),
    ),
  );
}
