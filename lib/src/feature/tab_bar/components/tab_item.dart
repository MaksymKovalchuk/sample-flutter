import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/constants/constants.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:sample/src/core/widgets/bounce.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';

class AppBottomBarItem {
  AppBottomBarItem({
    required this.page,
    required this.text,
    required this.icon,
    required this.iconActive,
  });

  final TabPage page;
  final String text;
  final IconData icon;
  final IconData iconActive;
}

class TabBarItem extends StatelessWidget {
  const TabBarItem({
    required this.item,
    required this.onPressed,
    required this.bloc,
    super.key,
  });

  final AppBottomBarItem item;
  final ValueChanged<TabPage> onPressed;
  final TabBarBloc bloc;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.only(top: 10),
      height: Constants.tabBarHeight,
      child: Bounce(
        onPressed: () => onPressed(item.page),
        child: BlocBuilder<TabBarBloc, TabBarState>(
          buildWhen: (previous, current) =>
              current is TabBarInit || current is TabUpdated,
          builder: (context, state) {
            final currentPage = state is TabUpdated ? state.page : initialTab;
            final isSelected = currentPage == item.page;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? item.iconActive : item.icon,
                  color: isSelected
                      ? context.colors.cIconActiveSofter
                      : context.colors.cIconDefault,
                  size: Constants.tabIconSize,
                ),
                const SizedBox(height: 6),
                MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.noScaling),
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
