import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';
import '../project_data.dart';
import '../task_data.dart';
import '../task_listitem.dart';

class ProjectView extends ConsumerWidget {
  final Project project;

  const ProjectView({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: PretConfig.titleBarSafeArea),
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Row(children: [
            const Icon(Icons.hexagon_rounded),
            Text(project.title),
          ]),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: PretConfig.defaultElementSpacing,
          ),
        ),
        SliverReorderableList(
            itemCount: project.taskIDs.length,
            onReorder: (oldIndex, newIndex) => print('hehehehe'),
            itemBuilder: (context, index) {
              final taskId = project.taskIDs.elementAt(index);
              final task = ref.watch(taskListProvider)[taskId]!;
              if (task.status == TaskStatus.done) {
                return Container(key: Key(taskId));
              }
              return TaskListItem(
                key: Key(taskId),
                id: taskId,
                task: task,
                isPrevious: true,
              );
            }),
      ]),
    );
  }
}
