import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/pages/dashboard_page.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zwlayopiivstygmpjkfy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3bGF5b3BpaXZzdHlnbXBqa2Z5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5MDc5NTQsImV4cCI6MjA3ODQ4Mzk1NH0.Lv-2q2oOxxqz8AeFOZkzbZ7AwHLp0t3Oadc03EptOLA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: AppTypography.fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
