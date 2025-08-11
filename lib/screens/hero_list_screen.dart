import 'package:flutter/material.dart';
import '../models/hero.dart' as models;
import '../viewmodels/hero_viewmodel.dart';
import 'hero_detail_screen.dart';

class HeroListScreen extends StatefulWidget {
  final HeroViewModel viewModel;

  const HeroListScreen({super.key, required this.viewModel});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  void _navigateToHeroDetail({models.Hero? hero}) async {
    final models.Hero? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeroDetailScreen(hero: hero),
      ),
    );

    if (result != null) {
      if (hero == null) {
        widget.viewModel.addHero(result);
      } else {
        widget.viewModel.updateHero(result);
      }
    }
  }

  void _deleteHero(String heroId, String heroName) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Tem certeza de que deseja excluir "$heroName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      widget.viewModel.deleteHero(heroId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$heroName" excluído!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jornadas na Terra-média: Heróis'),
        backgroundColor: Colors.brown[800],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.viewModel.isLoadingListenable,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ValueListenableBuilder<List<models.Hero>>(
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
                        'Nenhum herói encontrado.\nCrie um novo para começar!',
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
                    final hero = heroes[index];
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
        onPressed: () => _navigateToHeroDetail(),
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}