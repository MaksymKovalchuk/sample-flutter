import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sample/src/core/constants/constants.dart';
import 'package:sample/src/core/constants/images.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/feature/tab_bar/components/tab_item.dart';
import 'package:sample/src/feature/tab_bar/components/tab_main_action.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';

class BottomHorizontalBar extends StatelessWidget {
  const BottomHorizontalBar({required this.bloc, super.key});
  final TabBarBloc bloc;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      AppBottomBarItem(
        page: TabPage.home,
        icon: ImagePaths.home,
        iconActive: ImagePaths.homeActive,
        text: "Home",
      ),
    ];

    final items = List<Widget>.generate(
      tabs.length,
      (i) => TabBarItem(
        isTablet: false,
        bloc: bloc,
        item: tabs[i],
        onPressed: (page) => bloc.add(TabSelected(page)),
      ),
    );

    items.insert(items.length >> 1, _buildMiddleTabItem());

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildBottomAppBar(items, context),
        _buildBorderLine(context),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: TabMainAction(bloc: bloc),
        ),
      ],
    );
  }

  Widget _buildBorderLine(BuildContext context) => Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      height: 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.0, 0.5, 1.0],
          colors: [
            context.colors.cTabGradient1.withValues(alpha: 0.5),
            context.colors.cTabGradient2,
            context.colors.cTabGradient3.withValues(alpha: 0.5),
          ],
        ),
      ),
    ),
  );

  Widget _buildBottomAppBar(List<Widget> items, BuildContext context) =>
      Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: BottomAppBar(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: Constants.tabBarHeight,
                  color: context.colors.cTabBg.withValues(alpha: 0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: items,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(child: Container(color: Colors.transparent)),
            ),
          ],
        ),
      );

  Widget _buildMiddleTabItem() => const Expanded(
    child: SizedBox(
      height: Constants.tabBarHeight,
      child: Center(child: SizedBox(height: Constants.tabIconSize)),
    ),
  );
}
