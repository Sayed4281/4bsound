import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/app_state.dart';

class AddEventNoteScreen extends StatefulWidget {
  final EventNote? note;
  final int? index;

  const AddEventNoteScreen({super.key, this.note, this.index});

  @override
  State<AddEventNoteScreen> createState() => _AddEventNoteScreenState();
}

class _AddEventNoteScreenState extends State<AddEventNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientContactController = TextEditingController();
  final _venueController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _costController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _clientNameController.text = widget.note!.clientName;
      _clientContactController.text = widget.note!.clientContact;
      _venueController.text = widget.note!.venue;
      _equipmentController.text = widget.note!.equipmentNeeded;
      _costController.text = widget.note!.estimatedCost.toString();
      _selectedDate = widget.note!.eventDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _clientContactController.dispose();
    _venueController.dispose();
    _equipmentController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event Note' : 'Add Event Note'),
        backgroundColor: Colors.blue[700], // Blue header to match event notes screen
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // White body
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Event Title *',
                        hintText: 'e.g., Wedding Reception',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Event description and requirements',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Event Date *',
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _venueController,
                      decoration: const InputDecoration(
                        labelText: 'Venue *',
                        hintText: 'Event location',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter venue';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Client Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _clientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Client Name *',
                        hintText: 'Full name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter client name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _clientContactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        hintText: '+91 XXXXX XXXXX (Optional)',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Equipment & Pricing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _equipmentController,
                      decoration: const InputDecoration(
                        labelText: 'Equipment Needed',
                        hintText: 'List of equipment required',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _costController,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Cost (₹)',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);
      
      final note = EventNote(
        id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        eventDate: _selectedDate,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        clientName: _clientNameController.text,
        clientContact: _clientContactController.text,
        venue: _venueController.text,
        equipmentNeeded: _equipmentController.text,
        estimatedCost: double.tryParse(_costController.text) ?? 0,
      );

      if (widget.index != null) {
        appState.updateEventNote(widget.index!, note);
      } else {
        appState.addEventNote(note);
      }

      Navigator.pop(context);
    }
  }
}
