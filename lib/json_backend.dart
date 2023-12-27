import 'dart:io';

import 'package:breeze/config.dart';
import 'package:breeze/task_data.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class JsonBackend extends PretJsonManager {
  @override
  File dataFile = File(Config.dataFilePath);
  @override
  String schemaVersion = '1.0.0';
  @override
  Map<String, List<String>> dropFields = {};
  @override
  Map get freshJson => <String, dynamic>{'schema': schemaVersion, 'tasks': {}};

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
