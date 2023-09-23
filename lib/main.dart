import 'dart:core';

import 'package:breeze/date_utils.dart';
import 'package:breeze/list_section.dart';
import 'package:breeze/new_task_form.dart';
import 'package:breeze/task_data.dart';
import 'package:breeze/task_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:uuid/uuid.dart';

const uuID = Uuid();

final taskListProvider = StateNotifierProvider<TaskData, Map<String, Task>>(
  (ref) => TaskData(),
);

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'iA Writer Quattro',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white).copyWith(
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const Breeze(),
    );
  }
}

class Breeze extends ConsumerWidget {
  const Breeze({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(PretConfig.defaultElementSpacing),
      child: Column(children: [
        Expanded(
          flex: 8,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? ListSection(
                      header: const Text('Previous'),
                      children: ref
                          .watch(taskListProvider.select(
                            (tasklist) => tasklist.entries
                                .where((taskEntry) => isDateBeforeToday(
                                      taskEntry.value.datetime,
                                    )),
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
    ));
  }
}
