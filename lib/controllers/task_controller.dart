import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskController {
  static final TaskService _service = TaskService();
  static List<Task> tasks = [];

  static Future<void> loadTasks() async {
    tasks = await _service.fetchTasks();
  }

  static Future<void> addTask(Task task) async {
    await _service.addTask(task);
    await loadTasks();
  }

  static Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    task.status = task.isDone ? 'SELESAI' : 'BERJALAN';
    await _service.updateTask(task);
  }

  static Future<void> deleteTask(Task task) async {
    await _service.deleteTask(task.id);
    tasks.removeWhere((t) => t.id == task.id);
  }
}
