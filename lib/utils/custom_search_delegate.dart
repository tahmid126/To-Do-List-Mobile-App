// lib/custom_search_delegate.dart
import 'package:flutter/material.dart';
import 'package:tdl/models/models.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<dynamic> data;  // Can be either a list of Category or ListItem

  CustomSearchDelegate(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<dynamic> results = [];

    if (data.isEmpty) {
      return const Center(child: Text("No results"));
    }

    if (data.first is Category) {
      results = data.where((category) {
        return (category as Category).name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else if (data.first is ListItem) {
      results = data.where((list) {
        return (list as ListItem).title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Row(
            children: [
              Text(item is Category ? item.name : (item as ListItem).title),
            ],
          ),
          onTap: () {
            close(context, item);
          },

        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

/*
Purpose: Custom search UI for searching Category or ListItem objects.

Extends: SearchDelegate to customize the search experience.
 */