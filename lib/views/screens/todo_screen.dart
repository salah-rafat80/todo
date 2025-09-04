import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/views/screens/add_details_screen.dart';
import 'package:todo/views/screens/search_screen.dart';
import 'package:todo/views/widgets/todo_item_widget.dart';
import 'package:todo/views/widgets/custom_app_bar.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();

}
class _TodoListScreenState extends State<TodoListScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ToDoCubit>().loadTodos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'My Todos',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          )],
      ),
      body: BlocBuilder<ToDoCubit, ToDoState>(

        builder: (context, state) {
         var todos = context.read<ToDoCubit>().toDoList;
           if (todos.isNotEmpty) {
             return ListView.builder(
               padding: const EdgeInsets.symmetric(vertical: 8),
               itemCount: todos.length,
               itemBuilder: (context, index) {
                return TodoItemWidget(todo: todos[index]);
               },
             );
           }else{
              return const Center(
                child: Text(
                  'No todos available. Add a new todo!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
           };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDetailsScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}