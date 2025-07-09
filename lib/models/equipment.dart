import 'dart:typed_data';

class Equipment {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final Uint8List? imageBytes; // For web compatibility
  final String category;
  final bool isAvailable;
  final double rentalPrice;
  final DateTime createdAt;
  
  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    this.imageBytes,
    required this.category,
    required this.isAvailable,
    required this.rentalPrice,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'imageBytes': imageBytes?.toList(), // Convert to List for JSON serialization
      'category': category,
      'isAvailable': isAvailable,
      'rentalPrice': rentalPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      imageBytes: json['imageBytes'] != null 
          ? Uint8List.fromList(List<int>.from(json['imageBytes']))
          : null,
      category: json['category'],
      isAvailable: json['isAvailable'],
      rentalPrice: json['rentalPrice'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
