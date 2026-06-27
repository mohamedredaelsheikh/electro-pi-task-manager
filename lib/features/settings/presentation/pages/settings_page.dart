import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/localization.dart';
import '../../../../core/extensions/show_default_sheet.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../features/Localization/presentation/logic/lang_cubit/lang_cubit.dart';
import '../../../../features/Localization/presentation/widgets/language_sheet.dart';
import '../../domain/enums/app_theme_mode.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final cubit = context.read<SettingsCubit>();
    final themeMode = context.watch<SettingsCubit>().state.themeMode;
    final isDark = themeMode == AppThemeMode.dark;
    final currentLanguage = context.watch<LangCubit>().state.currentLanguage;

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        title: AppBarLogo(title: lang.settings),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 32.h),
          SectionLabel(lang.preferences),
          SizedBox(height: 8.h),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.dark_mode_outlined,
                label: lang.darkMode,
                subtitle: isDark ? lang.themeDark : lang.themeLight,
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) => cubit.setThemeMode(
                    v ? AppThemeMode.dark : AppThemeMode.light,
                  ),
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              Divider(
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
                color: colorScheme.outlineVariant,
              ),
              _SettingRow(
                icon: Icons.language_outlined,
                label: lang.languages,
                subtitle: currentLanguage.nativeName,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20.r,
                ),
                onTap: () => context.showDefaultSheet(
                  child: BlocProvider.value(
                    value: context.read<LangCubit>(),
                    child: const LanguageSheet(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SectionLabel(lang.about),
          SizedBox(height: 8.h),
          _SettingsCard(
            children: [
              _SettingRow(
                icon: Icons.info_outline_rounded,
                label: lang.appVersion,
                subtitle: lang.appVersionValue,
              ),
            ],
          ),
          SizedBox(height: 40.h),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14.sp,
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
              SizedBox(width: 8.w),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
