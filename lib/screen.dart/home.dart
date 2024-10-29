import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class Task {
  String title;
  String dueDate;
  String dueTime;
  String priority;
  bool completed;

  Task({
    required this.title,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
    this.completed = false,
  });

  // Convert a Task to a Map for storage
  Map<String, dynamic> toJson() => {
        'title': title,
        'dueDate': dueDate,
        'dueTime': dueTime,
        'priority': priority,
        'completed': completed,
      };

  // Create a Task from a Map
  static Task fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        dueDate: json['dueDate'],
        dueTime: json['dueTime'],
        priority: json['priority'],
        completed: json['completed'],
      );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();  // Load tasks when the app starts
  }

  // Function to save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  // Function to load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      setState(() {
        tasks = taskList.map((task) => Task.fromJson(jsonDecode(task))).toList();
      });
    }
  }

  // Function to add a new task
  void _addTask(String title, String dueDate, String dueTime, String priority) {
    setState(() {
      tasks.add(Task(title: title, dueDate: dueDate, dueTime: dueTime, priority: priority));
      _saveTasks();  // Save tasks after adding a new task
    });
  }

  // Function to mark task as completed and remove from list
  void _toggleTaskCompleted(int index, bool? value) {
    setState(() {
      tasks[index].completed = value!;
      if (tasks[index].completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 350.0,
            
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: Colors.deepPurple,
            backgroundColor: Colors.deepPurple[100],
            elevation: 3,
            shape: RoundedRectangleBorder(
              
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              side: BorderSide(
                color: Colors.deepPurple,
              
                

              
            )),
            content: Text('Task ${tasks[index].title} completed!', style: TextStyle(color: Colors.deepPurple),),
            duration: Duration(seconds: 3),
          ),
        );
        tasks.removeAt(index);
        _saveTasks();  // Save tasks after removing a completed task
      }
    });
  }

  // Function to navigate to Add Task Screen
  void _navigateToAddTask(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddTaskScreen(addTask: _addTask);
    }));
  }

  // Function to calculate the number of tasks by priority
  int _countTasksByPriority(String priority) {
    return tasks.where((task) => task.priority == priority).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff0D0C0C),
      appBar: AppBar(
        backgroundColor: Color(0xff343434),
        title: Image.asset('assets/rabbit.png', width: 40, height: 40, color: Colors.white, ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white,),
            onPressed: () {
              _navigateToAddTask(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          
        ),
        child: Column(
          
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 16.0,),
                Text('Hello, Boss', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
              ],
            ),
        Row(
          children: [
      SizedBox(width: 16.0,),
      Text('You have work today', style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold ,color: Colors.white),),
          ],
        ),
       
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTaskSummaryBox('All Tasks', tasks.length,Colors.orange ),
                      _buildTaskSummaryBox('Low Priority', _countTasksByPriority('Low'), Color(0xff2196F3)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTaskSummaryBox('Medium Priority', _countTasksByPriority('Medium'),Color(0xff4CC83C)),
                      _buildTaskSummaryBox('High Priority', _countTasksByPriority('High'), Colors.pink),
                    ],
                  ),
                  
                ],
              ),
            ),
           Expanded(
  child: Expanded(
    child: ListView.builder(
      padding: EdgeInsets.all(26.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onCheckboxChanged: (bool? value) {
            _toggleTaskCompleted(index, value);
          },
        );
      },
    ),
  ),
),
          ],
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTask(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to build task summary box
  Widget _buildTaskSummaryBox(String label, int count, Color color) {
    return Container(
      height: 100,
      width: 160,
      
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
      
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(bool?) onCheckboxChanged;

  TaskItem({
    required this.task,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.deepPurple,
      child: ListTile(
        leading: Checkbox(
 
          side: BorderSide(color: Colors.white, width: 3),
          value: task.completed,
          onChanged: onCheckboxChanged,
        ),
        title: Row(
          children: [
                       
            SizedBox(width: 5,),     Text(
              task.title,
              
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),

          ],
        ),
        subtitle: Text('Due: ${task.dueDate} at ${task.dueTime}  Priority: ${task.priority}', style: TextStyle(color: Colors.white, fontSize: 14),),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  final Function(String, String, String, String) addTask;

  AddTaskScreen({required this.addTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TimeOfDay _dueTime = TimeOfDay.now();
  String _priority = 'Low';

  // Function to show Cupertino Date Picker for iOS-style date selection
  void _selectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        
        height: 250,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _dueDate,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _dueDate = newDateTime;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  // Function to show Cupertino Time Picker for iOS-style time selection
  void _selectTime(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(0, 0, 0, _dueTime.hour, _dueTime.minute),
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    _dueTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
                  });
                },
              ),
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Add Task', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Color(0xff343434),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          color:  Color(0xff0D0C0C),),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
  TextField(
    style: TextStyle(color: Colors.white),
  controller: _titleController,
  cursorColor: Colors.white,
  decoration: InputDecoration(
    hintText: 'Task Title',
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
    filled: true,
    fillColor: Colors.white.withOpacity(0.1),
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
  ),
),


              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Text('Due Date: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}', style: TextStyle(color: Colors.white),),
                  ),
                  CupertinoButton(
                    child: Icon(Icons.date_range_rounded, color: Colors.white,),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Due Time: ${_dueTime.format(context)}',style: TextStyle(color: Colors.white),),
                  ),
                  CupertinoButton(
                    child: Icon(Icons.access_time_rounded, color: Colors.white,), 
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                ],
              ),
              DropdownButton<String>(
                iconDisabledColor: Colors.white,
                focusColor: Colors.white,
                iconEnabledColor: Colors.white,
                dropdownColor: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
                value: _priority,
                items: <String>['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white),),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  widget.addTask(
                    _titleController.text,
                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                    _dueTime.format(context),
                    _priority,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Add Task', style: TextStyle(color: Colors.deepPurple),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';

// class _HomeScreenState extends State<HomeScreen> {
//   List<Task> tasks = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');

//   @override
//   void initState() {
//     super.initState();
//     _loadTasks();
//   }

//   Future<void> _loadTasks() async {
//     QuerySnapshot querySnapshot = await _tasksCollection.get();
//     setState(() {
//       tasks = querySnapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
//     });
//   }

//   Future<void> _addTask(String title, String dueDate, String dueTime, String priority) async {
//     Task task = Task(title: title, dueDate: dueDate, dueTime: dueTime, priority: priority);
//     await _tasksCollection.add(task.toJson());
//     _loadTasks();
//   }

//   Future<void> _updateTask(Task task) async {
//     await _tasksCollection.doc(task.id).update(task.toJson());
//     _loadTasks();
//   }

//   Future<void> _deleteTask(Task task) async {
//     await _tasksCollection.doc(task.id).delete();
//     _loadTasks();
//   }
// }


// class Task {
//   String id;
//   String title;
//   String dueDate;
//   String dueTime;
//   String priority;

//   Task({this.id, this.title, this.dueDate, this.dueTime, this.priority});

//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['id'],
//       title: json['title'],
//       dueDate: json['dueDate'],
//       dueTime: json['dueTime'],
//       priority: json['priority'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'dueDate': dueDate,
//       'dueTime': dueTime,
//       'priority': priority,
//     };
//   }
// }