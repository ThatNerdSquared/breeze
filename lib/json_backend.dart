import 'dart:io';

import 'package:breeze/config.dart';
import 'package:breeze/project_data.dart';
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
  Map get freshJson => <String, dynamic>{
        'schema': schemaVersion,
        'projects': {
          'Inbox': {'title': 'Inbox', 'taskIDs': []},
        },
        'tasks': {},
      };

  Map<String, Task> readTasksFromJson() {
    final contentsMap = pretLoadJson()['tasks'];
    return Map<String, Task>.from(contentsMap.map(
      (key, value) => MapEntry(
        key,
        Task(
          title: value['title'],
          datetime: DateTime.parse(value['datetime']),
          status: statusFromString(value['status']),
          project: value['project'],
        ),
      ),
    ));
  }

  Map<String, Project> readProjectsFromJson() {
    final contentsMap = pretLoadJson()['projects'];
    return Map<String, Project>.from(contentsMap.map(
      (key, value) => MapEntry(
        key,
        Project(
          title: value['title'],
          taskIDs: List<String>.from(value['taskIDs']),
        ),
      ),
    ));
  }
}
