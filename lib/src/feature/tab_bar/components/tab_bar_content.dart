import 'package:sample/src/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'bottom_horizontal_bar.dart';

class TabBarContent extends StatefulWidget {
  const TabBarContent({super.key, required this.uuid});
  final String? uuid;
  @override
  State<StatefulWidget> createState() => _TabBarContentState();
}

class _TabBarContentState extends State<TabBarContent> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final TabBarBloc _tabBloc;

  String? _prevUuid;

  @override
  void initState() {
    _tabBloc = context.read<TabBarBloc>();
    _tabBloc.add(InitTabBar());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TabBarContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.uuid != null && widget.uuid != _prevUuid) {
      _prevUuid = widget.uuid;
      _refresh();
    }
  }

  void _refresh() {}

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: context.colors.cBgMain,
        bottomNavigationBar: BottomHorizontalBar(bloc: _tabBloc),
        body: _buildContent(),
      ));

  Widget _buildContent() => BlocListener<TabBarBloc, TabBarState>(
      listener: (context, state) => _onTabChanged(state),
      child: BlocBuilder<TabBarBloc, TabBarState>(
          buildWhen: (previous, current) => current is TabUpdated,
          builder: (context, state) => const IndexedStack(index: 0, children: [
                SizedBox(),
              ])));

  Future _onTabChanged(TabBarState state) async {}
}
