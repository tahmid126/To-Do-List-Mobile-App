import 'package:hive_flutter/hive_flutter.dart';

class ToDoItem {
  String taskTitle;
  bool isTaskCompleted;
  DateTime dueDate;

  ToDoItem({
    required this.taskTitle,
    required this.isTaskCompleted,
    required this.dueDate, // Ensure dueDate is part of the task
  });
}

class ToDoDataBase {
  List<ToDoItem> toDoList = [];
  // reference the hive box
  final _toDoBox = Hive.box('todoBox');

  // run this method if this class is called for the first time ever
  void createInitData() {
    // default data seeder (example task with date)
    toDoList = [];
  }

  // load the data from the db
  void loadData() {
    final storedList = _toDoBox.get("TODOLIST");
    if (storedList != null) {
      toDoList = List<ToDoItem>.from(storedList.map((item) {
        return ToDoItem(
          taskTitle: item[0],
          isTaskCompleted: item[1],
          dueDate: DateTime.parse(item[2]),  // Parse stored date
        );
      }));
    }
  }

  // update database
  void updateData() {
    _toDoBox.put("TODOLIST", toDoList.map((item) {
      return [item.taskTitle, item.isTaskCompleted, item.dueDate.toIso8601String()];
    }).toList());
  }
}

/*
This code:

Creates a basic to-do list structure.

Loads and saves tasks from/to Hive using a list structure.

Handles tasks with title, status, and due date.

Uses DateTime.parse and .toIso8601String() to work with dates.
 */