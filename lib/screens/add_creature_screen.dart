import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:catalogsforcreatureapps/models/creature.dart';
import 'package:catalogsforcreatureapps/providers/creature_provider.dart';

class AddCreatureScreen extends StatefulWidget {
  final Creature? creature; // For editing existing creature

  const AddCreatureScreen({super.key, this.creature});

  @override
  State<AddCreatureScreen> createState() => _AddCreatureScreenState();
}

class _AddCreatureScreenState extends State<AddCreatureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _habitatController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discoveredByController = TextEditingController();
  final _resourcesController = TextEditingController();

  XFile? _imageFile;
  bool _isDangerous = false;
  String _rarity = 'common';
  String? _size;
  String _conservationStatus = 'least_concern';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.creature != null) {
      _nameController.text = widget.creature!.name;
      _speciesController.text = widget.creature!.species;
      _habitatController.text = widget.creature!.habitat;
      _descriptionController.text = widget.creature!.description;
      _discoveredByController.text = widget.creature!.discoveredBy ?? '';
      _resourcesController.text = widget.creature!.resources ?? '';
      _isDangerous = widget.creature!.isDangerous;
      _rarity = widget.creature!.rarity;
      _size = widget.creature!.size;
      _conservationStatus = widget.creature!.conservationStatus;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _habitatController.dispose();
    _descriptionController.dispose();
    _discoveredByController.dispose();
    _resourcesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final provider = context.read<CreatureProvider>();
    bool success;

    if (widget.creature == null) {
      // Add new creature
      success = await provider.addCreature(
        name: _nameController.text.trim(),
        species: _speciesController.text.trim(),
        habitat: _habitatController.text.trim(),
        description: _descriptionController.text.trim(),
        imageFile: _imageFile,
        discoveredBy: _discoveredByController.text.trim().isEmpty
            ? null
            : _discoveredByController.text.trim(),
        isDangerous: _isDangerous,
        rarity: _rarity,
        size: _size,
        resources: _resourcesController.text.trim().isEmpty
            ? null
            : _resourcesController.text.trim(),
        conservationStatus: _conservationStatus,
      );
    } else {
      // Update existing creature
      success = await provider.updateCreature(
        id: widget.creature!.id,
        name: _nameController.text.trim(),
        species: _speciesController.text.trim(),
        habitat: _habitatController.text.trim(),
        description: _descriptionController.text.trim(),
        imageFile: _imageFile,
        existingImageUrl: widget.creature!.imageUrl,
        discoveredBy: _discoveredByController.text.trim().isEmpty
            ? null
            : _discoveredByController.text.trim(),
        isDangerous: _isDangerous,
        rarity: _rarity,
        size: _size,
        resources: _resourcesController.text.trim().isEmpty
            ? null
            : _resourcesController.text.trim(),
        conservationStatus: _conservationStatus,
      );
    }

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.creature == null
                ? 'Creature added successfully!'
                : 'Creature updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.creature != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Creature' : 'Add Creature'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image picker
            _buildImagePicker(),
            const SizedBox(height: 24),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Creature Name *',
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Species field
            TextFormField(
              controller: _speciesController,
              decoration: const InputDecoration(
                labelText: 'Species *',
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a species';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Habitat field
            TextFormField(
              controller: _habitatController,
              decoration: const InputDecoration(
                labelText: 'Habitat *',
                prefixIcon: Icon(Icons.landscape),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a habitat';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Discovered by field
            TextFormField(
              controller: _discoveredByController,
              decoration: const InputDecoration(
                labelText: 'Discovered By (Optional)',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // Resources field (NEW)
            TextFormField(
              controller: _resourcesController,
              decoration: const InputDecoration(
                labelText: 'Resources (Optional)',
                hintText: 'e.g., Food sources, materials, medicinal uses',
                prefixIcon: Icon(Icons.inventory),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Size dropdown (NEW)
            DropdownButtonFormField<String>(
              value: _size,
              decoration: const InputDecoration(
                labelText: 'Size (Optional)',
                prefixIcon: Icon(Icons.straighten),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Not specified')),
                DropdownMenuItem(value: 'tiny', child: Text('Tiny (< 10cm)')),
                DropdownMenuItem(value: 'small', child: Text('Small (10-50cm)')),
                DropdownMenuItem(value: 'medium', child: Text('Medium (50cm-1m)')),
                DropdownMenuItem(value: 'large', child: Text('Large (1-3m)')),
                DropdownMenuItem(value: 'huge', child: Text('Huge (> 3m)')),
              ],
              onChanged: (value) {
                setState(() {
                  _size = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Conservation Status dropdown (NEW)
            DropdownButtonFormField<String>(
              value: _conservationStatus,
              decoration: const InputDecoration(
                labelText: 'Conservation Status',
                prefixIcon: Icon(Icons.eco),
              ),
              items: const [
                DropdownMenuItem(value: 'least_concern', child: Text('Least Concern')),
                DropdownMenuItem(value: 'near_threatened', child: Text('Near Threatened')),
                DropdownMenuItem(value: 'vulnerable', child: Text('Vulnerable')),
                DropdownMenuItem(value: 'endangered', child: Text('Endangered')),
                DropdownMenuItem(value: 'critically_endangered', child: Text('Critically Endangered')),
                DropdownMenuItem(value: 'extinct', child: Text('Extinct')),
              ],
              onChanged: (value) {
                setState(() {
                  _conservationStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Rarity dropdown
            DropdownButtonFormField<String>(
              value: _rarity,
              decoration: const InputDecoration(
                labelText: 'Rarity',
                prefixIcon: Icon(Icons.star),
              ),
              items: const [
                DropdownMenuItem(value: 'common', child: Text('Common')),
                DropdownMenuItem(value: 'uncommon', child: Text('Uncommon')),
                DropdownMenuItem(value: 'rare', child: Text('Rare')),
                DropdownMenuItem(value: 'legendary', child: Text('Legendary')),
              ],
              onChanged: (value) {
                setState(() {
                  _rarity = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Dangerous switch
            SwitchListTile(
              title: const Text('Dangerous Creature'),
              subtitle: const Text('Is this creature dangerous to humans?'),
              value: _isDangerous,
              onChanged: (value) {
                setState(() {
                  _isDangerous = value;
                });
              },
              secondary: Icon(
                _isDangerous ? Icons.warning : Icons.check_circle,
                color: _isDangerous ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                isEditing ? 'Update Creature' : 'Add Creature',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _imageFile != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: kIsWeb
              ? Image.network(_imageFile!.path, fit: BoxFit.cover)
              : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
        )
            : widget.creature?.imageUrl != null && _imageFile == null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            widget.creature!.imageUrl!,
            fit: BoxFit.cover,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Tap to add image',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}