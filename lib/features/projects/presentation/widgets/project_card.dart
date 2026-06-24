import 'package:flutter/material.dart';

import '../../domain/entities/project.dart';
import '../../domain/enums/project_status.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3E5)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1E),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusChip(status: project.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF464555),
                    height: 1.43,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ProjectStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (baseColor, textColor, label) = switch (status) {
      ProjectStatus.pending => (
          const Color(0xFFF59E0B),
          const Color(0xFFB45309),
          'Pending',
        ),
      ProjectStatus.inProgress => (
          const Color(0xFF3B82F6),
          const Color(0xFF1D4ED8),
          'In Progress',
        ),
      ProjectStatus.done => (
          const Color(0xFF10B981),
          const Color(0xFF15803D),
          'Done',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
