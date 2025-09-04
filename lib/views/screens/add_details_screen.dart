import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/views/widgets/custom_text_field.dart';
import 'package:todo/views/widgets/custom_button.dart';
import 'package:todo/views/widgets/date_picker_widget.dart';
import 'package:todo/views/widgets/custom_app_bar.dart';

import '../../cubit/to_do_cubit.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final TextEditingController titleController = TextEditingController(
    text: 'Grocery Shopping',
  );
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  void _addTodo() {
    context.read<ToDoCubit>().addToDo(titleController.text);
    titleController.clear();
    descriptionController.clear();
    selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ToDoCubit, ToDoState>(
      listener: (context, state) {
       if(state is ToDoFailure){
        final snackBar = SnackBar(content: Text(state.error));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
       } else if(state is ToDoSuccess){
        Navigator.pop(context);
       }
       if(state is ToDoSuccess){
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Todo added successfully!')),
         );
       }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Add Details',
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Todo Title Section
              CustomTextField(
                controller: titleController,
                labelText: 'Todo Title',
                hintText: 'Enter todo title',
              ),
              const SizedBox(height: 24),

              // Description Section
              CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                hintText: 'Add a description...',
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Deadline Section
              DatePickerWidget(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),

              const Spacer(),

              // Save Button
              CustomButton(
                text: 'Save',
                onPressed: _addTodo,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}