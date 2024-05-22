import 'dart:core';

import 'package:breeze/project_data.dart';
import 'package:breeze/sidebar.dart';
import 'package:breeze/task_data.dart';
import 'package:breeze/views/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'views/project_view.dart';

const uuID = Uuid();
String platformAppSupportDir = '';

final taskListProvider = StateNotifierProvider<TaskData, Map<String, Task>>(
  (ref) => TaskData(),
);
final projectListProvider =
    StateNotifierProvider<ProjectData, Map<String, Project>>(
  (ref) => ProjectData(),
);
final showCompleted = StateProvider<bool>((ref) => false);
final currentProject = StateProvider<String>((ref) => 'Inbox');

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
  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectListProvider);
    return Scaffold(body: Center(child: LayoutBuilder(
      builder: (context, constraints) {
        return Row(children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: constraints.maxHeight,
              child: const Sidebar(),
            ),
          ),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: constraints.maxHeight,
              child: ProjectView(
                project: projects[ref.watch(currentProject)]!,
              ),
            ),
          ),
          const Expanded(
            flex: 5,
            child: ScheduleView(),
          )
        ]);
      },
    )));
  }
}
