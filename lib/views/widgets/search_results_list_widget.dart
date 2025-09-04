import 'package:flutter/material.dart';
import 'package:todo/models/todo_madel.dart';
import 'package:todo/views/widgets/todo_item_widget.dart';
import 'package:todo/views/widgets/search_results_counter_widget.dart';

class SearchResultsListWidget extends StatelessWidget {
  final List<TodoModel> todos;
  final bool showCounter;

  const SearchResultsListWidget({
    Key? key,
    required this.todos,
    this.showCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results counter
        SearchResultsCounterWidget(
          resultsCount: todos.length,
          isVisible: showCounter,
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TodoItemWidget(todo: todos[index]);
            },
          ),
        ),
      ],
    );
  }
}
