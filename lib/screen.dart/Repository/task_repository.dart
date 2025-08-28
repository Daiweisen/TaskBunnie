import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskbunny/screen.dart/home.dart';
import 'package:taskbunny/screen.dart/model/task.dart';


abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<void> saveTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> clearAllTasks();
}

class LocalTaskRepository implements TaskRepository {
  static const String _tasksKey = 'tasks';
  
  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_tasksKey) ?? [];
      
      return tasksJson
          .map((taskString) => Task.fromJson(json.decode(taskString) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw TaskRepositoryException('Failed to load tasks: ${e.toString()}');
    }
  }

  @override
  Future<void> saveTask(Task task) async {
    try {
      final tasks = await getAllTasks();
      tasks.add(task);
      await _saveTasks(tasks);
    } catch (e) {
      throw TaskRepositoryException('Failed to save task: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final tasks = await getAllTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);
      
      if (index != -1) {
        tasks[index] = task;
        await _saveTasks(tasks);
      } else {
        throw TaskRepositoryException('Task not found');
      }
    } catch (e) {
      throw TaskRepositoryException('Failed to update task: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final tasks = await getAllTasks();
      tasks.removeWhere((task) => task.id == taskId);
      await _saveTasks(tasks);
    } catch (e) {
      throw TaskRepositoryException('Failed to delete task: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAllTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tasksKey);
    } catch (e) {
      throw TaskRepositoryException('Failed to clear tasks: ${e.toString()}');
    }
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks
        .map((task) => json.encode(task.toJson()))
        .toList();
    
    await prefs.setStringList(_tasksKey, tasksJson);
  }
}

class TaskRepositoryException implements Exception {
  final String message;
  
  const TaskRepositoryException(this.message);
  
  @override
  String toString() => 'TaskRepositoryException: $message';
}