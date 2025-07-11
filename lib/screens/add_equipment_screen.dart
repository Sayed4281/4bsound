import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/app_state.dart';
import '../models/equipment.dart';

class AddEquipmentScreen extends StatefulWidget {
  final Equipment? equipment;
  final int? index;

  const AddEquipmentScreen({super.key, this.equipment, this.index});

  @override
  State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  String _selectedCategory = 'Sound System';
  bool _isAvailable = true;
  String _imagePath = '';
  Uint8List? _selectedImageBytes;
  String? _selectedImagePath;

  final List<String> _categories = [
    'Sound System',
    'Microphones',
    'Speakers',
    'DJ Equipment',
    'Lighting',
    'Amplifiers',
    'Cables & Accessories',
    'Stage Equipment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.equipment != null) {
      _nameController.text = widget.equipment!.name;
      _descriptionController.text = widget.equipment!.description;
      _priceController.text = widget.equipment!.rentalPrice.toString();
      _selectedCategory = widget.equipment!.category;
      _isAvailable = widget.equipment!.isAvailable;
      _imagePath = widget.equipment!.imagePath;
      _selectedImageBytes = widget.equipment!.imageBytes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.equipment != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Equipment' : 'Add Equipment'),
        backgroundColor: Colors.green[700], // Green header to match equipment screen
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveEquipment,
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
            // Image selection
            GestureDetector(
              onTap: () => _selectImage(),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: _selectedImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _selectedImageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const _ImagePlaceholder(),
              ),
            ),

            const SizedBox(height: 24),

            // Equipment Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Equipment Name *',
                hintText: 'Enter equipment name',
                prefixIcon: Icon(Icons.speaker),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter equipment name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter equipment description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Rental Price
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Rental Price (₹/day)',
                hintText: 'Enter rental price per day',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rental price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Availability switch
            SwitchListTile(
              title: const Text('Available for Rent'),
              subtitle: Text(_isAvailable ? 'Currently available' : 'Not available'),
              value: _isAvailable,
              onChanged: (value) {
                setState(() {
                  _isAvailable = value;
                });
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage([ImageSource? source]) async {
    final ImagePicker picker = ImagePicker();
    
    if (source != null) {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImagePath = image.path;
          _imagePath = image.path;
        });
      }
    } else {
      // Show source selection dialog
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  void _saveEquipment() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);

      final equipment = Equipment(
        id: widget.equipment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        imagePath: _imagePath,
        imageBytes: _selectedImageBytes,
        category: _selectedCategory,
        isAvailable: _isAvailable,
        rentalPrice: double.tryParse(_priceController.text) ?? 0,
        createdAt: widget.equipment?.createdAt ?? DateTime.now(),
      );

      if (widget.index != null) {
        appState.updateEquipment(widget.index!, equipment);
      } else {
        appState.addEquipment(equipment);
      }

      Navigator.pop(context);
    }
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to add image',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Camera or Gallery',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
