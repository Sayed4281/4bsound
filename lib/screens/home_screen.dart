import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'event_notes_screen.dart';
import 'quotations_screen.dart';
import 'equipment_screen.dart';
import '../widgets/company_logo.dart';
import 'add_event_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF2196F3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  const CompanyLogo(size: 48, showShadow: true),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome to 4B SOUND',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage your band with ease',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Expanded GridView to avoid overflow
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.95, // Helps avoid overflow
                  children: [
                    _GridCard(
                      title: 'Event Notes',
                      count: appState.eventNotes.length,
                      icon: Icons.event_note_rounded,
                      color: const Color(0xFF6C63FF),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EventNotesScreen()));
                      },
                    ),
                    _GridCard(
                      title: 'Quotations',
                      count: appState.quotations.length,
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFF2196F3),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationsScreen()));
                      },
                    ),
                    _GridCard(
                      title: 'Equipment',
                      count: appState.equipment.length,
                      icon: Icons.speaker_rounded,
                      color: const Color(0xFF66BB6A),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EquipmentScreen()));
                      },
                    ),
                    _GridCard(
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1A1A2E),
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
        onPressed: () {
          final newEvent = appState.createEventNote(
            id: UniqueKey().toString(),
            title: 'New Event',
            description: '',
            eventDate: DateTime.now(),
            clientName: '',
            clientContact: '',
            venue: '',
            equipmentNeeded: '',
            estimatedCost: 0.0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEventNoteScreen(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A1A2E),
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EventNotesScreen()),
            );
          }
          // Add navigation for other tabs if needed
        },
      ),
    );
  }
}

// Grid Card Widget
class _GridCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GridCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.18),
                radius: 28,
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count > 0 ? '$count' : 'Coming soon',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}