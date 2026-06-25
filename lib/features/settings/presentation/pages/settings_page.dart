import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/section_label.dart';
import '../../domain/enums/app_theme_mode.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  void _showThemePicker(BuildContext context, AppThemeMode current) {
    final cubit = context.read<SettingsCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ThemePickerSheet(
        current: current,
        onSelect: (mode) {
          cubit.setThemeMode(mode);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsCubit>().state.themeMode;
    final themeName = switch (themeMode) {
      AppThemeMode.light => AppStrings.themeLight,
      AppThemeMode.dark => AppStrings.themeDark,
      AppThemeMode.system => AppStrings.themeSystem,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        title: const AppBarLogo(title: AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 32),
          const SectionLabel(AppStrings.preferences),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.notifications_none_rounded,
                label: AppStrings.notifications,
                subtitle: AppStrings.notificationsSubtitle,
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFFC7C4D8),
                  ),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.palette_outlined,
                label: AppStrings.appearance,
                subtitle: themeName,
                onTap: () => _showThemePicker(context, themeMode),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionLabel(AppStrings.tasks),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.flag_outlined,
                label: AppStrings.defaultPriority,
                subtitle: AppStrings.defaultPriorityValue,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.sort_rounded,
                label: AppStrings.sortTasksBy,
                subtitle: AppStrings.sortTasksByValue,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionLabel(AppStrings.about),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              const _SettingRow(
                icon: Icons.info_outline_rounded,
                label: AppStrings.appVersion,
                subtitle: AppStrings.appVersionValue,
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.privacy_tip_outlined,
                label: AppStrings.privacyPolicyLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.description_outlined,
                label: AppStrings.termsOfServiceLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3E5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.6,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}

class _ThemePickerSheet extends StatelessWidget {
  final AppThemeMode current;
  final ValueChanged<AppThemeMode> onSelect;

  const _ThemePickerSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.chooseAppearance,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          for (final mode in AppThemeMode.values)
            RadioListTile<AppThemeMode>(
              title: Text(_label(mode)),
              secondary: Icon(_icon(mode), color: colorScheme.primary),
              value: mode,
              groupValue: current,
              activeColor: colorScheme.primary,
              onChanged: (v) {
                if (v != null) onSelect(v);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _label(AppThemeMode mode) => switch (mode) {
        AppThemeMode.light => AppStrings.themeLight,
        AppThemeMode.dark => AppStrings.themeDark,
        AppThemeMode.system => AppStrings.themeSystem,
      };

  IconData _icon(AppThemeMode mode) => switch (mode) {
        AppThemeMode.light => Icons.light_mode_outlined,
        AppThemeMode.dark => Icons.dark_mode_outlined,
        AppThemeMode.system => Icons.phone_android_outlined,
      };
}
