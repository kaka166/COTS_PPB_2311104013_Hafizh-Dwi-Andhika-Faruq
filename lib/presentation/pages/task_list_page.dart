import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_spacing.dart';
import '../../models/task_model.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      await TaskController.loadTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmDelete(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Yakin ingin menghapus tugas "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await TaskController.deleteTask(task);
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = TaskController.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTasks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          );
          _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
      body: _buildBody(tasks),
    );
  }

  Widget _buildBody(List<Task> tasks) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text('Terjadi error:\n$_error', textAlign: TextAlign.center),
      );
    }

    if (tasks.isEmpty) {
      return const Center(child: Text('Belum ada tugas'));
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Stack(
            children: [
              TaskCard(
                task: task,
                onChecked: (_) async {
                  await TaskController.toggleTask(task);
                  setState(() {});
                },
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailPage(task: task),
                    ),
                  );
                  _loadTasks();
                },
              ),

              /// DELETE BUTTON
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(task),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
