import 'package:flutter/material.dart';
import 'package:sample/src/feature/tab_bar/components/tab_bar_content.dart';

const TabPage initialTab = TabPage.home;

enum TabPage { home }

const tabIndexMap = {TabPage.home: 0};

const indexToTabMap = {0: TabPage.home};

extension TabPageX on TabPage {
  int get index => indexOf(this);
  static TabPage fromIndex(int i) => TabPage.values[i];
  static int indexOf(TabPage page) => TabPage.values.indexOf(page);
}

class TabBarPage extends StatelessWidget {
  const TabBarPage({required this.uuid, super.key});
  final String? uuid;

  @override
  Widget build(BuildContext context) => TabBarContent(uuid: uuid);
}
