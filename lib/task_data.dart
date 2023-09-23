import 'package:breeze/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskStatus { todo, wip, done }

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

  void updateTaskStatus(String id, TaskStatus status) {
    state = state.map((key, value) {
      if (key == id) {
        return MapEntry(
            key,
            Task(
              title: value.title,
              datetime: value.datetime,
              status: status,
            ));
      } else {
        return MapEntry(key, value);
      }
    });
  }

  void deleteTask(String id) {
    state = Map.fromEntries(
      state.entries.where((mapEntry) => mapEntry.key != id),
    );
  }
}

@immutable
class Task {
  final String title;
  final TaskStatus status;
  final DateTime datetime;

  const Task({
    required this.title,
    this.status = TaskStatus.todo,
    required this.datetime,
  });
}
