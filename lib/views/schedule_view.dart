import 'package:breeze/main.dart';
import 'package:breeze/task_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../date_utils.dart';
import '../list_section.dart';
import '../new_task_form.dart';
import '../task_listitem.dart';

class ScheduleView extends ConsumerWidget {
  const ScheduleView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(
        top: PretConfig.titleBarSafeArea,
        left: PretConfig.defaultElementSpacing,
        right: PretConfig.defaultElementSpacing,
        bottom: PretConfig.defaultElementSpacing,
      ),
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(children: [
        Expanded(
          flex: 8,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? ListSection(
                      header: Text.rich(
                        TextSpan(children: [
                          const TextSpan(text: 'Previous ('),
                          TextSpan(
                            text: ref.watch(showCompleted)
                                ? "hide completed"
                                : "show completed",
                            style: TextStyle(
                              color: Colors.pink[300],
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => ref
                                  .read(showCompleted.notifier)
                                  .update((state) => !state),
                          ),
                          const TextSpan(text: ")")
                        ]),
                      ),
                      children: ref
                          .watch(taskListProvider.select(
                            (tasklist) => tasklist.entries.where((taskEntry) =>
                                isDateBeforeToday(
                                  taskEntry.value.datetime,
                                ) &&
                                (!ref.watch(showCompleted)
                                    ? taskEntry.value.status != TaskStatus.done
                                    : true)),
                          ))
                          .map((mapEntry) => TaskListItem(
                                id: mapEntry.key,
                                task: mapEntry.value,
                                isPrevious: true,
                              ))
                          .toList(),
                    )
                  : ListSection(
                      header: Text(humanizeDate(offset: index - 1)),
                      children: ref
                          .watch(taskListProvider.select(
                            (tasklist) => tasklist.entries.where(
                              (taskEntry) => isSameDate(
                                  taskEntry.value.datetime,
                                  DateTime.now().add(
                                    Duration(days: index - 1),
                                  )),
                            ),
                          ))
                          .map((mapEntry) => TaskListItem(
                                id: mapEntry.key,
                                task: mapEntry.value,
                                isPrevious: false,
                              ))
                          .toList(),
                    );
            },
          ),
        ),
        const Padding(
            padding: EdgeInsets.only(bottom: PretConfig.defaultElementSpacing)),
        const NewTaskForm(),
      ]),
    );
  }
}
