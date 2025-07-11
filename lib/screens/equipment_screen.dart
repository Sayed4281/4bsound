import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/equipment.dart';
import '../widgets/equipment_view_dialog.dart';
import 'add_equipment_screen.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Inventory'),
        backgroundColor: Colors.green[700], // Green header
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEquipmentScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // White body
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.equipment.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.speaker_rounded,
                    size: 80,
                    color: Colors.grey[400],
                  ).animate().scale(delay: 200.ms, duration: 600.ms),
                  const SizedBox(height: 16),
                  Text(
                    'No equipment added yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first equipment',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 600.ms, duration: 800.ms),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: appState.equipment.length,
            itemBuilder: (context, index) {
              final equipment = appState.equipment[index];
              return _EquipmentCard(
                equipment: equipment,
                index: index,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EquipmentViewDialog(equipment: equipment),
                  );
                },
                onDelete: () => _showDeleteDialog(context, appState, index),
              ).animate().scale(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 400),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppState appState, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Equipment'),
        content: const Text('Are you sure you want to delete this equipment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.deleteEquipment(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _EquipmentCard({
    required this.equipment,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Equipment Image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2196F3).withOpacity(0.1),
                      const Color(0xFF6C63FF).withOpacity(0.1),
                    ],
                  ),
                ),
                child: equipment.imageBytes != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.memory(
                          equipment.imageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : equipment.imagePath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              equipment.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.speaker_rounded,
                                  size: 60,
                                  color: Color(0xFF2196F3),
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.speaker_rounded,
                            size: 60,
                            color: Color(0xFF2196F3),
                          ),
              ),
            ),
            
            // Equipment Name
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      equipment.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onTap();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
