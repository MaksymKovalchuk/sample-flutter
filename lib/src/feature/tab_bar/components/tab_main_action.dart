import 'package:sample/src/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';

class TabMainAction extends StatelessWidget {
  const TabMainAction({super.key, required this.bloc});
  final TabBarBloc bloc;

  @override
  Widget build(BuildContext context) => Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: context.colors.cBtnBar,
          borderRadius: BorderRadius.circular(16)),
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Image.asset(ImagePaths.home,
            color: context.colors.cButtonText, height: 20, width: 20)
      ]));
}
