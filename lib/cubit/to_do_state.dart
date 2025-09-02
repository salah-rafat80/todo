part of 'to_do_cubit.dart';


abstract class ToDoState {}
final class ToDoInitial extends ToDoState {}
final class ToDoSuccess extends ToDoState {
  final List<TodoModel> ToDoList;
  ToDoSuccess({this.ToDoList = const []});
}

final class ToDoFailure extends ToDoState {
  final String error;
  ToDoFailure({required this.error});
}
