import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/models/todo_madel.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;

  const TodoItemWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: todo.isCompleted,
            onChanged: (bool? value) {
              context.read<ToDoCubit>().toggleTodoCompletion(todo);
            },
            activeColor: const Color(0xFF4A90E2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Todo title
          Expanded(
            child: Text(
              todo.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),

          // Delete icon
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade300,
              size: 22,
            ),
            onPressed: () {
              context.read<ToDoCubit>().removeToDo(todo);
            },
          ),
        ],
      ),
    );
  }
}
