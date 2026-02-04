import 'package:sample/src/feature/tab_bar/di/tab_bar_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/tab_bar_content.dart';

const TabPage initialTab = TabPage.home;

enum TabPage { home }

const tabIndexMap = {
  TabPage.home: 0,
};

const indexToTabMap = {
  0: TabPage.home,
};

extension TabPageX on TabPage {
  int get index => indexOf(this);
  static TabPage fromIndex(int i) => TabPage.values[i];
  static int indexOf(TabPage page) => TabPage.values.indexOf(page);
}

class TabBarPage extends StatelessWidget {
  const TabBarPage({super.key, required this.uuid});
  final String? uuid;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
      providers: getTabBarProviders(), child: TabBarContent(uuid: uuid));
}
