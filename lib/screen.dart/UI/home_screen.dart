import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbunny/Bloc/task_bloc.dart';
import 'package:taskbunny/Bloc/task_event.dart';
import 'package:taskbunny/Bloc/task_state.dart';
import 'package:taskbunny/core/constant/app_constant.dart';
import 'package:taskbunny/screen.dart/model/task.dart' as model;
import 'package:taskbunny/screen.dart/model/task.dart';
import 'package:taskbunny/screen.dart/theme/color.dart';
import 'package:taskbunny/widget/task_item.dart';
import 'package:taskbunny/widget/task_summary_card.dart';

import 'add_TaskScreen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppConstants.assetRabbitIcon,
          width: 40,
          height: 40,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _navigateToAddTask(context),
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.deepPurple),
                ),
                showCloseIcon: true,
                closeIconColor: Colors.deepPurple,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(const LoadTasks());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final tasks = _getTasksFromState(state);
          final taskState = state is TaskLoaded ? state as TaskLoaded : null;
          return Column(
            children: [
              _buildHeader(),
              _buildTaskSummary(taskState ?? const TaskLoaded([])),
              Expanded(
                child: _buildTaskList(tasks),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                AppStrings.helloBoss,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Text(
                AppStrings.youHaveWorkToday,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSummary(TaskLoaded taskState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TaskSummaryCard(
                label: AppStrings.allTasks,
                count: taskState.incompleteTasks.length,
                color: AppTheme.priorityAll,
              ),
              TaskSummaryCard(
                label: AppStrings.lowPriority,
                count: taskState.getTaskCountByPriority(TaskPriority.low),
                color: AppTheme.priorityLow,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TaskSummaryCard(
                label: AppStrings.mediumPriority,
                count: taskState.getTaskCountByPriority(TaskPriority.medium),
                color: AppTheme.priorityMedium,
              ),
              TaskSummaryCard(
                label: AppStrings.highPriority,
                count: taskState.getTaskCountByPriority(TaskPriority.high),
                color: AppTheme.priorityHigh,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<model.Task> tasks) {
    final incompleteTasks = tasks.where((task) => !task.isCompleted).toList();
    
    if (incompleteTasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add a new task',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      itemCount: incompleteTasks.length,
      itemBuilder: (context, index) {
        final task = incompleteTasks[index];
        return TaskItem(
          task: task,
          onToggleCompletion: () {
            context.read<TaskBloc>().add(ToggleTaskCompletion(task.id));
          },
        );
      },
    );
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TaskBloc>(),
          child: AddTaskScreen(),
        ),
      ),
    );
  }

  List<model.Task> _getTasksFromState(TaskState state) {
    if (state is TaskLoaded) {
      return state.tasks;
    } else if (state is TaskOperationSuccess) {
      return state.tasks;
    }
    return [];
  }
}