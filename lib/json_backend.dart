import 'dart:io';

import 'package:breeze/config.dart';
import 'package:breeze/task_data.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class JsonBackend extends PretJsonManager {
  @override
  File dataFile = File(Config.dataFilePath);
  @override
  final freshJson = <String, dynamic>{
    'schema': Config.currentSchemaVersion,
    'tasks': {}
  };

  void writeTasksToJson(Map<String, Task> tasks) {
    jsonWriteWrapper((initialData) {
      final mappifiedTasks = tasks.map((key, value) => MapEntry(
            key,
            value.toJson(),
          ));
      initialData['tasks'] = mappifiedTasks;
      return initialData;
    });
  }

  Map<String, Task> readTasksFromJson() {
    final contentsMap = pretLoadJson()['tasks'];
    return Map<String, Task>.from(contentsMap.map(
      (key, value) => MapEntry(
        key,
        Task(
            title: value['title'],
            datetime: DateTime.parse(value['datetime']),
            status: statusFromString(value['status'])),
      ),
    ));
  }
}
