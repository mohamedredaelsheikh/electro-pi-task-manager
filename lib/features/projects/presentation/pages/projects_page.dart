import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/localization.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../widgets/project_card.dart';
import '../widgets/project_card_shimmer.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        title: AppBarLogo(title: lang.projects),
      ),
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) => switch (state) {
          ProjectsInitial() || ProjectsLoading() => const ProjectsShimmerList(),
          ProjectsLoaded(:final projects) when projects.isEmpty =>
            RefreshIndicator(
              onRefresh: () => context.read<ProjectsCubit>().loadProjects(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: EmptyStateWidget(
                      icon: Icons.folder_open_rounded,
                      title: lang.noProjects,
                      subtitle: lang.noProjectsSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ProjectsLoaded(:final projects) => RefreshIndicator(
            onRefresh: () => context.read<ProjectsCubit>().loadProjects(),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
              itemCount: projects.length,
              itemBuilder: (context, index) => ProjectCard(
                project: projects[index],
                onTap: () => context.push(
                  AppRoutes.projectDetailsPath(projects[index].id),
                  extra: projects[index].title,
                ),
              ),
            ),
          ),
          ProjectsError(:final message) => ErrorView(
            message: message,
            onRetry: () => context.read<ProjectsCubit>().loadProjects(),
          ),
        },
      ),
    );
  }
}
