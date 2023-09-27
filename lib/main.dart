import 'dart:core';

import 'package:breeze/date_utils.dart';
import 'package:breeze/list_section.dart';
import 'package:breeze/new_task_form.dart';
import 'package:breeze/task_data.dart';
import 'package:breeze/task_listitem.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:uuid/uuid.dart';

const uuID = Uuid();
String platformAppSupportDir = '';

final taskListProvider = StateNotifierProvider<TaskData, Map<String, Task>>(
  (ref) => TaskData(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformAppSupportDir = (await getApplicationDocumentsDirectory()).path;
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

class Breeze extends ConsumerStatefulWidget {
  const Breeze({super.key});

  @override
  BreezeState createState() => BreezeState();
}

class BreezeState extends ConsumerState<Breeze> {
  var _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
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
                              text: _showCompleted
                                  ? "hide completed"
                                  : "show completed",
                              style: TextStyle(
                                color: Colors.pink[300],
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => setState(() {
                                      _showCompleted = !_showCompleted;
                                    })),
                          const TextSpan(text: ")")
                        ]),
                      ),
                      children: ref
                          .watch(taskListProvider.select(
                            (tasklist) => tasklist.entries.where((taskEntry) =>
                                isDateBeforeToday(
                                  taskEntry.value.datetime,
                                ) &&
                                (!_showCompleted
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
    )));
  }
}
