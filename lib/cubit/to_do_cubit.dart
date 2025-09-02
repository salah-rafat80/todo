import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo_madel.dart';
import 'dart:math';

part 'to_do_state.dart';

class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit() : super(ToDoInitial());
  List<TodoModel> toDoList = [];
  List<TodoModel> completedList = [];
  final Random _random = Random();

  String _generateRandomId() {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  void addToDo(String todoText) {
    String trimmedText = todoText.trim();
    if (trimmedText.isEmpty) {
      return emit(ToDoFailure(error: "Todo text cannot be empty"));
    }

    final todo = TodoModel(
      id: _generateRandomId(),
      name: trimmedText,
    );

    toDoList.add(todo);
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
    print(state.toString());
  }

  void removeToDo(TodoModel todo) {
    toDoList.removeWhere((element) => element.id == todo.id);
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  void completeToDo(TodoModel todo) {
    toDoList.removeWhere((element) => element.id == todo.id);
    final completedTodo = todo.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    completedList.add(completedTodo);
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  void removeCompletedToDo(TodoModel todo) {
    completedList.removeWhere((element) => element.id == todo.id);
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  void moveBackToToDo(TodoModel completedTodo) {
    completedList.removeWhere((element) => element.id == completedTodo.id);
    final todo = completedTodo.copyWith(
      isCompleted: false,
      completedAt: null,
    );
    toDoList.add(todo);
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }
}
