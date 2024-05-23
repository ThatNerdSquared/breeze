import 'package:breeze/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectListProvider);

    return Container(
      margin: const EdgeInsets.only(
        top: PretConfig.titleBarSafeArea,
        left: PretConfig.defaultElementSpacing,
        right: PretConfig.defaultElementSpacing,
      ),
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Row(children: [
            const Text("Projects"),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: ref.read(projectListProvider.notifier).addProject,
            ),
          ]),
        ),
        SliverReorderableList(
            itemCount: projects.length,
            onReorder: (oldIndex, newIndex) => print('hehehehe'),
            itemBuilder: (context, index) {
              final key = projects.keys.elementAt(index);
              return BreezeSidebarButton(
                key: Key(key),
                buttonText: TextFormField(
                    initialValue: projects[key]!.title,
                    onChanged: (name) => ref
                        .read(projectListProvider.notifier)
                        .updateProjectTitle(key, name)),
                icon: Icons.hexagon_rounded,
                count: projects[key]!.taskIDs.length,
                onPressedCallback: () =>
                    ref.read(currentProject.notifier).update(
                          (_) => key,
                        ),
              );
            })
      ]),
    );
  }
}

class BreezeSidebarButton extends StatelessWidget {
  final TextFormField buttonText;
  final IconData icon;
  final int count;
  final VoidCallback onPressedCallback;

  const BreezeSidebarButton({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.count,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: buttonText,
      leading: Icon(icon),
      trailing: Text(count.toString()),
      onTap: onPressedCallback,
    );
  }
}
