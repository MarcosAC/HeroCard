import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/hero.dart' as models;
import '../models/item.dart';

const Uuid uuid = Uuid();

class HeroDetailScreen extends StatefulWidget {
  final models.Hero? hero;

  const HeroDetailScreen({super.key, this.hero});

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late models.Hero _editingHero;

  late TextEditingController _nameController;
  late TextEditingController _heroNameController;
  late TextEditingController _roleController;
  late TextEditingController _currentCampaignController;
  late TextEditingController _currentChapterController;
  late TextEditingController _strengthController;
  late TextEditingController _agilityController;
  late TextEditingController _wisdomController;
  late TextEditingController _maxHealthController;
  late TextEditingController _currentHealthController;
  late TextEditingController _maxFearController;
  late TextEditingController _currentFearController;
  late TextEditingController _knowledgeController;

  late TextEditingController _newItemNameController;
  late TextEditingController _newItemTypeController;
  late TextEditingController _newItemDescriptionController;

  @override
  void initState() {
    super.initState();
    _editingHero = widget.hero ?? models.Hero(id: uuid.v4(), name: '', heroName: '', role: '');

    _nameController = TextEditingController(text: _editingHero.name);
    _heroNameController = TextEditingController(text: _editingHero.heroName);
    _roleController = TextEditingController(text: _editingHero.role);
    _currentCampaignController = TextEditingController(text: _editingHero.currentCampaign);
    _currentChapterController = TextEditingController(text: _editingHero.currentChapter.toString());
    _strengthController = TextEditingController(text: _editingHero.strength.toString());
    _agilityController = TextEditingController(text: _editingHero.agility.toString());
    _wisdomController = TextEditingController(text: _editingHero.wisdom.toString());
    _maxHealthController = TextEditingController(text: _editingHero.maxHealth.toString());
    _currentHealthController = TextEditingController(text: _editingHero.currentHealth.toString());
    _maxFearController = TextEditingController(text: _editingHero.maxFear.toString());
    _currentFearController = TextEditingController(text: _editingHero.currentFear.toString());
    _knowledgeController = TextEditingController(text: _editingHero.knowledge.toString());

    _newItemNameController = TextEditingController();
    _newItemTypeController = TextEditingController();
    _newItemDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heroNameController.dispose();
    _roleController.dispose();
    _currentCampaignController.dispose();
    _currentChapterController.dispose();
    _strengthController.dispose();
    _agilityController.dispose();
    _wisdomController.dispose();
    _maxHealthController.dispose();
    _currentHealthController.dispose();
    _maxFearController.dispose();
    _currentFearController.dispose();
    _knowledgeController.dispose();
    _newItemNameController.dispose();
    _newItemTypeController.dispose();
    _newItemDescriptionController.dispose();
    super.dispose();
  }

  void _prepareAndReturnHero() {
    if (_formKey.currentState!.validate()) {
      _editingHero = _editingHero.copyWith(
        name: _nameController.text,
        heroName: _heroNameController.text,
        role: _roleController.text,
        currentCampaign: _currentCampaignController.text,
        currentChapter: int.tryParse(_currentChapterController.text) ?? 1,
        strength: int.tryParse(_strengthController.text) ?? 0,
        agility: int.tryParse(_agilityController.text) ?? 0,
        wisdom: int.tryParse(_wisdomController.text) ?? 0,
        maxHealth: int.tryParse(_maxHealthController.text) ?? 0,
        currentHealth: int.tryParse(_currentHealthController.text) ?? 0,
        maxFear: int.tryParse(_maxFearController.text) ?? 0,
        currentFear: int.tryParse(_currentFearController.text) ?? 0,
        knowledge: int.tryParse(_knowledgeController.text) ?? 0,
      );

      Navigator.pop(context, _editingHero);
    }
  }

  void _showAddItemDialog() {
    _newItemNameController.clear();
    _newItemTypeController.clear();
    _newItemDescriptionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _newItemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newItemTypeController,
                decoration: const InputDecoration(labelText: 'Type (e.g., Weapon, Armor)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
              TextField(
                controller: _newItemDescriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (_newItemNameController.text.isNotEmpty &&
                    _newItemTypeController.text.isNotEmpty) {
                  final newItem = Item(
                    id: uuid.v4(), // Uses the UUID generator
                    name: _newItemNameController.text,
                    type: _newItemTypeController.text,
                    description: _newItemDescriptionController.text.isEmpty
                        ? null
                        : _newItemDescriptionController.text,
                  );

                  setState(() {
                    _editingHero = _editingHero.copyWith(
                      inventory: List.from(_editingHero.inventory)..add(newItem),
                    );
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item Name and Type are required.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removeItemFromLocalList(Item item) {
    setState(() {
      _editingHero = _editingHero.copyWith(
        inventory: List.from(_editingHero.inventory)..removeWhere((i) => i.id == item.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hero == null ? 'New Hero' : 'Edit Hero'),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _prepareAndReturnHero,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Basic Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Hero Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hero\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heroNameController,
                decoration: const InputDecoration(labelText: 'Hero Type (e.g., Aragorn)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Hero Type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role (e.g., Bard)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hero\'s role';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _currentCampaignController,
                decoration: const InputDecoration(labelText: 'Current Campaign'),
              ),
              TextFormField(
                controller: _currentChapterController,
                decoration: const InputDecoration(labelText: 'Current Chapter'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text(
                'Attributes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _strengthController,
                      decoration: const InputDecoration(labelText: 'Strength'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _agilityController,
                      decoration: const InputDecoration(labelText: 'Agility'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _wisdomController,
                      decoration: const InputDecoration(labelText: 'Wisdom'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxHealthController,
                      decoration: const InputDecoration(labelText: 'Max Health'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _currentHealthController,
                      decoration: const InputDecoration(labelText: 'Current Health'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxFearController,
                      decoration: const InputDecoration(labelText: 'Max Fear'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _currentFearController,
                      decoration: const InputDecoration(labelText: 'Current Fear'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _knowledgeController,
                decoration: const InputDecoration(labelText: 'Knowledge'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inventory',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddItemDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const Divider(),
              _editingHero.inventory.isEmpty
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No items in inventory.'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _editingHero.inventory.length,
                itemBuilder: (context, index) {
                  final item = _editingHero.inventory[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.type} ${item.description != null ? ' - ${item.description}' : ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItemFromLocalList(item),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              Text(
                'Skill Deck (To be implemented)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const Text('Here you can add the logic and UI to manage the hero\'s skill deck.'),
              const SizedBox(height: 16),
              Text(
                'Special Abilities/Titles (To be implemented)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const Text('Here you can add hero abilities and acquired titles.'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _prepareAndReturnHero,
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}