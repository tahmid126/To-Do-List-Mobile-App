import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class DialogBox extends StatelessWidget {
  final TextEditingController textController;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime?) onDatePicked;
  final Function(TimeOfDay?) onTimePicked;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const DialogBox({
    super.key,
    required this.textController,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDatePicked,
    required this.onTimePicked,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Task/ List"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Task Name Input
          TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter name"),
          ),
          const SizedBox(height: 10),

          // Date Picker
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 10),
              Text(
                selectedDate != null
                    ? DateFormat.yMMMd().format(selectedDate!)
                    : 'No Date Selected', // Updated placeholder text
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    onDatePicked(pickedDate);
                  }
                },
              ),
              if (selectedDate != null) // Clear Date button
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Clear Date',
                  onPressed: () {
                    onDatePicked(null); // Clears the selected date
                  },
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Time Picker
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 10),
              Text(
                selectedTime != null
                    ? selectedTime!.format(context)
                    : 'No Time Selected', // Updated placeholder text
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    onTimePicked(pickedTime);
                  }
                },
              ),
              if (selectedTime != null) // Clear Time button
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Clear Time',
                  onPressed: () {
                    onTimePicked(null); // Clears the selected time
                  },
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text("Save"),
        ),
      ],
    );
  }
}

/*
A custom modal dialog box for creating a task or list, with text, date, and time input.
 */