import 'package:flutter/material.dart';
import 'package:todo/models/todo_madel.dart';
import 'package:todo/views/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  final List<TodoModel> todos;

  const TodoList({
    Key? key,
    required this.todos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return TodoItem(
            todo: todos[index],
            index: index,
          );
        },
      ),
    );
  }
}
