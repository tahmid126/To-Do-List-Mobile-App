import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tdl/models/models.dart';
import 'package:tdl/utils/custom_search_delegate.dart';
import 'package:tdl/utils/todo_tile.dart';

class CategoryTasksPage extends StatefulWidget {
  final Category category;
  final VoidCallback onAddList;

  const CategoryTasksPage({
    super.key,
    required this.category,
    required this.onAddList,
  });

  @override
  _CategoryTasksPageState createState() => _CategoryTasksPageState();
}

class _CategoryTasksPageState extends State<CategoryTasksPage> {
  bool _isSortedByDate = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Store completed tasks
  List<ListItem> completedLists = [];

  List<ListItem> get filteredLists {
    return widget.category.lists.where((list) {
      return list.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }


  void _toggleSort() {
    setState(() {
      if (_isSortedByDate) {
        // If already sorted, shuffle to reset
        widget.category.lists.shuffle();
      } else {
        List<ListItem> dueHave = [];
        List<ListItem> noDue = [];

        for (var item in widget.category.lists) {
          if (item.dueDate != null) {
            dueHave.add(item);
          } else {
            noDue.add(item);
          }
        }

        // Sort the dueHave list by soonest date/time
        dueHave.sort((a, b) {
          final aDate = a.dueDate!;
          final bDate = b.dueDate!;

          if (aDate.compareTo(bDate) != 0) {
            return aDate.compareTo(bDate);
          }

          // If date and time are exactly the same or both have only dates, this will return 0
          return 0;
        });

        // Merge the two lists: dueHave first, then noDue
        widget.category.lists
          ..clear()
          ..addAll(dueHave)
          ..addAll(noDue);
      }

      _isSortedByDate = !_isSortedByDate;
    });
  }


  // Add new task
  void _addList() {
    String listName = '';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    TextEditingController listController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create New List"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: listController,
                decoration: const InputDecoration(hintText: "List name"),
                onChanged: (value) {
                  listName = value;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  Text(selectedDate != null
                      ? DateFormat.yMMMd().format(selectedDate!)
                      : 'Select Date'),
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
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 10),
                  Text(selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Select Time'),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (listName.isNotEmpty){    // && selectedDate != null && selectedTime != null) {
                  setState(() {
                    widget.category.lists.add(ListItem(
                      title: listName,
                      dueDate: selectedDate,
                      dueTime: selectedTime,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Edit task
  void _editList(int listIndex) {
    TextEditingController listController = TextEditingController(text: widget.category.lists[listIndex].title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit List"),
          content: TextField(
            controller: listController,
            decoration: const InputDecoration(hintText: "List name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.category.lists[listIndex].title = listController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Delete task
  void _deleteList(int listIndex) {
    setState(() {
      widget.category.lists.removeAt(listIndex);
    });
  }

  // Mark task as completed
  void _toggleComplete(int listIndex) {
    setState(() {
      widget.category.lists[listIndex].isDone = !widget.category.lists[listIndex].isDone;
      if (widget.category.lists[listIndex].isDone) {
        completedLists.add(widget.category.lists[listIndex]);
        widget.category.lists.removeAt(listIndex);
      }
    });
  }

  // Undo task completion
  void _undoComplete(int listIndex) {
    setState(() {
      widget.category.lists.add(completedLists[listIndex]);
      completedLists.removeAt(listIndex);
    });
  }

  // Delete completed task
  void _deleteCompleted(int listIndex) {
    setState(() {
      completedLists.removeAt(listIndex);
    });
  }

  // Update search query
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(filteredLists),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleSort,
          ),
        ],
      ),
      body: widget.category.lists.isEmpty && completedLists.isEmpty
          ? const Center(
        child: Text(
          "No List yet. Add One!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )

      : Column(
        children: [
          if (completedLists.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Completed Work ${completedLists.length}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: completedLists.length,
              itemBuilder: (context, index) {
                final list = completedLists[index];
                return ListTile(
                  title: Text(list.title),
                  leading: Checkbox(
                    value: list.isDone,
                    onChanged: (bool? value) {
                      _undoComplete(index);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCompleted(index),
                  ),
                );
              },
            ),
          ],
          if (widget.category.lists.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pending Task ${widget.category.lists.length}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredLists.length,
              itemBuilder: (context, index) {
                final list = filteredLists[index];
                return ListTile(
                  title: Text(list.title),
                  subtitle: list.dueDate != null || list.dueTime != null
                      ? Text(
                      'Due: ${list.dueDate != null ? DateFormat.yMMMd().format(list.dueDate!) : ''} ${list.dueTime != null ? 'at ${list.dueTime!.format(context)}' : ''}')
                      : null,
                  leading: Checkbox(
                    value: list.isDone,
                    onChanged: (bool? value) {
                      _toggleComplete(index);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editList(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteList(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addList,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/*
Task Management:

Add, edit, delete tasks.

Mark tasks as completed or undo completion.

Sorting:

Toggle sorting by due date or shuffle tasks.

Search & Filter:

Search tasks by name.

Filter tasks by sorting.

Completed Tasks:

Display completed tasks separately.

Option to delete or undo completion.

UI Features:

Floating action button to add tasks.

App bar with search and filter icons.

Separate sections for pending and completed tasks.

State Management:

Uses StatefulWidget to update UI dynamically.
 */