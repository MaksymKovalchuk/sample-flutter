import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/constants/constants.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/feature/widgets/bounce.dart';

class AppBottomBarItem {
  AppBottomBarItem({
    required this.page,
    required this.text,
    required this.icon,
    required this.iconActive,
  });

  final TabPage page;
  final String text;
  final String icon;
  final String iconActive;
}

class TabBarItem extends StatelessWidget {
  const TabBarItem({
    super.key,
    required this.item,
    required this.onPressed,
    required this.bloc,
    required this.isTablet,
  });

  final AppBottomBarItem item;
  final ValueChanged<TabPage> onPressed;
  final TabBarBloc bloc;
  final bool isTablet;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          height: isTablet ? 0 : Constants.tabBarHeight,
          width: isTablet ? Constants.tabBarWidth : 0,
          child: Bounce(
            onPressed: () => onPressed(item.page),
            child: BlocBuilder<TabBarBloc, TabBarState>(
              buildWhen: (previous, current) => current is TabUpdated,
              builder: (context, state) {
                final isSelected = TabPage.home == item.page;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      isSelected ? item.iconActive : item.icon,
                      color: isSelected
                          ? context.colors.cIconActiveSofter
                          : context.colors.cIconDefault,
                      fit: BoxFit.contain,
                      width: Constants.tabIconSize,
                      height: Constants.tabIconSize,
                    ),
                    const SizedBox(height: 12),
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: Text(
                        item.text,
                        style: StyleManager.styleText(
                          fXSmall12,
                          color: isSelected
                              ? context.colors.cTextSofter
                              : context.colors.cTextSec,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}
