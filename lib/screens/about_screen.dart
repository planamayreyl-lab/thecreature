import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionCard(),
                  const SizedBox(height: 20),
                  _buildFeaturesCard(),
                  const SizedBox(height: 20),
                  _buildPurposeCard(),
                  const SizedBox(height: 20),
                  _buildContactCard(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Image.network(
              'lib/assets/creature.png',
              width: 110,
              height: 110,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Creature Catalog',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover, Document, and Share',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'About This App',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'An educational and scientific app that provides comprehensive '
                  'information on diverse creatures from around the world. '
                  'Creature Catalog serves as a digital encyclopedia for wildlife '
                  'enthusiasts, researchers, students, and nature lovers.',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our mission is to create a centralized database where users can '
                  'explore, document, and share knowledge about various species, '
                  'their habitats, behaviors, and conservation status.',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star_outline, color: Colors.amber[700], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Key Features',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.search,
              'Advanced Search',
              'Quickly find creatures by name, species, or habitat',
              Colors.blue,
            ),
            _buildFeatureItem(
              Icons.category,
              'Rarity Classification',
              'Creatures categorized by rarity: Common, Uncommon, Rare, and Legendary',
              Colors.purple,
            ),
            _buildFeatureItem(
              Icons.image,
              'Visual Documentation',
              'High-quality images for better identification and study',
              Colors.green,
            ),
            _buildFeatureItem(
              Icons.warning_amber,
              'Safety Information',
              'Clear indicators for potentially dangerous species',
              Colors.red,
            ),
            _buildFeatureItem(
              Icons.cloud_upload,
              'Community Contributions',
              'Add and share your creature discoveries with the community',
              Colors.orange,
            ),
            _buildFeatureItem(
              Icons.filter_list,
              'Smart Filtering',
              'Filter creatures by rarity and other attributes',
              Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.explore, color: Colors.green[700], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Our Purpose',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPurposeItem(
              '🎓',
              'Educational',
              'Perfect for students, teachers, and lifelong learners',
            ),
            _buildPurposeItem(
              '🔬',
              'Scientific Research',
              'Support field research and species documentation',
            ),
            _buildPurposeItem(
              '🌍',
              'Conservation Awareness',
              'Promote awareness about biodiversity and endangered species',
            ),
            _buildPurposeItem(
              '📚',
              'Reference Library',
              'Comprehensive database for quick species identification',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposeItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_support, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Get In Touch',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Have questions, suggestions, or want to contribute? '
                  'We\'d love to hear from you!',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildContactButton(
                  context,
                  'Email',
                  Icons.email,
                  Colors.red,
                      () => _launchEmail(),
                ),
                _buildContactButton(
                  context,
                  'GitHub',
                  Icons.code,
                  Colors.black87,
                      () => _launchUrl('https://github.com'),
                ),
                _buildContactButton(
                  context,
                  'Report Issue',
                  Icons.bug_report,
                  Colors.orange,
                      () => _showFeedbackDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@creaturecatalog.com',
      query: 'subject=Creature Catalog Inquiry',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report an Issue'),
        content: const Text(
          'Thank you for helping us improve Creature Catalog!\n\n'
              'Please send your feedback to:\n'
              'support@creaturecatalog.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _launchEmail();
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }
}