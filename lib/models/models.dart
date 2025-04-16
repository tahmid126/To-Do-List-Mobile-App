import 'package:flutter/material.dart';  // For TimeOfDay

class Task {
  String title;
  bool isDone;
  DateTime? dueDate;
  TimeOfDay? dueTime;  // Optional due time

  Task({
    required this.title,
    this.isDone = false,
    this.dueDate,
    this.dueTime,
  });
}

class ListItem {
  String title;
  bool isDone;
  DateTime? dueDate;
  TimeOfDay? dueTime;

  ListItem({
    required this.title,
    this.isDone = false,
    this.dueDate,
    this.dueTime,
  });
}

class Category {
  String name;
  List<ListItem> lists; // A category can contain multiple lists

  Category({required this.name, this.lists = const []});
}

/*
Task Class: Represents an individual task with a title, completion status, and optional due date and time.

ListItem Class: Similar to Task, used for tasks within categories, with a title, status, and optional due date and time.

Category Class: Represents a category containing multiple tasks (ListItem objects).
 */