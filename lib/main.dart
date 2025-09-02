import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:todo/cubit/to_do_cubit.dart";
import "package:todo/views/screens/todo_screen.dart";

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit(),
      child: MaterialApp(
        home: TodoScreen(),
      ),
    );
  }
}
