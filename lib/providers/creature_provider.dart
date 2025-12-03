import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:catalogsforcreatureapps/models/creature.dart';

class CreatureProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Creature> _creatures = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _filterRarity = 'all';

  List<Creature> get creatures {
    var filtered = _creatures;

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) =>
      c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.species.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply rarity filter
    if (_filterRarity != 'all') {
      filtered = filtered.where((c) => c.rarity == _filterRarity).toList();
    }

    return filtered;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get filterRarity => _filterRarity;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterRarity(String rarity) {
    _filterRarity = rarity;
    notifyListeners();
  }

  Future<void> loadCreatures() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('creatures')
          .select()
          .order('created_at', ascending: false);

      // Handle the response properly
      if (response is List) {
        _creatures = response
            .map((json) => Creature.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _creatures = [];
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to load creatures: $e';
      _creatures = [];
      print('Error loading creatures: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCreature({
    required String name,
    required String species,
    required String habitat,
    required String description,
    XFile? imageFile,
    String? discoveredBy,
    bool isDangerous = false,
    String rarity = 'common',
    String? size,
    String? resources,
    String conservationStatus = 'least_concern',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final creatureId = const Uuid().v4();
      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        final fileExt = imageFile.name.split('.').last;
        final fileName = '$creatureId.$fileExt';
        final filePath = 'creature_images/$fileName';

        await _supabase.storage
            .from('creatures')
            .uploadBinary(filePath, bytes);

        imageUrl = _supabase.storage
            .from('creatures')
            .getPublicUrl(filePath);
      }

      // Insert creature data
      final creatureData = {
        'id': creatureId,
        'name': name,
        'species': species,
        'habitat': habitat,
        'description': description,
        'image_url': imageUrl,
        'discovered_by': discoveredBy,
        'is_dangerous': isDangerous,
        'rarity': rarity,
        'size': size,
        'resources': resources,
        'conservation_status': conservationStatus,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('creatures').insert(creatureData);

      // Reload creatures
      await loadCreatures();
      return true;
    } catch (e) {
      _error = 'Failed to add creature: $e';
      print('Error adding creature: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCreature({
    required String id,
    required String name,
    required String species,
    required String habitat,
    required String description,
    XFile? imageFile,
    String? existingImageUrl,
    String? discoveredBy,
    bool isDangerous = false,
    String rarity = 'common',
    String? size,
    String? resources,
    String conservationStatus = 'least_concern',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? imageUrl = existingImageUrl;

      // Upload new image if provided
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        final fileExt = imageFile.name.split('.').last;
        final fileName = '$id.$fileExt';
        final filePath = 'creature_images/$fileName';

        // Delete old image if exists
        if (existingImageUrl != null) {
          try {
            final oldPath = existingImageUrl.split('/').last;
            await _supabase.storage
                .from('creatures')
                .remove(['creature_images/$oldPath']);
          } catch (e) {
            print('Error deleting old image: $e');
          }
        }

        await _supabase.storage
            .from('creatures')
            .uploadBinary(filePath, bytes);

        imageUrl = _supabase.storage
            .from('creatures')
            .getPublicUrl(filePath);
      }

      // Update creature data
      final creatureData = {
        'name': name,
        'species': species,
        'habitat': habitat,
        'description': description,
        'image_url': imageUrl,
        'discovered_by': discoveredBy,
        'is_dangerous': isDangerous,
        'rarity': rarity,
        'size': size,
        'resources': resources,
        'conservation_status': conservationStatus,
      };

      await _supabase
          .from('creatures')
          .update(creatureData)
          .eq('id', id);

      // Reload creatures
      await loadCreatures();
      return true;
    } catch (e) {
      _error = 'Failed to update creature: $e';
      print('Error updating creature: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCreature(String id, String? imageUrl) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Delete image if exists
      if (imageUrl != null) {
        try {
          final path = imageUrl.split('/').last;
          await _supabase.storage
              .from('creatures')
              .remove(['creature_images/$path']);
        } catch (e) {
          print('Error deleting image: $e');
        }
      }

      // Delete creature data
      await _supabase.from('creatures').delete().eq('id', id);

      // Reload creatures
      await loadCreatures();
      return true;
    } catch (e) {
      _error = 'Failed to delete creature: $e';
      print('Error deleting creature: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}