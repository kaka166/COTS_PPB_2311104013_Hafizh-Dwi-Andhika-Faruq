import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task_model.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _noteController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.task.note);
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      widget.task.note = _noteController.text;
      await TaskController.toggleTask(widget.task);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update tugas: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: AppTypography.heading),
            const SizedBox(height: AppSpacing.xs),
            Text(task.course, style: AppTypography.body),
            const SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                Checkbox(value: task.isDone, onChanged: (_) => _save()),
                Text(
                  task.isDone ? 'Selesai' : 'Belum Selesai',
                  style: AppTypography.body,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
            Text('Catatan', style: AppTypography.title),
            const SizedBox(height: AppSpacing.xs),

            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tambahkan catatan tugas',
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
