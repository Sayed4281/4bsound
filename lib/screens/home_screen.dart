import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'event_notes_screen.dart';
import 'quotations_screen.dart';
import 'equipment_screen.dart';
import '../widgets/company_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E), // Dark navy
              Color(0xFF16213E), // Darker navy
              Color(0xFF0F3460), // Deep blue
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header - Fixed height
              SizedBox(
                height: 240,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Company Logo
                      const CompanyLogo(
                        size: 80,
                        showShadow: true,
                      ).animate().scale(delay: 200.ms, duration: 600.ms),
                      
                      const SizedBox(height: 16),
                      
                      const Text(
                        '4B SOUND',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'MUSIC BAND',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF6B35),
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 500.ms, duration: 800.ms),
                      
                      const SizedBox(height: 4),
                      
                      const Text(
                        'MELATTUR, PALAKKAD DISTRICT, KERALA',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms),
                      
                      const SizedBox(height: 4),
                      
                      const Text(
                        '+91 70259 75798',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF6B35),
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 700.ms, duration: 800.ms),
                    ],
                  ),
                ),
              ),
              
              // Dashboard Cards - Takes remaining space
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Handle bar
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Dashboard title
                            Row(
                              children: [
                                const Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.dashboard_rounded,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Cards Grid - Fixed layout without scroll
                            Expanded(
                              child: Column(
                                children: [
                                  // First row
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _DashboardCard(
                                            title: 'Event Notes',
                                            count: appState.eventNotes.length,
                                            icon: Icons.event_note_rounded,
                                            color: const Color(0xFF6C63FF),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const EventNotesScreen(),
                                                ),
                                              );
                                            },
                                          ).animate().slideY(
                                            delay: 300.ms,
                                            duration: 600.ms,
                                            begin: 0.5,
                                            end: 0,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _DashboardCard(
                                            title: 'Quotations',
                                            count: appState.quotations.length,
                                            icon: Icons.receipt_long_rounded,
                                            color: const Color(0xFF2196F3),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const QuotationsScreen(),
                                                ),
                                              );
                                            },
                                          ).animate().slideY(
                                            delay: 400.ms,
                                            duration: 600.ms,
                                            begin: 0.5,
                                            end: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Second row
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _DashboardCard(
                                            title: 'Equipment',
                                            count: appState.equipment.length,
                                            icon: Icons.speaker_rounded,
                                            color: const Color(0xFF66BB6A),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const EquipmentScreen(),
                                                ),
                                              );
                                            },
                                          ).animate().slideY(
                                            delay: 500.ms,
                                            duration: 600.ms,
                                            begin: 0.5,
                                            end: 0,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _DashboardCard(
                                            title: 'Clients',
                                            count: 0,
                                            icon: Icons.people_rounded,
                                            color: const Color(0xFF26C6DA),
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Clients feature coming soon!'),
                                                  backgroundColor: Color(0xFF26C6DA),
                                                ),
                                              );
                                            },
                                          ).animate().slideY(
                                            delay: 600.ms,
                                            duration: 600.ms,
                                            begin: 0.5,
                                            end: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: color.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.8),
                        color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
