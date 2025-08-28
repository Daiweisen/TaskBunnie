import 'package:taskbunny/screen.dart/Repository/task_repository.dart';
import 'package:bloc/bloc.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskInitial()) {
    
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<ClearAllTasks>(_onClearAllTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    
    try {
      final tasks = await _taskRepository.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.saveTask(event.task);
      final tasks = await _taskRepository.getAllTasks();
      emit(TaskOperationSuccess('Task added successfully', tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.updateTask(event.task);
      final tasks = await _taskRepository.getAllTasks();
      emit(TaskOperationSuccess('Task updated successfully', tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.deleteTask(event.taskId);
      final tasks = await _taskRepository.getAllTasks();
      emit(TaskOperationSuccess('Task deleted successfully', tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(
      ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    try {
      final currentState = state;
      if (currentState is TaskLoaded) {
        final task = currentState.tasks.firstWhere((t) => t.id == event.taskId);
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        
        await _taskRepository.updateTask(updatedTask);
        final tasks = await _taskRepository.getAllTasks();
        
        final message = updatedTask.isCompleted
            ? 'Task ${updatedTask.title} completed!'
            : 'Task ${updatedTask.title} reopened!';
            
        emit(TaskOperationSuccess(message, tasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onClearAllTasks(
      ClearAllTasks event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.clearAllTasks();
      emit(const TaskLoaded([]));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}