import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/localization.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/enums/task_status.dart';
import '../cubit/tasks_cubit.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status.isDone;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.read<TasksCubit>().toggleStatus(task.id),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TaskCheckbox(isDone: isDone),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: isDone
                                  ? colorScheme.onSurface.withValues(alpha: 0.45)
                                  : colorScheme.onSurface,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor:
                                  colorScheme.onSurface.withValues(alpha: 0.45),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _PriorityChip(priority: task.priority),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _StatusDot(status: task.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCheckbox extends StatelessWidget {
  final bool isDone;
  const _TaskCheckbox({required this.isDone});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isDark
        ? colorScheme.onSurface.withValues(alpha: 0.55)
        : colorScheme.onSurface.withValues(alpha: 0.35);

    return Container(
      width: 24.r,
      height: 24.r,
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? const Color(0xFF10B981) : Colors.transparent,
        border: isDone
            ? null
            : Border.all(color: borderColor, width: 2),
      ),
      child: isDone
          ? Icon(Icons.check_rounded, size: 14.r, color: Colors.white)
          : null,
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final (baseColor, textColor, label) = switch (priority) {
      TaskPriority.high => (
          const Color(0xFFF59E0B),
          const Color(0xFFB45309),
          lang.priorityHigh,
        ),
      TaskPriority.medium => (
          const Color(0xFF3B82F6),
          const Color(0xFF1D4ED8),
          lang.priorityMedium,
        ),
      TaskPriority.low => (
          const Color(0xFF10B981),
          const Color(0xFF15803D),
          lang.priorityLow,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final TaskStatus status;
  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final lang = context.getLang;
    final (dotColor, label) = switch (status) {
      TaskStatus.pending => (const Color(0xFF777587), lang.statusPending),
      TaskStatus.inProgress => (const Color(0xFF3B82F6), lang.statusInProgress),
      TaskStatus.done => (const Color(0xFF10B981), lang.statusDone),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: dotColor,
          ),
        ),
      ],
    );
  }
}
