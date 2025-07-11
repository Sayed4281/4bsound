import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/app_state.dart';
import '../widgets/event_view_dialog.dart';
import 'add_event_note_screen.dart';

class EventNotesScreen extends StatelessWidget {
  final dynamic initialEvent;
  const EventNotesScreen({Key? key, this.initialEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Notes'),
        backgroundColor: Colors.blue[700], // Blue header
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white, // White body
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.eventNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 80,
                    color: Colors.grey[400],
                  ).animate().scale(delay: 200.ms, duration: 600.ms),
                  const SizedBox(height: 16),
                  Text(
                    'No events added yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first event',
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.eventNotes.length,
            itemBuilder: (context, index) {
              final event = appState.eventNotes[index];
              return _EventCard(
                event: event,
                index: index,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EventViewDialog(event: event),
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEventNoteScreen(
                        note: event,
                        index: index,
                      ),
                    ),
                  );
                },
                onDelete: () => _showDeleteDialog(context, appState, index),
              ).animate().fadeIn(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 400),
              ).slideY(
                begin: 0.2,
                end: 0,
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 400),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[700], // Match the header color
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEventNoteScreen(), // <-- Go to add event note screen
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppState appState, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.deleteEventNote(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventNote event;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventCard({
    required this.event,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and menu
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Event details
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    '${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              if (event.clientName.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      event.clientName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              
              if (event.venue.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.venue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              
              if (event.estimatedCost > 0) ...[
                Row(
                  children: [
                    const Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Rs. ${event.estimatedCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
