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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
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
      body: Row(children: [
        Expanded(
          flex: 1,
          child: Column(children: [
            const Expanded(
              flex: 1,
              child: NewTaskForm(),
            ),
            const Spacer(),
            IconButton.filled(
                onPressed: () => {}, icon: const Icon(Icons.calendar_month))
          ]),
        ),
        const VerticalDivider(),
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(PretConfig.defaultElementSpacing),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Text(humanizeDate(index)),
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
                              .toList()),
                      const Divider()
                    ],
                  );
                },
              ),
            )),
      ]),
    );
    // floatingActionButton: FloatingActionButton(
    //   onPressed: showAdaptiveDialog(builder: ),
    //   tooltip: 'Increment',
    //   child: const Icon(Icons.add),
    // ),
  }
}
