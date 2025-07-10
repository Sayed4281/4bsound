import 'package:flutter/material.dart';
import 'equipment.dart';

class AppState extends ChangeNotifier {
  // Company details
  static const String companyName = '4B SOUND';
  static const String companyAddress = 'MELATTUR, PALAKKAD DISTRICT, KERALA';
  static const String companyPhone = '+91 70259 75798';
  
  List<EventNote> _eventNotes = [];
  List<Quotation> _quotations = [];
  List<Equipment> _equipment = [];
  
  List<EventNote> get eventNotes => _eventNotes;
  List<Quotation> get quotations => _quotations;
  List<Equipment> get equipment => _equipment;
  
  AppState() {
    _loadData();
  }
  
  Future<void> _loadData() async {
    // TODO: Load data from SharedPreferences
    notifyListeners();
  }
  
  void addEventNote(EventNote note) {
    _eventNotes.add(note);
    notifyListeners();
    _saveData();
  }
  
  void updateEventNote(int index, EventNote note) {
    if (index >= 0 && index < _eventNotes.length) {
      _eventNotes[index] = note;
      notifyListeners();
      _saveData();
    }
  }
  
  void deleteEventNote(int index) {
    if (index >= 0 && index < _eventNotes.length) {
      _eventNotes.removeAt(index);
      notifyListeners();
      _saveData();
    }
  }
  
  void addQuotation(Quotation quotation) {
    _quotations.add(quotation);
    notifyListeners();
    _saveData();
  }
  
  void updateQuotation(int index, Quotation quotation) {
    if (index >= 0 && index < _quotations.length) {
      _quotations[index] = quotation;
      notifyListeners();
      _saveData();
    }
  }
  
  void deleteQuotation(int index) {
    if (index >= 0 && index < _quotations.length) {
      _quotations.removeAt(index);
      notifyListeners();
      _saveData();
    }
  }
  
  void addEquipment(Equipment equipment) {
    _equipment.add(equipment);
    notifyListeners();
    _saveData();
  }
  
  void updateEquipment(int index, Equipment equipment) {
    if (index >= 0 && index < _equipment.length) {
      _equipment[index] = equipment;
      notifyListeners();
      _saveData();
    }
  }
  
  void deleteEquipment(int index) {
    if (index >= 0 && index < _equipment.length) {
      _equipment.removeAt(index);
      notifyListeners();
      _saveData();
    }
  }
  
  Future<void> _saveData() async {
    // TODO: Save data to SharedPreferences
  }

  EventNote createEventNote({
    required String id,
    required String title,
    required String description,
    required DateTime eventDate,
    required String clientName,
    required String clientContact,
    required String venue,
    required String equipmentNeeded,
    required double estimatedCost,
  }) {
    final newEvent = EventNote(
      id: id,
      title: title,
      description: description,
      eventDate: eventDate,
      createdAt: DateTime.now(),
      clientName: clientName,
      clientContact: clientContact,
      venue: venue,
      equipmentNeeded: equipmentNeeded,
      estimatedCost: estimatedCost,
    );
    _eventNotes.add(newEvent);
    notifyListeners();
    _saveData();
    return newEvent;
  }
}

class EventNote {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime createdAt;
  final String clientName;
  final String clientContact;
  final String venue;
  final String equipmentNeeded;
  final double estimatedCost;
  
  EventNote({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.createdAt,
    required this.clientName,
    required this.clientContact,
    required this.venue,
    required this.equipmentNeeded,
    required this.estimatedCost,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'clientName': clientName,
      'clientContact': clientContact,
      'venue': venue,
      'equipmentNeeded': equipmentNeeded,
      'estimatedCost': estimatedCost,
    };
  }
  
  factory EventNote.fromJson(Map<String, dynamic> json) {
    return EventNote(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventDate: DateTime.parse(json['eventDate']),
      createdAt: DateTime.parse(json['createdAt']),
      clientName: json['clientName'],
      clientContact: json['clientContact'],
      venue: json['venue'],
      equipmentNeeded: json['equipmentNeeded'],
      estimatedCost: json['estimatedCost'].toDouble(),
    );
  }
}

class Quotation {
  final String id;
  final String clientName;
  final String clientContact;
  final String clientAddress;
  final String eventType;
  final DateTime eventDate;
  final String venue;
  final List<QuotationItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final DateTime createdAt;
  final String notes;
  
  Quotation({
    required this.id,
    required this.clientName,
    required this.clientContact,
    required this.clientAddress,
    required this.eventType,
    required this.eventDate,
    required this.venue,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.createdAt,
    required this.notes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientContact': clientContact,
      'clientAddress': clientAddress,
      'eventType': eventType,
      'eventDate': eventDate.toIso8601String(),
      'venue': venue,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }
  
  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'],
      clientName: json['clientName'],
      clientContact: json['clientContact'],
      clientAddress: json['clientAddress'],
      eventType: json['eventType'],
      eventDate: DateTime.parse(json['eventDate']),
      venue: json['venue'],
      items: (json['items'] as List)
          .map((item) => QuotationItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes'],
    );
  }
}

class QuotationItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;
  
  QuotationItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }
  
  factory QuotationItem.fromJson(Map<String, dynamic> json) {
    return QuotationItem(
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      total: json['total'].toDouble(),
    );
  }
}
