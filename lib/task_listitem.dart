import 'package:breeze/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import 'task_data.dart';

class TaskListItem extends ConsumerWidget {
  final String id;
  final Task task;

  const TaskListItem({
    super.key,
    required this.id,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        padding: const EdgeInsets.all(PretConfig.thinElementSpacing),
        margin: const EdgeInsets.only(bottom: PretConfig.minElementSpacing),
        child: Row(
          children: [
            TaskStatusButton(
                status: task.status,
                statusRotateHandler: (status) => ref
                    .read(taskListProvider.notifier)
                    .updateTaskStatus(id, status)),
            const Padding(
                padding:
                    EdgeInsets.only(right: PretConfig.defaultElementSpacing)),
            Text(task.title),
          ],
        ),
      );
}

class TaskStatusButton extends StatelessWidget {
  final TaskStatus status;
  final Function(TaskStatus) statusRotateHandler;

  const TaskStatusButton({
    super.key,
    required this.status,
    required this.statusRotateHandler,
  });

  TaskStatus rotateStatus(TaskStatus currentStatus) => switch (currentStatus) {
        TaskStatus.todo => TaskStatus.wip,
        TaskStatus.wip => TaskStatus.done,
        TaskStatus.done => TaskStatus.todo,
      };

  BeveledRectangleBorder statusButtonBorder(TaskStatus currentStatus) =>
      switch (currentStatus) {
        TaskStatus.todo => const BeveledRectangleBorder(),
        TaskStatus.wip => const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: PretConfig.thinBorderRounding,
              bottomLeft: PretConfig.thinBorderRounding,
            ),
          ),
        TaskStatus.done => const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(PretConfig.thinBorderRounding),
          ),
      };

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(statusButtonBorder(status))),
      onPressed: () => statusRotateHandler(rotateStatus(status)),
      child: Text(switch (status) {
        TaskStatus.todo => "todo",
        TaskStatus.wip => "wip",
        TaskStatus.done => "done",
      }),
    );
  }
}
