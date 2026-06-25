import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
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
        const SnackBar(content: Text(AppStrings.termsRequired)),
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
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.projects);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE5E2FF), Color(0xFFF7F9FB)],
              stops: [0.0, 0.55],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const AppLogo(),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.registerTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 16),
                  const _RegisterFooter(),
                  const SizedBox(height: 24),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3E5)),
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.createAccount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 6),
            Text(AppStrings.registerSubtitle, style: bodyStyle),
            const SizedBox(height: 24),
            AuthTextField(
              controller: nameController,
              label: AppStrings.fullName,
              hint: AppStrings.fullNameHint,
              keyboardType: TextInputType.name,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppStrings.nameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: emailController,
              label: AppStrings.emailAddress,
              hint: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return AppStrings.emailRequired;
                if (!v.contains('@')) return AppStrings.emailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: passwordController,
              label: AppStrings.password,
              obscure: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return AppStrings.passwordRequired;
                if (v.length < 8) return AppStrings.passwordMinLengthRegister;
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(v)) {
                  return AppStrings.passwordNoSymbol;
                }
                return null;
              },
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                AppStrings.passwordRegisterHint,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: termsAccepted,
                    onChanged: onTermsChanged,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: bodyStyle,
                      children: [
                        const TextSpan(text: AppStrings.termsPrefix),
                        TextSpan(
                            text: AppStrings.termsOfService, style: linkStyle),
                        const TextSpan(text: AppStrings.termsAnd),
                        TextSpan(
                            text: AppStrings.privacyPolicy, style: linkStyle),
                        const TextSpan(text: AppStrings.termsSuffix),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return FilledButton(
                  onPressed: state is AuthLoading ? null : onSubmit,
                  child: state is AuthLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppStrings.signUp),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Color(0xFFC7C4D8)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.alreadyHaveAccount, style: bodyStyle),
                TextButton(
                  onPressed: onSignIn,
                  child: const Text(
                    AppStrings.signIn,
                    style: TextStyle(fontWeight: FontWeight.w600),
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
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 0.6,
        );

    return Column(
      children: [
        Text(AppStrings.enterpriseEditionFull, style: labelStyle),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppStrings.projects, AppStrings.tasks, 'Team', AppStrings.settings]
              .map(
                (label) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(label, style: labelStyle),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
