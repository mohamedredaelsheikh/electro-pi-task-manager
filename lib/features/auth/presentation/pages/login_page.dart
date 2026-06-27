import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/localization.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_logo.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _staySignedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.projects);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primary.withValues(alpha: 0.15),
                colorScheme.surfaceContainerLow,
              ],
              stops: const [0.0, 0.55],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  const AppLogo(),
                  SizedBox(height: 28.h),
                  _LoginCard(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    staySignedIn: _staySignedIn,
                    onStaySignedInChanged: (v) =>
                        setState(() => _staySignedIn = v ?? false),
                    onSubmit: _submit,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.getLang.noAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.register),
                        child: Text(context.getLang.signUp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  const _Footer(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool staySignedIn;
  final ValueChanged<bool?> onStaySignedInChanged;
  final VoidCallback onSubmit;

  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.staySignedIn,
    required this.onStaySignedInChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lang = context.getLang;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: EdgeInsets.all(24.r),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.welcomeBack,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 6.h),
            Text(
              lang.loginSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 24.h),
            AuthTextField(
              controller: emailController,
              label: lang.emailAddress,
              hint: lang.emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return lang.emailRequired;
                if (!v.contains('@')) return lang.emailInvalid;
                return null;
              },
            ),
            SizedBox(height: 16.h),
            AuthTextField(
              controller: passwordController,
              label: lang.password,
              obscure: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return lang.passwordRequired;
                if (v.length < 6) return lang.passwordMinLength;
                return null;
              },
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: Checkbox(
                    value: staySignedIn,
                    onChanged: onStaySignedInChanged,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(lang.staySignedIn,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 24.h),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return FilledButton(
                  onPressed: state is AuthLoading ? null : onSubmit,
                  child: state is AuthLoading
                      ? SizedBox(
                          height: 20.r,
                          width: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.getLang.signIn),
                            SizedBox(width: 8.w),
                            Icon(Icons.arrow_forward_rounded, size: 18.r),
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 0.6,
        );

    return Column(
      children: [
        Text(lang.enterpriseEdition, style: labelStyle),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: labelStyle,
              ),
              child: Text(lang.privacyPolicy),
            ),
            Text('•', style: labelStyle),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: labelStyle,
              ),
              child: Text(lang.termsOfService),
            ),
          ],
        ),
      ],
    );
  }
}
