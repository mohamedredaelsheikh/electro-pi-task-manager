import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';

class ProjectDetailsPage extends StatelessWidget {
  final int projectId;
  final String projectTitle;

  const ProjectDetailsPage({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  void _showAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<TasksCubit>(),
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TasksCubit>().loadTasks(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTask(context),
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) => switch (state) {
          TasksInitial() || TasksLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          TasksLoaded(:final tasks) when tasks.isEmpty => EmptyStateWidget(
              icon: Icons.task_alt,
              title: 'No tasks yet',
              subtitle: 'Tap "Add task" to create the first one.',
            ),
          TasksLoaded(:final tasks) => RefreshIndicator(
              onRefresh: () => context.read<TasksCubit>().loadTasks(),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 96, top: 8),
                itemCount: tasks.length,
                itemBuilder: (_, i) => TaskCard(task: tasks[i]),
              ),
            ),
          TasksError(:final message) => ErrorView(
              message: message,
              onRetry: () => context.read<TasksCubit>().loadTasks(),
            ),
        },
      ),
    );
  }
}
