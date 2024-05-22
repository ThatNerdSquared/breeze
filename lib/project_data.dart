import 'package:breeze/json_backend.dart';
import 'package:breeze/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class ProjectData extends StateNotifier<Map<String, Project>> {
  ProjectData({
    Map<String, Project>? initialProjects,
  }) : super(initialProjects ?? {}) {
    readProjects();
  }

  void readProjects() {
    state = JsonBackend().readProjectsFromJson();
  }

  void _writeProjects() {
    JsonBackend().writeDataToJson(state, 'projects');
  }

  void addProject() {
    state = {
      ...state,
      uuID.v4(): Project(title: 'Untitled', taskIDs: const [])
    };
    _writeProjects();
  }

  void updateProjectTitle(String id, String newTitle) {
    state = state.map(
      (k, v) => MapEntry(
          k,
          k == id
              ? Project(
                  title: newTitle,
                  taskIDs: v.taskIDs,
                )
              : v),
    );
    _writeProjects();
  }

  void addTaskToProject(String taskID, String projectID) {
    state = state.map(
      (k, v) => MapEntry(
          k,
          k == projectID
              ? Project(
                  title: v.title,
                  taskIDs: [...v.taskIDs, taskID],
                )
              : v),
    );
    _writeProjects();
  }
}

class Project extends PretDataclass {
  final String title;
  final List<String> taskIDs;

  Project({
    required this.title,
    required this.taskIDs,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'taskIDs': taskIDs,
    };
  }
}
