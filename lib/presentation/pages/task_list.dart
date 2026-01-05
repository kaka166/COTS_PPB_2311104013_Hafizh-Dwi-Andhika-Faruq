import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import 'task_detail_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    final tasks = TaskController.tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.course),
            trailing: Checkbox(
              value: task.isDone,
              onChanged: (_) {
                setState(() {
                  TaskController.toggleTask(task);
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
              );
            },
          );
        },
      ),
    );
  }
}
