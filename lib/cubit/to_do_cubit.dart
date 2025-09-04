import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo_madel.dart';
import 'dart:math';

part 'to_do_state.dart';

class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit() : super(ToDoInitial());
  List<TodoModel> toDoList = [];
  List<TodoModel> completedList = [];
 late String username ;
  void addToDo(String todoText) async {
    final random = Random().nextInt(100000);
    String trimmedText = todoText.trim();
    if (trimmedText.isEmpty) {
      return emit(ToDoFailure(error: "Todo text cannot be empty"));
    }

    final data = TodoModel(id: random, name: trimmedText);
    toDoList.add(data);

    await _saveToStorage();
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
    print(state.toString());
  }

  void toggleTodoCompletion(TodoModel todo) async {
    final index = toDoList.indexWhere((element) => element.id == todo.id);
    if (index != -1) {
      toDoList[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
      await _saveToStorage();
      emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
    }
  }

  void removeToDo(TodoModel todo) async {
    toDoList.removeWhere((element) => element.id == todo.id);
    await _saveToStorage();
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  void completeToDo(TodoModel todo) async {
    toDoList.removeWhere((element) => element.id == todo.id);
    final completedTodo = todo.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    completedList.add(completedTodo);
    await _saveToStorage();
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  void loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStringList = prefs.getStringList(username) ?? [];
    final completedStringList = prefs.getStringList("$username completed_todos") ?? [];

    toDoList = todoStringList.map((element) {
      final json = jsonDecode(element);
      return TodoModel(
        id: json['id'],
        name: json['name'],
        isCompleted: json['isCompleted'] ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      );
    }).toList();

    completedList = completedStringList.map((element) {
      final json = jsonDecode(element);
      return TodoModel(
        id: json['id'],
        name: json['name'],
        isCompleted: json['isCompleted'] ?? true,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      );
    }).toList();

    if (toDoList.isEmpty && completedList.isEmpty) {
      emit(ToDoInitial());
    } else {
      emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
    }
  }

  void removeCompletedToDo(TodoModel todo) async {
    completedList.removeWhere((element) => element.id == todo.id);
    await _saveToStorage();
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  void moveBackToToDo(TodoModel completedTodo) async {
    completedList.removeWhere((element) => element.id == completedTodo.id);
    final todo = completedTodo.copyWith(isCompleted: false, completedAt: null);
    toDoList.add(todo);
    await _saveToStorage();
    emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
  }

  Future<void> _saveToStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final todoStringList = toDoList.map((element) {
      return jsonEncode({
        'id': element.id,
        'name': element.name,
        'isCompleted': element.isCompleted,
    });
      });

    final completedStringList = completedList.map((element) {
      return jsonEncode({
        'id': element.id,
        'name': element.name,
        'isCompleted': element.isCompleted,
        'completedAt': element.completedAt?.toIso8601String(),
      });
    }).toList();

    await prefs.setStringList(username, todoStringList.toList());
    await prefs.setStringList("$username completed_todos", completedStringList);
  }
}
