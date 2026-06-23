import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../widgets/project_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProjectsCubit>().loadProjects(),
          ),
        ],
      ),
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) => switch (state) {
          ProjectsInitial() || ProjectsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ProjectsLoaded(:final projects) when projects.isEmpty =>
            EmptyStateWidget(
              icon: Icons.folder_open,
              title: 'No projects yet',
              subtitle: 'Your projects will appear here.',
            ),
          ProjectsLoaded(:final projects) => RefreshIndicator(
              onRefresh: () => context.read<ProjectsCubit>().loadProjects(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
