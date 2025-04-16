import 'package:flutter/material.dart';
import 'package:tdl/models/models.dart'; // Import the models file where Task is defined

class CategoryPage extends StatelessWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: category.lists.length,
        itemBuilder: (context, index) {
          final listItem = category.lists[index];
          return ListTile(
            title: Text(listItem.title),
            subtitle: listItem.dueDate != null
                ? Text('Due: ${listItem.dueDate}')
                : null,
          );
        },
      ),
    );
  }
}

/*
This screen:

Shows a list of tasks under a specific category.

Displays each task's title and due date (if available).

Is a reusable and clean stateless UI component.
 */