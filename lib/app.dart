import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

class SFAApp extends StatelessWidget {
  const SFAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SFA-UI-Flutter',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
