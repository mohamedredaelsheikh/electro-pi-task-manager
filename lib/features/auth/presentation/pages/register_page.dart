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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.getLang.termsRequired)),
      );
      return;
    }
    context.read<AuthCubit>().register(
          name: _nameController.text.trim(),
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
                  SizedBox(height: 32.h),
                  const AppLogo(),
                  SizedBox(height: 8.h),
                  Text(
                    context.getLang.registerTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: 20.h),
                  _RegisterCard(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    termsAccepted: _termsAccepted,
                    onTermsChanged: (v) =>
                        setState(() => _termsAccepted = v ?? false),
                    onSubmit: _submit,
                    onSignIn: () => context.pop(),
                  ),
                  SizedBox(height: 16.h),
                  const _RegisterFooter(),
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

class _RegisterCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool termsAccepted;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSubmit;
  final VoidCallback onSignIn;

  const _RegisterCard({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.termsAccepted,
    required this.onTermsChanged,
    required this.onSubmit,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lang = context.getLang;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
    final linkStyle = TextStyle(
      color: colorScheme.primary,
      fontWeight: FontWeight.w600,
      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
    );

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
              lang.createAccount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 6.h),
            Text(lang.registerSubtitle, style: bodyStyle),
            SizedBox(height: 24.h),
            AuthTextField(
              controller: nameController,
              label: lang.fullName,
              hint: lang.fullNameHint,
              keyboardType: TextInputType.name,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? lang.nameRequired
                  : null,
            ),
            SizedBox(height: 16.h),
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
                if (v.length < 8) return lang.passwordMinLengthRegister;
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(v)) {
                  return lang.passwordNoSymbol;
                }
                return null;
              },
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                lang.passwordRegisterHint,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: Checkbox(
                    value: termsAccepted,
                    onChanged: onTermsChanged,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: bodyStyle,
                      children: [
                        TextSpan(text: lang.termsPrefix),
                        TextSpan(text: lang.termsOfService, style: linkStyle),
                        TextSpan(text: lang.termsAnd),
                        TextSpan(text: lang.privacyPolicy, style: linkStyle),
                        TextSpan(text: lang.termsSuffix),
                      ],
                    ),
                  ),
                ),
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
                            Text(context.getLang.signUp),
                            SizedBox(width: 8.w),
                            Icon(Icons.arrow_forward_rounded, size: 18.r),
                          ],
                        ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Divider(color: colorScheme.outlineVariant),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(lang.alreadyHaveAccount, style: bodyStyle),
                TextButton(
                  onPressed: onSignIn,
                  child: Text(
                    lang.signIn,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterFooter extends StatelessWidget {
  const _RegisterFooter();

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 0.6,
        );

    return Column(
      children: [
        Text(lang.enterpriseEditionFull, style: labelStyle),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [lang.projects, lang.tasks, 'Team', lang.settings]
              .map(
                (label) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(label, style: labelStyle),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
