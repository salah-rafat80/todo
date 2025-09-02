import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/views/widgets/todo_app_bar.dart';
import 'package:todo/views/widgets/todo_input_section.dart';
import 'package:todo/views/widgets/todo_stats_section.dart';
import 'package:todo/views/widgets/todo_empty_state.dart';
import 'package:todo/views/widgets/todo_list.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    context.read<ToDoCubit>().addToDo(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      buildWhen: (previous, current) {
        return current is! ToDoFailure;
      },
      listener: (context, state) {
        if (state is ToDoFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bool hasData = state is ToDoSuccess && state.ToDoList.isNotEmpty;
        final bool isEmpty =
            state is ToDoInitial ||
            (state is ToDoSuccess && state.ToDoList.isEmpty);

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: TodoAppBar(),
          body: Column(
            children: [
              TodoInputSection(controller: _controller, onAddTodo: _addTodo),
              if (hasData) TodoStatsSection(taskCount: (state).ToDoList.length),
              if (hasData) SizedBox(height: 16),
              if (isEmpty)
                TodoEmptyWidget()
              else if (state is ToDoSuccess)
                TodoList(todos: state.ToDoList),
            ],
          ),
        );
      },
    );
  }
}
