import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/models/todo_madel.dart';
import 'package:todo/views/widgets/custom_app_bar.dart';
import 'package:todo/views/widgets/search_bar_widget.dart';
import 'package:todo/views/widgets/empty_state_widget.dart';
import 'package:todo/views/widgets/search_results_list_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<TodoModel> filteredTodos = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize with all todos
    filteredTodos = context.read<ToDoCubit>().toDoList;
  }

  void _performSearch(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredTodos = context.read<ToDoCubit>().toDoList;
      } else {
        filteredTodos = context
            .read<ToDoCubit>()
            .toDoList
            .where(
              (todo) => todo.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      isSearching = false;
      filteredTodos = context.read<ToDoCubit>().toDoList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Search Todos'),
      body: BlocListener<ToDoCubit, ToDoState>(
        listener: (context, state) {
          // Update filtered list when todos change
          if (isSearching) {
            _performSearch(searchController.text);
          } else {
            setState(() {
              filteredTodos = context.read<ToDoCubit>().toDoList;
            });
          }
        },
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: searchController,
              onChanged: _performSearch,
              onClear: _clearSearch,
              showClearButton: isSearching,
              hintText: 'Search todos...',
            ),

            // Search Results or Empty State
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!isSearching && filteredTodos.isEmpty) {
      // No todos available
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No todos available',
        subtitle: 'Add some todos to start searching',
      );
    }

    if (isSearching && filteredTodos.isEmpty) {
      // No search results
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No results found',
        subtitle: 'Try searching with different keywords',
      );
    }

    // Show search results
    return SearchResultsListWidget(
      todos: filteredTodos,
      showCounter: isSearching,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
