import 'package:flutter/material.dart';
import 'package:geozebra_app/models/theme_model.dart';
import 'package:geozebra_app/models/class_model.dart';

class DefaultDrawer extends StatelessWidget {
  final Lesson lesson;
  final Map<String, bool> taskStatus;

  const DefaultDrawer({
    Key? key,
    required this.lesson,
    required this.taskStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Aufgaben", style: TextStyle(fontSize: 22)),
              ),
              ListTile(
                title: Text("Desktop Modus"),
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: false,
                    onChanged: (bool value) {
                      // Handle switch state change
                    },
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Divider(
              height: 2,
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          ...lesson.tasks.map((task) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ExpansionTile(
                  title: Text(task.shortDescription),
                  tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                  backgroundColor: taskStatus[task.id] == true
                      ? Theme.of(context).extension<TaskColors>()!.completedTask
                      : Theme.of(context).extension<TaskColors>()!.uncompletedTask,
                  collapsedBackgroundColor: taskStatus[task.id] == true
                      ? Theme.of(context).extension<TaskColors>()!.completedTask
                      : Theme.of(context).extension<TaskColors>()!.uncompletedTask,
                  children: [
                    ListTile(
                      title: Text(task.description),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Task Details"),
                              content: Text(task.description),
                              actions: [
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}