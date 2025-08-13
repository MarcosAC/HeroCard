import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/hero.dart' as models;
import '../models/item.dart';
import '../models/skillcard.dart';
import '../models/specialability.dart';

const Uuid uuid = Uuid();

class HeroDetailScreen extends StatefulWidget {
  final models.Hero? hero;
  final SkillCard? skillCard;
  final SpecialAbility? specialAbility;

  const HeroDetailScreen({super.key, this.hero, this.skillCard, this.specialAbility});

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

  late TextEditingController _newSkillNameController;
  late TextEditingController _newSkillDescriptionController;

  late TextEditingController _newAbilityNameController;
  late TextEditingController _newAbilityTypeController;
  late TextEditingController _newAbilityDescriptionController;

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

    _newSkillNameController = TextEditingController();
    _newSkillDescriptionController = TextEditingController();

    _newAbilityNameController = TextEditingController();
    _newAbilityTypeController = TextEditingController();
    _newAbilityDescriptionController = TextEditingController();
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
          title: const Text('Adicionar novo item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _newItemNameController,
                decoration: const InputDecoration(labelText: 'Nome do item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newItemTypeController,
                decoration: const InputDecoration(labelText: 'Tipo (por exemplo, arma, armadura)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newItemDescriptionController,
                decoration: const InputDecoration(labelText: 'Descrição (Opcional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (_newItemNameController.text.isNotEmpty &&
                    _newItemTypeController.text.isNotEmpty) {
                  final newItem = Item(
                    id: uuid.v4(),
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
                    const SnackBar(content: Text('Nome e tipo do item são obrigatórios.')),
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

  void _showAddSkillCardDialog() {
    _newSkillNameController.clear();
    _newSkillDescriptionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Skill Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _newSkillNameController,
                decoration: const InputDecoration(labelText: 'Skill Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
              TextField(
                controller: _newSkillDescriptionController,
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
                if (_newSkillNameController.text.isNotEmpty) {
                  final newSkill = SkillCard(
                    id: uuid.v4(),
                    name: _newSkillNameController.text,
                    description: _newSkillDescriptionController.text.isEmpty
                        ? null
                        : _newSkillDescriptionController.text,
                  );

                  setState(() {
                    _editingHero = _editingHero.copyWith(
                      skillDeck: List.from(_editingHero.skillDeck)..add(newSkill),
                    );
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Skill Name is required.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removeSkillCardFromLocalList(SkillCard skillCard) {
    setState(() {
      _editingHero = _editingHero.copyWith(
        skillDeck: List.from(_editingHero.skillDeck)..removeWhere((s) => s.id == skillCard.id),
      );
    });
  }

  void _showAddSpecialAbilityDialog() {
    _newAbilityNameController.clear();
    _newAbilityTypeController.clear();
    _newAbilityDescriptionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Special Ability/Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _newAbilityNameController,
                decoration: const InputDecoration(labelText: 'Ability/Title Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newAbilityTypeController,
                decoration: const InputDecoration(labelText: 'Type (e.g., Ability, Title)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newAbilityDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
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
                if (_newAbilityNameController.text.isNotEmpty &&
                    _newAbilityTypeController.text.isNotEmpty &&
                    _newAbilityDescriptionController.text.isNotEmpty) {
                  final newAbility = SpecialAbility(
                    id: uuid.v4(),
                    name: _newAbilityNameController.text,
                    type: _newAbilityTypeController.text,
                    description: _newAbilityDescriptionController.text,
                  );

                  setState(() {
                    _editingHero = _editingHero.copyWith(
                      specialAbilities: List.from(_editingHero.specialAbilities)..add(newAbility),
                    );
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields for Special Ability/Title are required.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removeSpecialAbilityFromLocalList(SpecialAbility ability) {
    setState(() {
      _editingHero = _editingHero.copyWith(
        specialAbilities: List.from(_editingHero.specialAbilities)..removeWhere((a) => a.id == ability.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hero == null ? 'Novo Herói': 'Editar Herói'),
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
            children: [
              Text(
                'Informações Básicas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do herói'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do herói';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heroNameController,
                decoration: const InputDecoration(labelText: 'Tipo de herói (por exemplo, Aragorn)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo de herói';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Papel (por exemplo, Bardo)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o papel do herói';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentCampaignController,
                decoration: const InputDecoration(labelText: 'Campanha atual'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentChapterController,
                decoration: const InputDecoration(labelText: 'Capítulo Atual'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Atributos ---
              Text(
                'Atributos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _strengthController,
                      decoration: const InputDecoration(labelText: 'Força'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _agilityController,
                      decoration: const InputDecoration(labelText: 'Agilidade'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _wisdomController,
                      decoration: const InputDecoration(labelText: 'Sabedoria'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxHealthController,
                      decoration: const InputDecoration(labelText: 'Saúde máxima'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _currentHealthController,
                      decoration: const InputDecoration(labelText: 'Saúde Atual'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxFearController,
                      decoration: const InputDecoration(labelText: 'Medo máximo'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _currentFearController,
                      decoration: const InputDecoration(labelText: 'Medo Atual'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _knowledgeController,
                decoration: const InputDecoration(labelText: 'Conhecimento'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Número inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Inventário ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inventário',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddItemDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar item'),
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
                child: Text('Nenhum item no inventário.'),
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

              // --- Baralho de Habilidades ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skill Deck',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddSkillCardDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Skill Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              _editingHero.skillDeck.isEmpty
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No skill cards in the deck.'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _editingHero.skillDeck.length,
                itemBuilder: (context, index) {
                  final skill = _editingHero.skillDeck[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(skill.name),
                      subtitle: Text(skill.description ?? 'No description'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSkillCardFromLocalList(skill),
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              const SizedBox(height: 24),

              // --- Special Abilities/Titles ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Special Abilities/Titles',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddSpecialAbilityDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Ability/Title'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              //const SizedBox(height: 16),
              const Divider(),
              _editingHero.specialAbilities.isEmpty
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No special abilities or titles.'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _editingHero.specialAbilities.length,
                itemBuilder: (context, index) {
                  final ability = _editingHero.specialAbilities[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(ability.name),
                      subtitle: Text('${ability.type}: ${ability.description}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSpecialAbilityFromLocalList(ability),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
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