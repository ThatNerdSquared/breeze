import 'package:breeze/new_task_form.dart';
import 'package:breeze/task_data.dart';
import 'package:breeze/task_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';

const uuID = Uuid();

final taskListProvider = StateNotifierProvider<TaskData, Map<String, Task>>(
  (ref) => TaskData(),
);

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Breeze(),
    );
  }
}

class Breeze extends ConsumerWidget {
  const Breeze({super.key});

  String padDate(int datePart) => datePart.toString().padLeft(2, '0');

  String humanizeDate(int offset) {
    switch (offset) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      default:
        final datetime = DateTime.now().add(Duration(days: offset));
        return offset < 7
            ? Config.weekdayNames[datetime.weekday]!
            : '${padDate(datetime.year)}-${padDate(datetime.month)}-${padDate(datetime.day)}';
    }
  }

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
              return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      right: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      bottom: BorderSide.none,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: PretConfig.thinElementSpacing,
                    bottom: PretConfig.thinElementSpacing,
                    left: PretConfig.defaultElementSpacing,
                    right: PretConfig.defaultElementSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(humanizeDate(index)),
                      const Padding(
                          padding: EdgeInsets.only(
                              bottom: PretConfig.minElementSpacing)),
                      Column(
                        children: ref
                            .watch(taskListProvider.select(
                              (tasklist) => tasklist.entries.where(
                                (taskEntry) => taskEntry.value.datetime
                                    .isSameDate(DateTime.now()
                                        .add(Duration(days: index))),
                              ),
                            ))
                            .map((mapEntry) => TaskListItem(
                                id: mapEntry.key, task: mapEntry.value))
                            .toList(),
                      )
                    ],
                  ));
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
