import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/section_label.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
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
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TasksCubit>(),
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF191C1E),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          projectTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1E),
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF464555),
            ),
            tooltip: 'Refresh',
            onPressed: () => context.read<TasksCubit>().loadTasks(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTask(context),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) => switch (state) {
          TasksInitial() || TasksLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          TasksError(:final message) => ErrorView(
              message: message,
              onRetry: () => context.read<TasksCubit>().loadTasks(),
            ),
          TasksLoaded(:final tasks) when tasks.isEmpty => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProgressCard(tasks: const []),
                Expanded(
                  child: EmptyStateWidget(
                    icon: Icons.task_alt_rounded,
                    title: 'No tasks yet',
                    subtitle: 'Tap "Add Task" to create the first one.',
                  ),
                ),
              ],
            ),
          TasksLoaded(:final tasks) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProgressCard(tasks: tasks),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<TasksCubit>().loadTasks(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: tasks.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                            child: SectionLabel('TODAY'),
                          );
                        }
                        return TaskCard(task: tasks[i - 1]);
                      },
                    ),
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final List<Task> tasks;
  const _ProgressCard({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final done = tasks.where((t) => t.status.isDone).length;
    final percent = total == 0 ? 0.0 : done / total;
    final pct = (percent * 100).round();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROGRESS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF777587),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$pct% Complete',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1E),
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Text(
                '$done / $total tasks done',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF777587),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: const Color(0xFFE0E3E5),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
            ),
          ),
        ],
      ),
    );
  }
}
