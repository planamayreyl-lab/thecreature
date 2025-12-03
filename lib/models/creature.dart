class Creature {
  final String id;
  final String name;
  final String species;
  final String habitat;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final String? discoveredBy;
  final bool isDangerous;
  final String rarity; // common, uncommon, rare, legendary
  final String? size; // tiny, small, medium, large, huge
  final String? resources; // food sources, materials, etc.
  final String conservationStatus; // least_concern, near_threatened, vulnerable, endangered, critically_endangered, extinct

  Creature({
    required this.id,
    required this.name,
    required this.species,
    required this.habitat,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.discoveredBy,
    this.isDangerous = false,
    this.rarity = 'common',
    this.size,
    this.resources,
    this.conservationStatus = 'least_concern',
  });

  factory Creature.fromJson(Map<String, dynamic> json) {
    return Creature(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      habitat: json['habitat'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      discoveredBy: json['discovered_by'] as String?,
      isDangerous: json['is_dangerous'] as bool? ?? false,
      rarity: json['rarity'] as String? ?? 'common',
      size: json['size'] as String?,
      resources: json['resources'] as String?,
      conservationStatus: json['conservation_status'] as String? ?? 'least_concern',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'habitat': habitat,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'discovered_by': discoveredBy,
      'is_dangerous': isDangerous,
      'rarity': rarity,
      'size': size,
      'resources': resources,
      'conservation_status': conservationStatus,
    };
  }

  Creature copyWith({
    String? id,
    String? name,
    String? species,
    String? habitat,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    String? discoveredBy,
    bool? isDangerous,
    String? rarity,
    String? size,
    String? resources,
    String? conservationStatus,
  }) {
    return Creature(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      habitat: habitat ?? this.habitat,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      discoveredBy: discoveredBy ?? this.discoveredBy,
      isDangerous: isDangerous ?? this.isDangerous,
      rarity: rarity ?? this.rarity,
      size: size ?? this.size,
      resources: resources ?? this.resources,
      conservationStatus: conservationStatus ?? this.conservationStatus,
    );
  }
}