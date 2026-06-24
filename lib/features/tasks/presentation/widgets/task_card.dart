import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3E5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TaskCheckbox(
              isDone: isDone,
              onTap: isDone
                  ? null
                  : () => context.read<TasksCubit>().markAsDone(task.id),
            ),
            const SizedBox(width: 12),
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: isDone
                                ? const Color(0xFF191C1E).withValues(alpha: 0.45)
                                : const Color(0xFF191C1E),
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor:
                                const Color(0xFF191C1E).withValues(alpha: 0.45),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _PriorityChip(priority: task.priority),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _StatusDot(status: task.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCheckbox extends StatelessWidget {
  final bool isDone;
  final VoidCallback? onTap;

  const _TaskCheckbox({required this.isDone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? const Color(0xFF10B981) : Colors.white,
          border: isDone
              ? null
              : Border.all(color: const Color(0xFFC7C4D8), width: 1.5),
        ),
        child: isDone
            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final (baseColor, textColor, label) = switch (priority) {
      TaskPriority.high => (
          const Color(0xFFF59E0B),
          const Color(0xFFB45309),
          'HIGH',
        ),
      TaskPriority.medium => (
          const Color(0xFF3B82F6),
          const Color(0xFF1D4ED8),
          'MEDIUM',
        ),
      TaskPriority.low => (
          const Color(0xFF10B981),
          const Color(0xFF15803D),
          'LOW',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
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
    final (dotColor, label) = switch (status) {
      TaskStatus.pending => (const Color(0xFF777587), 'Pending'),
      TaskStatus.inProgress => (const Color(0xFF3B82F6), 'In Progress'),
      TaskStatus.done => (const Color(0xFF10B981), 'Done'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: dotColor,
          ),
        ),
      ],
    );
  }
}
