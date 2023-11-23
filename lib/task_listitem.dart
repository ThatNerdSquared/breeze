import 'package:breeze/date_utils.dart';
import 'package:breeze/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'task_data.dart';

class TaskListItem extends ConsumerWidget {
  final String id;
  final Task task;
  final bool isPrevious;

  const TaskListItem({
    super.key,
    required this.id,
    required this.task,
    required this.isPrevious,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: [
          TaskStatusButton(
              status: task.status,
              statusRotateHandler: (status) => ref
                  .read(taskListProvider.notifier)
                  .updateTaskStatus(id, status)),
          const Padding(
            padding: EdgeInsets.only(right: PretConfig.defaultElementSpacing),
          ),
          Expanded(
            child: SelectableLinkify(
              text: isPrevious
                  ? '${task.title} (${humanizeDate(dt: task.datetime)})'
                  : task.title,
              style: TextStyle(
                color: task.status == TaskStatus.done ? Colors.grey : null,
                fontStyle:
                    task.status == TaskStatus.done ? FontStyle.italic : null,
              ),
              onOpen: (link) async {
                final url = [')', ']'].contains(link.url[link.url.length - 1])
                    ? link.url.substring(0, link.url.length - 1)
                    : link.url;
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch ${link.url}');
                }
              },
            ),
          ),
          TaskItemButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final newDate = await popDatePicker(context);
              newDate != null
                  ? ref
                      .read(taskListProvider.notifier)
                      .updateTaskDate(id, newDate)
                  : null;
            },
          ),
          TaskItemButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(taskListProvider.notifier).deleteTask(id),
          ),
        ],
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

  Color colorFromStatus(TaskStatus status) => switch (status) {
        TaskStatus.todo => Colors.black,
        TaskStatus.wip => Colors.pink[300]!,
        TaskStatus.done => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: OutlinedButton(
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(
              EdgeInsets.all(PretConfig.minElementSpacing),
            ),
            overlayColor: const MaterialStatePropertyAll(Colors.white54),
            side: MaterialStatePropertyAll(BorderSide(
              color: colorFromStatus(status),
              width: 1.0,
            )),
            shape: MaterialStatePropertyAll(statusButtonBorder(status))),
        onPressed: () => statusRotateHandler(rotateStatus(status)),
        child: Text(
          statusToString(status),
          style: TextStyle(
            color: colorFromStatus(status),
            fontStyle: status == TaskStatus.done ? FontStyle.italic : null,
          ),
        ),
      ),
    );
  }
}

class TaskItemButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const TaskItemButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent),
            shape: MaterialStatePropertyAll(LinearBorder(
              side: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            )),
            splashFactory: NoSplash.splashFactory),
        onPressed: onPressed,
        icon: icon,
      );
}
