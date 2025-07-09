import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/app_state.dart';
import 'utils/theme.dart';
import 'widgets/company_logo.dart';

void main() {
  runApp(const Sound4BApp());
}

class Sound4BApp extends StatelessWidget {
  const Sound4BApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: '4B SOUND',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E), // Dark navy
              Color(0xFF16213E), // Darker navy
              Color(0xFF0F3460), // Deep blue
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo using CompanyLogo widget
            const CompanyLogo(
              size: 120,
              showShadow: true,
            ).animate().scale(delay: 300.ms, duration: 600.ms),
            
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                'SOUND',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 800.ms),
            
            const SizedBox(height: 16),
            
            const Text(
              'MUSIC BAND',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFF6B35),
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 900.ms, duration: 800.ms),
            
            const SizedBox(height: 50),
            
            // Loading indicator
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                  strokeWidth: 3,
                ),
              ),
            ).animate().fadeIn(delay: 1200.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
