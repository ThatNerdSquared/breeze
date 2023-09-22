import 'package:breeze/main.dart';
import 'package:breeze/task_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTaskForm extends ConsumerStatefulWidget {
  const NewTaskForm({super.key});

  @override
  NewTaskFormState createState() => NewTaskFormState();
}

class NewTaskFormState extends ConsumerState<NewTaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String taskName = '';
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                validator: (value) => value != null || value!.isEmpty
                    ? 'Please enter a task name'
                    : null,
              ),
            ),
            Expanded(
                flex: 5,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 5)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  onDateChanged: (value) => setState(() {
                    dateTime = dateTime;
                  }),
                )),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(taskListProvider.notifier)
                      .addTask(Task(title: taskName, datetime: dateTime));
                }
              },
              child: const Text('Submit'),
            )
          ],
        ));
  }
}
