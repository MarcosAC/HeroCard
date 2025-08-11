import 'package:flutter/material.dart';
import '../models/hero.dart' as models;
import '../viewmodels/hero_viewmodel.dart';
import 'hero_detail_screen.dart';

class HeroListScreen extends StatefulWidget {
  final HeroViewModel viewModel; // The ViewModel will be passed to the View

  const HeroListScreen({super.key, required this.viewModel});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  // This screen's UI will observe changes in the ViewModel's ValueNotifiers.

  // Navigates to the detail screen to create or edit a hero
  void _navigateToHeroDetail({models.Hero? hero}) async { // <<< Usando models.Hero
    final models.Hero? result = await Navigator.push( // <<< Usando models.Hero
      context,
      MaterialPageRoute(
        builder: (context) => HeroDetailScreen(hero: hero),
      ),
    );

    // If there's a result, the ViewModel is notified to persist the change
    if (result != null) {
      if (hero == null) {
        widget.viewModel.addHero(result); // Add new hero
      } else {
        widget.viewModel.updateHero(result); // Update existing hero
      }
    }
  }

  // Deletes a hero
  void _deleteHero(String heroId, String heroName) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "$heroName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Trigger the delete action in the ViewModel
      widget.viewModel.deleteHero(heroId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$heroName" deleted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journeys in Middle-earth: Heroes'),
        backgroundColor: Colors.brown[800],
      ),
      // ValueListenableBuilder to observe the loading state
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.viewModel.isLoadingListenable,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // ValueListenableBuilder to observe the list of heroes
          return ValueListenableBuilder<List<models.Hero>>( // <<< Usando models.Hero
            valueListenable: widget.viewModel.heroesListenable,
            builder: (context, heroes, child) {
              if (heroes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No heroes found.\nCreate a new one to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: heroes.length,
                  itemBuilder: (context, index) {
                    final hero = heroes[index]; // <<< hero agora é models.Hero
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown[600],
                          child: Text(
                            hero.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          hero.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Hero: ${hero.heroName} | Role: ${hero.role}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _navigateToHeroDetail(hero: hero),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteHero(hero.id, hero.name),
                            ),
                          ],
                        ),
                        onTap: () =>
                            _navigateToHeroDetail(hero: hero),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToHeroDetail(), // Opens to create new hero
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}