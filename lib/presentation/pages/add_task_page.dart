import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _deadline = DateTime.now();
  bool _isLoading = false;

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await TaskController.addTask(
        Task(
          id: 0, // ❗️DIABAIKAN Supabase
          title: _titleController.text,
          course: _courseController.text,
          deadline: _deadline,
          status: 'BERJALAN',
          note: _noteController.text,
          isDone: false,
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan tugas: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Tugas', style: AppTypography.heading),
              const SizedBox(height: AppSpacing.md),

              /// JUDUL
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Tugas'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              /// MATA KULIAH
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Mata Kuliah'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Mata kuliah wajib diisi' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              /// DEADLINE
              InkWell(
                onTap: _pickDeadline,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Deadline: '
                        '${_deadline.year}-'
                        '${_deadline.month.toString().padLeft(2, '0')}-'
                        '${_deadline.day.toString().padLeft(2, '0')}',
                        style: AppTypography.body,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              /// CATATAN
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Catatan'),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
