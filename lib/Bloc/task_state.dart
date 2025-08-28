import 'package:equatable/equatable.dart';
import 'package:taskbunny/screen.dart/model/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];

  List<Task> get incompleteTasks => 
      tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks => 
      tasks.where((task) => task.isCompleted).toList();

  int get totalTaskCount => tasks.length;
  
  int getTaskCountByPriority(TaskPriority priority) =>
      incompleteTasks.where((task) => task.priority == priority).length;
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  final List<Task> tasks;

  const TaskOperationSuccess(this.message, this.tasks);

  @override
  List<Object?> get props => [message, tasks];
}