import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import 'task_list_page.dart';
import 'add_task_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
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

  @override
  Widget build(BuildContext context) {
    final tasks = TaskController.tasks;

    final total = tasks.length;
    final selesai = tasks.where((t) => t.isDone).length;
    final berjalan = tasks.where((t) => !t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
        ],
      ),
      body: _buildBody(total, berjalan, selesai),
    );
  }

  Widget _buildBody(int total, int berjalan, int selesai) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text('Terjadi error:\n$_error', textAlign: TextAlign.center),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Text('Ringkasan Tugas', style: AppTypography.heading),
          const SizedBox(height: AppSpacing.md),

          /// STAT CARDS
          Row(
            children: [
              _StatCard(
                title: 'Total',
                value: total.toString(),
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatCard(
                title: 'Berjalan',
                value: berjalan.toString(),
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatCard(
                title: 'Selesai',
                value: selesai.toString(),
                color: AppColors.success,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          /// MENU
          Text('Menu', style: AppTypography.title),
          const SizedBox(height: AppSpacing.sm),

          _MenuButton(
            icon: Icons.list_alt,
            label: 'Daftar Tugas',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskListPage()),
              );
              _loadDashboard(); // ⬅️ refresh setelah balik
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _MenuButton(
            icon: Icons.add_circle_outline,
            label: 'Tambah Tugas',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskPage()),
              );
              _loadDashboard(); // ⬅️ refresh setelah tambah
            },
          ),
        ],
      ),
    );
  }
}

/// =======================
/// STAT CARD
/// =======================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.heading.copyWith(color: color, fontSize: 24),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(title, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// MENU BUTTON
/// =======================
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: AppTypography.title),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
