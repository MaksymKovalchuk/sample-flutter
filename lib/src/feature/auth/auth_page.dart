import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/di/injection.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/widgets/app_snack_bar.dart';
import 'package:sample/src/feature/auth/bloc/auth_bloc.dart';
import 'package:sample/src/feature/auth/bloc/auth_state.dart';
import 'package:sample/src/feature/auth/components/login_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
    create: (_) => getIt<AuthBloc>(),
    child: BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
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
