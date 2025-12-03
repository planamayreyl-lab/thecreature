import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catalogsforcreatureapps/models/creature.dart';
import 'package:catalogsforcreatureapps/providers/creature_provider.dart';
import 'package:catalogsforcreatureapps/screens/add_creature_screen.dart';
import 'package:catalogsforcreatureapps/screens/creature_details_screen.dart';
import 'package:catalogsforcreaturtureapps/widgeteapps/screens/about_screen.dart';
import 'package:catalogsforcreas/creature_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreatureProvider>().loadCreatures();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creature Catalog'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<CreatureProvider>().loadCreatures();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Consumer<CreatureProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.creatures.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null && provider.creatures.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadCreatures(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.creatures.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No creatures found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first creature',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadCreatures(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.creatures.length,
                    itemBuilder: (context, index) {
                      final creature = provider.creatures[index];
                      return CreatureCard(
                        creature: creature,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreatureDetailScreen(creature: creature),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCreatureScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Creature'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search creatures...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              context.read<CreatureProvider>().setSearchQuery(value);
            },
          ),
          const SizedBox(height: 12),
          Consumer<CreatureProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      'All',
                      'all',
                      provider.filterRarity == 'all',
                      provider,
                    ),
                    _buildFilterChip(
                      'Common',
                      'common',
                      provider.filterRarity == 'common',
                      provider,
                    ),
                    _buildFilterChip(
                      'Uncommon',
                      'uncommon',
                      provider.filterRarity == 'uncommon',
                      provider,
                    ),
                    _buildFilterChip(
                      'Rare',
                      'rare',
                      provider.filterRarity == 'rare',
                      provider,
                    ),
                    _buildFilterChip(
                      'Legendary',
                      'legendary',
                      provider.filterRarity == 'legendary',
                      provider,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label,
      String value,
      bool isSelected,
      CreatureProvider provider,
      ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          provider.setFilterRarity(selected ? value : 'all');
        },
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
    );
  }
}
