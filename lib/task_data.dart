import 'package:breeze/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskStatuses { todo, wip, done }

class TaskData extends StateNotifier<Map<String, Task>> {
  TaskData({
    Map<String, Task>? initialTasks,
  }) : super(initialTasks ?? {}) {
    readTasks();
  }

  void readTasks() {}

  void addTask(Task task) {
    state = {
      ...state,
      uuID.v4(): task,
    };
  }
}

@immutable
class Task {
  final String title;
  final TaskStatuses status;
  final DateTime datetime;
  final int track;

  const Task({
    required this.title,
    this.status = TaskStatuses.todo,
    required this.datetime,
    this.track = 0,
  });
}
