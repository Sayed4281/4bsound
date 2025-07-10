import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'add_event_note_screen.dart'; // <-- Import your add event note screen

class EventNotesScreen extends StatelessWidget {
  final dynamic initialEvent;
  const EventNotesScreen({Key? key, this.initialEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Event Notes')),
      body: Center(
        child: Text('No events yet'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1A1A2E),
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
}
