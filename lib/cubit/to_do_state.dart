part of 'to_do_cubit.dart';


abstract class ToDoState {}
final class ToDoInitial extends ToDoState {}
final class ToDoSuccess extends ToDoState {
  final List<TodoModel> ToDoList;
  final List<TodoModel> completedList;

  ToDoSuccess({
    this.ToDoList = const [],
    this.completedList = const [],
  });
}

final class ToDoFailure extends ToDoState {
  final String error;
  ToDoFailure({required this.error});
}
