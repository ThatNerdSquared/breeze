import 'package:breeze/main.dart';
import 'package:breeze/task_data.dart';
import 'package:breeze/task_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class NewTaskForm extends ConsumerStatefulWidget {
  const NewTaskForm({super.key});

  @override
  NewTaskFormState createState() => NewTaskFormState();
}

class NewTaskFormState extends ConsumerState<NewTaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String taskName = '';
  TaskStatus status = TaskStatus.todo;
  DateTime dateTime = DateTime.now();

  void handleDatePicker() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (newDate != null) {
      setState(() {
        dateTime = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            padding: const EdgeInsets.only(
              top: PretConfig.thinElementSpacing,
              bottom: PretConfig.thinElementSpacing,
              left: PretConfig.defaultElementSpacing,
              right: PretConfig.defaultElementSpacing,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TaskStatusButton(
                    status: status,
                    statusRotateHandler: (s) => setState(() {
                      status = s;
                    }),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.all(PretConfig.thinElementSpacing),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                      hintText: 'What\'s on your plate?',
                    ),
                    onChanged: (value) => setState(() {
                      taskName = value;
                    }),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a task name'
                        : null,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton.outlined(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(
                              PretConfig.minElementSpacing),
                          shape: const BeveledRectangleBorder(),
                        ),
                        onPressed: handleDatePicker,
                        icon: const Icon(Icons.calendar_month_outlined))),
                Expanded(
                  flex: 1,
                  child: IconButton.outlined(
                      style: IconButton.styleFrom(
                          shape: const BeveledRectangleBorder()),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(taskListProvider.notifier).addTask(Task(
                              title: taskName,
                              datetime: dateTime,
                              status: status));
                        }
                      },
                      icon: const Icon(Icons.add)),
                ),
              ],
            )));
  }
}
