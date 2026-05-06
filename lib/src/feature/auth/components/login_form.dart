import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:sample/src/core/widgets/app_primary_button.dart';
import 'package:sample/src/core/widgets/app_text_field.dart';
import 'package:sample/src/feature/auth/bloc/auth_bloc.dart';
import 'package:sample/src/feature/auth/bloc/auth_event.dart';
import 'package:sample/src/feature/auth/bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // demo prefill — drop for real backend
  static const _demoEmail = 'demo@example.com';
  static const _demoPassword = 'password1';

  final _emailController = TextEditingController(text: _demoEmail);
  final _passwordController = TextEditingController(text: _demoPassword);

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AuthBloc>();
    bloc
      ..add(const AuthEmailChanged(_demoEmail))
      ..add(const AuthPasswordChanged(_demoPassword));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() => context.read<AuthBloc>().add(const AuthLoginSubmitted());

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
    buildWhen: (previous, current) =>
        previous.isLoading != current.isLoading ||
        previous.isFormValid != current.isFormValid,
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(),
        const SizedBox(height: 40),
        AppTextField(
          controller: _emailController,
          hintText: context.loc.authEmailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          readOnly: state.isLoading,
          onChanged: (v) => context.read<AuthBloc>().add(AuthEmailChanged(v)),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _passwordController,
          hintText: context.loc.authPasswordHint,
          obscureText: true,
          readOnly: state.isLoading,
          onChanged: (v) =>
              context.read<AuthBloc>().add(AuthPasswordChanged(v)),
          onDone: _submit,
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: context.loc.authSubmit,
          onPressed: state.isFormValid && !state.isLoading ? _submit : null,
          isLoading: state.isLoading,
        ),
        const SizedBox(height: 16),
        Text(
          context.loc.authDemoHint,
          textAlign: TextAlign.center,
          style: StyleManager.styleText(
            fXSmall12,
            color: context.colors.cTextMuted,
          ),
        ),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        context.loc.authTitle,
        textAlign: TextAlign.center,
        style: StyleManager.styleText(
          fXHuge24,
          weight: bold,
          color: context.colors.cTextPrimary,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        context.loc.authSubtitle,
        textAlign: TextAlign.center,
        style: StyleManager.styleText(
          fLSmall14,
          color: context.colors.cTextSec,
        ),
      ),
    ],
  );
}
