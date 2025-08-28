import 'package:flutter/material.dart';
import 'package:taskbunny/core/constant/app_constant.dart';
import 'package:taskbunny/core/utils/utils.dart';
import 'package:taskbunny/screen.dart/model/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompletion;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = AppDateUtils.isOverdue(task.dueDate) && !task.isCompleted;
    final isDueToday = AppDateUtils.isDueToday(task.dueDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        leading: Checkbox(
          side: const BorderSide(color: Colors.white, width: 2),
          value: task.isCompleted,
          onChanged: (_) => onToggleCompletion(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(width: 4),
                Text(
                  '${AppStrings.due}: ${AppDateUtils.formatDateTime(task.dueDate)}',
                  style: TextStyle(
                    color: isOverdue 
                        ? Colors.red.shade300 
                        : Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  _getPriorityIcon(task.priority),
                  size: 16,
                  color: _getPriorityColor(task.priority),
                ),
                const SizedBox(width: 4),
                Text(
                  '${AppStrings.priority}: ${task.priority.displayName}',
                  style: TextStyle(
                    color: _getPriorityColor(task.priority),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildStatusIndicator(isOverdue, isDueToday),
      ),
    );
  }

  Widget? _buildStatusIndicator(bool isOverdue, bool isDueToday) {
    if (task.isCompleted) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 20,
      );
    }
    
    if (isOverdue) {
      return const Icon(
        Icons.warning,
        color: Colors.red,
        size: 20,
      );
    }
    
    if (isDueToday) {
      return const Icon(
        Icons.today,
        color: Colors.orange,
        size: 20,
      );
    }
    
    return null;
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xff2196F3);
      case TaskPriority.medium:
        return const Color(0xff4CC83C);
      case TaskPriority.high:
        return Colors.pink;
    }
  }
}