import 'package:breeze/json_backend.dart';
import 'package:breeze/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskStatus { todo, wip, done }

String statusToString(TaskStatus status) => switch (status) {
      TaskStatus.todo => "todo",
      TaskStatus.wip => "wip",
      TaskStatus.done => "done",
    };

TaskStatus statusFromString(String status) => switch (status) {
      "todo" => TaskStatus.todo,
      "wip" => TaskStatus.wip,
      "done" => TaskStatus.done,
      _ => throw ArgumentError('Could not convert "$status" into TaskStatus!')
    };

class TaskData extends StateNotifier<Map<String, Task>> {
  TaskData({
    Map<String, Task>? initialTasks,
  }) : super(initialTasks ?? {}) {
    readTasks();
  }

  void readTasks() {
    state = JsonBackend().readTasksFromJson();
  }

  void _writeTasks() {
    JsonBackend().writeTasksToJson(state);
  }

  void addTask(Task task) {
    state = {
      ...state,
      uuID.v4(): task,
    };
    _writeTasks();
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
    _writeTasks();
  }

  void updateTaskDate(String id, DateTime newDate) {
    state = state.map((key, value) {
      if (key == id) {
        return MapEntry(
            key,
            Task(
              title: value.title,
              datetime: newDate,
              status: value.status,
            ));
      } else {
        return MapEntry(key, value);
      }
    });
    _writeTasks();
  }

  void deleteTask(String id) {
    state = Map.fromEntries(
      state.entries.where((mapEntry) => mapEntry.key != id),
    );
    _writeTasks();
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': datetime.toIso8601String(),
      'status': statusToString(status),
    };
  }
}
