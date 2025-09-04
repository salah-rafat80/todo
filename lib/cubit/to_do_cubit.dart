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
  late String username;

  void setUsername(String user) {
    username = user;
    loadTodos(); // Load todos for this user
  }

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
  void loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userDataString = prefs.getString(username);

      if (userDataString == null || userDataString.isEmpty) {
        // No data found for this user
        toDoList = [];
        completedList = [];
        emit(ToDoInitial());
        return;
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      if (userData.containsKey('todos')) {
        final List<dynamic> todosJson = userData['todos'];
        toDoList = todosJson.map((todoJson) {
          return TodoModel(
            id: todoJson['id'],
            name: todoJson['name'],
            isCompleted: todoJson['isCompleted'] ?? false,
            completedAt: todoJson['completedAt'] != null
                ? DateTime.parse(todoJson['completedAt'])
                : null,
          );
        }).toList();
      } else {
        toDoList = [];
      }

      if (userData.containsKey('completed')) {
        final List<dynamic> completedJson = userData['completed'];
        completedList = completedJson.map((todoJson) {
          return TodoModel(
            id: todoJson['id'],
            name: todoJson['name'],
            isCompleted: todoJson['isCompleted'] ?? true,
            completedAt: todoJson['completedAt'] != null
                ? DateTime.parse(todoJson['completedAt'])
                : null,
          );
        }).toList();
      } else {
        completedList = [];
      }

      if (toDoList.isEmpty && completedList.isEmpty) {
        emit(ToDoInitial());
      } else {
        emit(ToDoSuccess(ToDoList: toDoList, completedList: completedList));
      }
    } catch (e) {
      print('Error loading todos: $e');
      emit(ToDoFailure(error: 'Failed to load todos'));
    }
  }



  Future<void> _saveToStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> todosList = toDoList.map((element) {
        return {
          'id': element.id,
          'name': element.name,
          'isCompleted': element.isCompleted,
          'completedAt': element.completedAt?.toIso8601String(),
        };
      }).toList();


      final List<Map<String, dynamic>> completedTodosList = completedList.map((element) {
        return {
          'id': element.id,
          'name': element.name,
          'isCompleted': element.isCompleted,
          'completedAt': element.completedAt?.toIso8601String(),
        };
      }).toList();

      // Create the user data structure
      final Map<String, dynamic> userData = {
        'username': username,
        'todos': todosList,
        'completed': completedTodosList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // Encode and save the entire user data under the username key
      final String encodedUserData = jsonEncode(userData);
      await prefs.setString(username, encodedUserData);

      print('Saved ${toDoList.length} todos and ${completedList.length} completed tasks for user: $username');
    } catch (e) {
      print('Error saving todos: $e');
      emit(ToDoFailure(error: 'Failed to save todos'));
    }
  }
}