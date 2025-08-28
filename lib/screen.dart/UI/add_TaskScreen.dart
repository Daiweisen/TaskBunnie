import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbunny/Bloc/task_bloc.dart';
import 'package:taskbunny/Bloc/task_event.dart';
import 'package:taskbunny/core/constant/app_constant.dart';
import 'package:taskbunny/core/utils/utils.dart';
import 'package:taskbunny/screen.dart/model/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  DateTime _dueDate = DateTime.now();
  TimeOfDay _dueTime = TimeOfDay.now();
  TaskPriority _priority = TaskPriority.low;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.addTask,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              _buildTaskTitleField(),
              const SizedBox(height: 24),
              _buildDateSelector(),
              const SizedBox(height: 16),
              _buildTimeSelector(),
              const SizedBox(height: 24),
              _buildPrioritySelector(),
              const Spacer(),
              _buildAddTaskButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: AppStrings.taskTitle,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.taskTitleEmpty;
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
      maxLength: 100,
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${AppStrings.dueDate}: ${AppDateUtils.formatDate(_dueDate)}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _selectDate(context),
            child: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${AppStrings.dueTime}: ${_dueTime.format(context)}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _selectTime(context),
            child: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.flag, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${AppStrings.priority}:',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          DropdownButton<TaskPriority>(
            value: _priority,
            dropdownColor: Colors.blueGrey,
            iconEnabledColor: Colors.white,
            underline: const SizedBox(),
            items: TaskPriority.values.map((TaskPriority priority) {
              return DropdownMenuItem<TaskPriority>(
                value: priority,
                child: Text(
                  priority.displayName,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (TaskPriority? newValue) {
              if (newValue != null) {
                setState(() {
                  _priority = newValue;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleAddTask,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                AppStrings.addTask,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _selectDate(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _dueDate,
                minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _dueDate = newDateTime;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  0, 0, 0, 
                  _dueTime.hour, 
                  _dueTime.minute
                ),
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    _dueTime = TimeOfDay(
                      hour: newTime.hour, 
                      minute: newTime.minute
                    );
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dueDateTime = AppDateUtils.combineDateAndTime(_dueDate, _dueTime);
    
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      dueDate: dueDateTime,
      priority: _priority,
    );

    context.read<TaskBloc>().add(AddTask(task));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}