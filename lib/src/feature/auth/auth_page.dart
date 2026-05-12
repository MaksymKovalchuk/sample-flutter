import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/feature/auth/bloc/auth_bloc.dart';
import 'package:sample/src/feature/auth/bloc/auth_state.dart';
import 'package:sample/src/feature/auth/components/login_form.dart';
import 'package:sample/src/feature/widgets/app_snack_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
    create: (_) => locator<AuthBloc>(),
    child: BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthIdle && current.error != null,
      listener: (context, state) {
        if (state is! AuthIdle) return;
        final error = state.error;
        if (error != null) SnackBarManager().show(context, message: error);
      },
      child: Scaffold(
        backgroundColor: context.colors.cBgMain,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [Spacer(), LoginForm(), Spacer(flex: 2)]),
          ),
        ),
      ),
    ),
  );
}
