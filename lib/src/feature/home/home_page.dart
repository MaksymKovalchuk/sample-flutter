import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:sample/src/feature/home/bloc/home_bloc.dart';
import 'package:sample/src/feature/home/bloc/home_event.dart';
import 'package:sample/src/feature/home/bloc/home_state.dart';
import 'package:sample/src/feature/home/components/posts_list.dart';
import 'package:sample/src/feature/widgets/app_error_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<HomeBloc>(
    create: (_) => locator<HomeBloc>()..add(const HomeStarted()),
    child: Scaffold(
      backgroundColor: context.colors.cBgMain,
      appBar: AppBar(
        backgroundColor: context.colors.cBgMain,
        elevation: 0,
        title: Text(
          context.loc.homeTitle,
          style: StyleManager.styleText(
            fLarge18,
            weight: semiBold,
            color: context.colors.cTextPrimary,
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => switch (state) {
          HomeInitial() ||
          HomeLoading() => const Center(child: CircularProgressIndicator()),
          HomeFailure(:final message) => AppErrorView(
            message: message,
            onRetry: () => context.read<HomeBloc>().add(const HomeRefreshed()),
          ),
          HomeSuccess() => PostsList(state: state),
        },
      ),
    ),
  );
}
