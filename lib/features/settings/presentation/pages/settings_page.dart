import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/localization.dart';
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

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final cubit = context.read<SettingsCubit>();
    final themeMode = context.watch<SettingsCubit>().state.themeMode;
    final isDark = themeMode == AppThemeMode.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        title: AppBarLogo(title: lang.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 32),
          SectionLabel(lang.preferences),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.notifications_none_rounded,
                label: lang.notifications,
                subtitle: lang.notificationsSubtitle,
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
                icon: Icons.dark_mode_outlined,
                label: lang.darkMode,
                subtitle: isDark ? lang.themeDark : lang.themeLight,
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) => cubit.setThemeMode(
                    v ? AppThemeMode.dark : AppThemeMode.system,
                  ),
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFFC7C4D8),
                  ),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionLabel(lang.tasks),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.flag_outlined,
                label: lang.defaultPriority,
                subtitle: lang.defaultPriorityValue,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.sort_rounded,
                label: lang.sortTasksBy,
                subtitle: lang.sortTasksByValue,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionLabel(lang.about),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.info_outline_rounded,
                label: lang.appVersion,
                subtitle: lang.appVersionValue,
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.privacy_tip_outlined,
                label: lang.privacyPolicyLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.description_outlined,
                label: lang.termsOfServiceLabel,
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
