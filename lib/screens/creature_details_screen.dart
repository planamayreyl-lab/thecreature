import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:catalogsforcreatureapps/models/creature.dart';
import 'package:catalogsforcreatureapps/providers/creature_provider.dart';
import 'package:catalogsforcreatureapps/screens/add_creature_screen.dart';

class CreatureDetailScreen extends StatelessWidget {
  final Creature creature;

  const CreatureDetailScreen({super.key, required this.creature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildInfoCard(context),
                  const SizedBox(height: 16),
                  _buildDescriptionCard(),
                  if (creature.resources != null) ...[
                    const SizedBox(height: 16),
                    _buildResourcesCard(),
                  ],
                  const SizedBox(height: 16),
                  _buildMetadataCard(),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: creature.imageUrl != null
            ? Image.network(
          creature.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.pets, size: 100, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                creature.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildRarityBadge(),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          creature.species,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildRarityBadge() {
    Color color;
    IconData icon;

    switch (creature.rarity) {
      case 'legendary':
        color = Colors.deepPurple;
        icon = Icons.auto_awesome;
        break;
      case 'rare':
        color = Colors.blue;
        icon = Icons.star;
        break;
      case 'uncommon':
        color = Colors.green;
        icon = Icons.star_half;
        break;
      default:
        color = Colors.grey;
        icon = Icons.star_border;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            creature.rarity.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.landscape,
              'Habitat',
              creature.habitat,
              Theme.of(context).colorScheme.primary,
            ),
            if (creature.size != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.straighten,
                'Size',
                _formatSize(creature.size!),
                Colors.orange,
              ),
            ],
            const Divider(height: 24),
            _buildInfoRow(
              creature.isDangerous ? Icons.warning : Icons.check_circle,
              'Status',
              creature.isDangerous ? 'Dangerous' : 'Safe',
              creature.isDangerous ? Colors.red : Colors.green,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.eco,
              'Conservation',
              _formatConservationStatus(creature.conservationStatus),
              _getConservationColor(creature.conservationStatus),
            ),
            if (creature.discoveredBy != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.person,
                'Discovered By',
                creature.discoveredBy!,
                Colors.blueGrey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatSize(String size) {
    switch (size) {
      case 'tiny':
        return 'Tiny (< 10cm)';
      case 'small':
        return 'Small (10-50cm)';
      case 'medium':
        return 'Medium (50cm-1m)';
      case 'large':
        return 'Large (1-3m)';
      case 'huge':
        return 'Huge (> 3m)';
      default:
        return size;
    }
  }

  String _formatConservationStatus(String status) {
    return status.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getConservationColor(String status) {
    switch (status) {
      case 'least_concern':
        return Colors.green;
      case 'near_threatened':
        return Colors.lightGreen;
      case 'vulnerable':
        return Colors.yellow.shade700;
      case 'endangered':
        return Colors.orange;
      case 'critically_endangered':
        return Colors.red;
      case 'extinct':
        return Colors.grey.shade700;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.grey[700]),
                const SizedBox(width: 8),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              creature.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory, color: Colors.grey[700]),
                const SizedBox(width: 8),
                const Text(
                  'Resources',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              creature.resources!,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Added ${dateFormat.format(creature.createdAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCreatureScreen(creature: creature),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Creature'),
        content: Text(
          'Are you sure you want to delete "${creature.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              final provider = context.read<CreatureProvider>();
              final success = await provider.deleteCreature(
                creature.id,
                creature.imageUrl,
              );

              if (context.mounted) {
                Navigator.pop(context); // Close detail screen

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Creature deleted successfully'
                          : 'Failed to delete creature',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}