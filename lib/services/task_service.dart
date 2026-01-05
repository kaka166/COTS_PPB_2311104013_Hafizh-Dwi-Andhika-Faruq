import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Task>> fetchTasks() async {
    final data = await _client
        .from('tasks')
        .select()
        .order('deadline', ascending: true);

    return (data as List)
        .map(
          (e) => Task(
            id: e['id'],
            title: e['title'],
            course: e['course'],
            deadline: DateTime.parse(e['deadline']),
            status: e['status'],
            note: e['note'] ?? '',
            isDone: e['is_done'],
          ),
        )
        .toList();
  }

  Future<void> addTask(Task task) async {
    await _client.from('tasks').insert({
      'title': task.title,
      'course': task.course,
      'deadline': task.deadline.toIso8601String().substring(0, 10),
      'status': task.status,
      'note': task.note,
      'is_done': task.isDone,
    });
  }

  Future<void> updateTask(Task task) async {
    await _client
        .from('tasks')
        .update({
          'status': task.status,
          'is_done': task.isDone,
          'note': task.note,
        })
        .eq('id', task.id);
  }

  Future<void> deleteTask(int id) async {
    await _client.from('tasks').delete().eq('id', id);
  }
}
