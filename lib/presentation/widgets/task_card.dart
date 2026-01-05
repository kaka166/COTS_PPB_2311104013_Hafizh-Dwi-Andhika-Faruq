import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChecked;

  const TaskCard({super.key, required this.task, this.onTap, this.onChecked});

  Color _statusColor() {
    switch (task.status) {
      case 'SELESAI':
        return AppColors.success;
      case 'TERLAMBAT':
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: task.isDone,
                activeColor: AppColors.primary,
                onChanged: onChecked,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: AppTypography.title),
                    const SizedBox(height: AppSpacing.xs),
                    Text(task.course, style: AppTypography.body),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.status,
                            style: AppTypography.caption.copyWith(
                              color: _statusColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Deadline: '
                          '${task.deadline.year}-'
                          '${task.deadline.month.toString().padLeft(2, '0')}-'
                          '${task.deadline.day.toString().padLeft(2, '0')}',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
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
