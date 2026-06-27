import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/section_label.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';
import '../widgets/task_card_shimmer.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.r),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Hero(
          tag: 'project-title-$projectId',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              projectTitle,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTask(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) => switch (state) {
          TasksInitial() || TasksLoading() => const TasksShimmerList(),
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
                      padding: EdgeInsets.only(bottom: 120.h),
                      itemCount: tasks.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
                            child: const SectionLabel('TODAY'),
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

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROGRESS',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.outline,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$pct% Complete',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Text(
                '$done / $total tasks done',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(3.r),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6.r,
              backgroundColor: colorScheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
