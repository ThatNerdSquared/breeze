import 'package:breeze/new_task_form.dart';
import 'package:breeze/task_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';

const uuID = Uuid();

final taskListProvider = StateNotifierProvider<TaskData, Map<String, Task>>(
  (ref) => TaskData(),
);

void main() {
  runApp(const MainApp());
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

class Breeze extends StatelessWidget {
  const Breeze({super.key});

  String padDate(int datePart) => datePart.toString().padLeft(2, '0');

  String getDateFormatted(int offset) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Expanded(
          flex: 2,
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
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(PretConfig.defaultElementSpacing),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: PretCard(
                              padding: PretConfig.thinElementSpacing,
                              child: Text(getDateFormatted(index))),
                        ),
                        Expanded(
                            flex: 6,
                            child: PretCard(
                              child: SizedBox(
                                  width: 150,
                                  child: Column(children: [
                                    Expanded(
                                      flex: 10,
                                      child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              const Text('test')),
                                    )
                                  ])),
                            )),
                        Expanded(
                            flex: 6,
                            child: PretCard(
                              child: SizedBox(
                                  width: 150,
                                  child: Column(children: [
                                    Expanded(
                                      flex: 10,
                                      child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              const Text('test')),
                                    )
                                  ])),
                            )),
                      ],
                    )),
          ),
        )
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: showAdaptiveDialog(builder: ),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
