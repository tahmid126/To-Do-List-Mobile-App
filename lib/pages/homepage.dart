import 'package:flutter/material.dart';
import 'package:tdl/models/models.dart';
import 'package:tdl/pages/category_tasks_page.dart';
import 'package:tdl/utils/custom_search_delegate.dart'; // Custom search for categories

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _categoryController = TextEditingController();
  List<Category> categories = [];
  String _searchQuery = "";

  // Function to update the search query
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  // Filter categories based on the search query
  List<Category> get filteredCategories {
    return categories.where((category) {
      return category.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Function to add a new category
  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(hintText: "Category name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String name = _categoryController.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    categories.add(Category(name: name, lists: []));
                  });
                }
                _categoryController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                _categoryController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to edit a category
  void _editCategory(int index) {
    _categoryController.text = categories[index].name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Category"),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(hintText: "Category name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  categories[index].name = _categoryController.text.trim();
                });
                _categoryController.clear();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                _categoryController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a category
  void _deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Categories ${categories.length}'),
        actions: [
          // Search functionality for categories
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(filteredCategories),
              );
            },
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(child: Text("No categories yet. Add one!"))
          : ListView.builder(
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editCategory(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCategory(index),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryTasksPage(
                    category: category,
                    onAddList: () {},
                  ),
                ),
              ).then((_) => setState(() {})); // Refresh on return
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/*
Category Management: Allows adding, editing, and deleting categories.

Search Functionality: Search bar filters categories based on the query.

Category List: Displays a list of categories with options to edit, delete, or view tasks in a category.

Navigation: Tapping on a category leads to the CategoryTasksPage to manage tasks.

Floating Action Button: Button to add new categories.
 */