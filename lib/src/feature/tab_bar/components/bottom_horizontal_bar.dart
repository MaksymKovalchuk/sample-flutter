import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sample/src/core/constants/constants.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/feature/tab_bar/components/tab_item.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';

class BottomHorizontalBar extends StatelessWidget {
  const BottomHorizontalBar({required this.bloc, super.key});
  final TabBarBloc bloc;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      AppBottomBarItem(
        page: TabPage.home,
        icon: Icons.home_outlined,
        iconActive: Icons.home,
        text: context.loc.tabHome,
      ),
      AppBottomBarItem(
        page: TabPage.profile,
        icon: Icons.person_outline,
        iconActive: Icons.person,
        text: context.loc.tabProfile,
      ),
      AppBottomBarItem(
        page: TabPage.settings,
        icon: Icons.settings_outlined,
        iconActive: Icons.settings,
        text: context.loc.tabSettings,
      ),
    ];

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildBottomAppBar(
          List.generate(
            tabs.length,
            (i) => TabBarItem(
              bloc: bloc,
              item: tabs[i],
              onPressed: (page) => bloc.add(TabSelected(page)),
            ),
          ),
          context,
        ),
        _buildBorderLine(context),
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
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: Constants.tabBarHeight,
              color: context.colors.cTabBg.withValues(alpha: 0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items,
              ),
            ),
          ),
        ),
      );
}
