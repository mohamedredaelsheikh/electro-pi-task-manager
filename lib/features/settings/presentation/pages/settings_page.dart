import 'package:flutter/material.dart';

import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/section_label.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        title: const AppBarLogo(title: 'Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 32),
          const SectionLabel('PREFERENCES'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.notifications_none_rounded,
                label: 'NOTIFICATIONS',
                subtitle: 'In-app task alerts',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith((states) =>
                      states.contains(WidgetState.selected)
                          ? const Color(0xFF4F46E5)
                          : const Color(0xFFC7C4D8)),
                  trackOutlineColor:
                      WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              const Divider(
                  height: 1, color: Color(0xFFE0E3E5), indent: 68),
              const _SettingRow(
                icon: Icons.palette_outlined,
                label: 'APPEARANCE',
                subtitle: 'Light',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF777587),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionLabel('TASKS'),
          const SizedBox(height: 8),
          const _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.flag_outlined,
                label: 'DEFAULT PRIORITY',
                subtitle: 'Medium',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF777587),
                  size: 20,
                ),
              ),
              Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.sort_rounded,
                label: 'SORT TASKS BY',
                subtitle: 'Due Date',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF777587),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionLabel('ABOUT'),
          const SizedBox(height: 8),
          const _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.info_outline_rounded,
                label: 'APP VERSION',
                subtitle: '1.0.0',
              ),
              Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.privacy_tip_outlined,
                label: 'PRIVACY POLICY',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF777587),
                  size: 20,
                ),
              ),
              Divider(height: 1, color: Color(0xFFE0E3E5), indent: 68),
              _SettingRow(
                icon: Icons.description_outlined,
                label: 'TERMS OF SERVICE',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF777587),
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

  const _SettingRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
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
  }
}
