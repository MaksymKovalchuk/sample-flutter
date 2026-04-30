import 'package:flutter/material.dart';
import 'package:sample/src/feature/tab_bar/components/tab_bar_content.dart';

const TabPage initialTab = TabPage.home;

enum TabPage { home, profile, settings }

extension TabPageX on TabPage {
  int get index => TabPage.values.indexOf(this);
  static TabPage fromIndex(int i) => TabPage.values[i];
}

class TabBarPage extends StatelessWidget {
  const TabBarPage({required this.uuid, super.key});
  final String? uuid;

  @override
  Widget build(BuildContext context) => TabBarContent(uuid: uuid);
}
