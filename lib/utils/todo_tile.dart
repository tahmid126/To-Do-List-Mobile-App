import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  final String taskTitle;
  final bool isTaskCompleted;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteTask;
  final DateTime? dueDate;
  final TimeOfDay? dueTime; // Add dueTime parameter

  const ToDoTile({
    super.key,
    required this.taskTitle,
    required this.isTaskCompleted,
    required this.onChanged,
    required this.deleteTask,
    this.dueDate,
    this.dueTime, // Accept dueTime as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Checkbox(
            value: isTaskCompleted,
            onChanged: onChanged,
          ),
          title: Text(
            taskTitle,
            style: TextStyle(
              decoration: isTaskCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: _buildSubtitle(context), // Pass context here
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteTask(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    // Display both date and time in the subtitle
    String subtitleText = '';
    if (dueDate != null) {
      subtitleText = DateFormat.yMMMd().format(dueDate!); // Format the date
    }
    if (dueTime != null) {
      subtitleText += ' at ${dueTime!.format(context)}'; // Format the time
    }
    return subtitleText.isNotEmpty ? Text('Due: $subtitleText') : SizedBox.shrink();
  }
}

/*
Displays an individual task item with title, optional due date/time, checkbox for completion, and a delete option.
 */