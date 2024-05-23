import 'package:breeze/date_utils.dart';
import 'package:breeze/main.dart';
import 'package:breeze/task_data.dart';
import 'package:breeze/task_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    borderSide: BorderSide(width: 2.0),
  );

  void handleDatePicker() async {
    final newDate = await popDatePicker(context);
    if (newDate != null) {
      setState(() {
        dateTime = newDate;
      });
    }
  }

  void handleSubmitTask() {
    if (_formKey.currentState!.validate()) {
      final newTaskID = uuID.v4();
      final proj = ref.read(currentProject);
      ref.read(taskListProvider.notifier).addTask(
          Task(
            title: taskName,
            datetime: dateTime,
            status: status,
            project: proj,
          ),
          newTaskID);
      ref
          .read(projectListProvider.notifier)
          .addTaskToProject(newTaskID, proj);
      _taskNameController.clear();
    }
  }

  void rotateStatus(TaskStatus s) => setState(() {
        status = s;
      });

  void handleNameEdit(String value) => setState(() {
        taskName = value;
      });

  @override
  Widget build(BuildContext context) {
    final toolbar = ActionToolbar(
      handleDatePicker: handleDatePicker,
      handleSubmitTask: handleSubmitTask,
    );
    final editor = AttributeEditor(
      status: status,
      taskNameController: _taskNameController,
      defaultBorder: _defaultBorder,
      rotateStatus: rotateStatus,
      handleSubmitTask: handleSubmitTask,
      handleNameEdit: handleNameEdit,
    );
    return Form(
        key: _formKey,
        child: MediaQuery.of(context).size.width > 400
            ? Row(
                children: [
                  Expanded(flex: 5, child: editor),
                  const Padding(
                      padding:
                          EdgeInsets.only(right: PretConfig.minElementSpacing)),
                  Expanded(flex: 2, child: toolbar)
                ],
              )
            : Column(
                children: [editor, toolbar],
              ));
  }
}

class AttributeEditor extends StatelessWidget {
  const AttributeEditor({
    super.key,
    required this.status,
    required this.taskNameController,
    required this.defaultBorder,
    required this.rotateStatus,
    required this.handleSubmitTask,
    required this.handleNameEdit,
  });

  final TaskStatus status;
  final TextEditingController taskNameController;
  final OutlineInputBorder defaultBorder;

  final void Function(TaskStatus) rotateStatus;
  final VoidCallback handleSubmitTask;
  final void Function(String) handleNameEdit;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TaskStatusButton(
        status: status,
        statusRotateHandler: rotateStatus,
      ),
      const Padding(
        padding: EdgeInsets.only(right: PretConfig.minElementSpacing),
      ),
      Flexible(
        child: CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(
              LogicalKeyboardKey.enter,
              meta: true,
            ): handleSubmitTask
          },
          child: Container(
            constraints: const BoxConstraints(minWidth: 300),
            child: TextFormField(
              controller: taskNameController,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.all(PretConfig.thinElementSpacing + 1),
                  border: defaultBorder,
                  hintText: 'What\'s on your plate?',
                  enabledBorder: defaultBorder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Colors.pink[300]!,
                      width: 1.5,
                    ),
                  )),
              cursorColor: Colors.pink[300],
              onChanged: handleNameEdit,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a task name'
                  : null,
            ),
          ),
        ),
      ),
    ]);
  }
}

class ActionToolbar extends StatelessWidget {
  final VoidCallback handleDatePicker;
  final VoidCallback handleSubmitTask;

  const ActionToolbar({
    super.key,
    required this.handleDatePicker,
    required this.handleSubmitTask,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton.outlined(
              constraints: const BoxConstraints(
                  maxHeight: 32, minHeight: 32, minWidth: 48),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(
                  PretConfig.minElementSpacing,
                ),
                side: const BorderSide(color: Colors.black),
                shape: const BeveledRectangleBorder(
                    side: BorderSide(color: Colors.black)),
              ),
              onPressed: handleDatePicker,
              icon: const Icon(Icons.calendar_month_outlined)),
        ),
        const Padding(
          padding: EdgeInsets.only(right: PretConfig.minElementSpacing),
        ),
        Expanded(
          flex: 1,
          child: IconButton.outlined(
              constraints: const BoxConstraints(
                  maxHeight: 32, minHeight: 32, minWidth: 48),
              style: IconButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.all(0),
                shape: const BeveledRectangleBorder(),
              ),
              onPressed: handleSubmitTask,
              icon: const Icon(Icons.add)),
        )
      ],
    );
  }
}
