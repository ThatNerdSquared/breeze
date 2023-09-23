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
  final _taskNameController = TextEditingController();
  String taskName = '';
  TaskStatus status = TaskStatus.todo;
  DateTime dateTime = DateTime.now();

  final _defaultBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(width: 1.5),
  );

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const Padding(
                  padding: EdgeInsets.only(right: PretConfig.minElementSpacing),
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(
                            PretConfig.thinElementSpacing + 1),
                        border: _defaultBorder,
                        hintText: 'What\'s on your plate?',
                        enabledBorder: _defaultBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: Colors.pink[300]!,
                            width: 1.5,
                          ),
                        )),
                    cursorColor: Colors.pink[300],
                    onChanged: (value) => setState(() {
                      taskName = value;
                    }),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a task name'
                        : null,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: PretConfig.minElementSpacing),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton.outlined(
                        constraints:
                            const BoxConstraints(maxHeight: 32, minHeight: 32),
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(
                            PretConfig.minElementSpacing,
                          ),
                          side: const BorderSide(color: Colors.black),
                          shape: const BeveledRectangleBorder(
                              side: BorderSide(color: Colors.black)),
                        ),
                        onPressed: handleDatePicker,
                        icon: const Icon(Icons.calendar_month_outlined))),
                const Padding(
                  padding: EdgeInsets.only(right: PretConfig.minElementSpacing),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton.outlined(
                      constraints:
                          const BoxConstraints(maxHeight: 32, minHeight: 32),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.all(0),
                        shape: const BeveledRectangleBorder(),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(taskListProvider.notifier).addTask(Task(
                              title: taskName,
                              datetime: dateTime,
                              status: status));
                          _taskNameController.clear();
                        }
                      },
                      icon: const Icon(Icons.add)),
                ),
              ],
            )));
  }
}
