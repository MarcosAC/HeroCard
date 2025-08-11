import 'item.dart';

class Hero {
  final String id;
  final String name;
  final String heroName;
  final String role;
  final String currentCampaign;
  final int currentChapter;

  // Atributos
  final int strength;
  final int agility;
  final int wisdom;
  final int maxHealth;
  final int currentHealth;
  final int maxFear;
  final int currentFear;
  final int knowledge;

  final List<Item> inventory;

  const Hero({
    required this.id,
    required this.name,
    required this.heroName,
    required this.role,
    this.currentCampaign = 'None',
    this.currentChapter = 1,
    this.strength = 0,
    this.agility = 0,
    this.wisdom = 0,
    this.maxHealth = 0,
    this.currentHealth = 0,
    this.maxFear = 0,
    this.currentFear = 0,
    this.knowledge = 0,
    this.inventory = const [],
  });

  // Converte um objeto Hero para um mapa que pode ser armazenado no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'heroName': heroName,
      'role': role,
      'currentCampaign': currentCampaign,
      'currentChapter': currentChapter,
      'strength': strength,
      'agility': agility,
      'wisdom': wisdom,
      'maxHealth': maxHealth,
      'currentHealth': currentHealth,
      'maxFear': maxFear,
      'currentFear': currentFear,
      'knowledge': knowledge,
      // O inventário será salvo em uma tabela separada e relacionado pelo ID do herói
    };
  }

  // Cria um objeto Hero a partir de um mapa lido do banco de dados
  factory Hero.fromMap(Map<String, dynamic> map, {List<Item>? inventory}) {
    return Hero(
      id: map['id'],
      name: map['name'],
      heroName: map['heroName'],
      role: map['role'],
      currentCampaign: map['currentCampaign'] ?? 'None',
      currentChapter: map['currentChapter'] ?? 1,
      strength: map['strength'] ?? 0,
      agility: map['agility'] ?? 0,
      wisdom: map['wisdom'] ?? 0,
      maxHealth: map['maxHealth'] ?? 0,
      currentHealth: map['currentHealth'] ?? 0,
      maxFear: map['maxFear'] ?? 0,
      currentFear: map['currentFear'] ?? 0,
      knowledge: map['knowledge'] ?? 0,
      inventory: inventory ?? const [], // Associa o inventário carregado separadamente
    );
  }

  // Cria uma cópia do Hero com possíveis modificações (útil para MVVM)
  Hero copyWith({
    String? id,
    String? name,
    String? heroName,
    String? role,
    String? currentCampaign,
    int? currentChapter,
    int? strength,
    int? agility,
    int? wisdom,
    int? maxHealth,
    int? currentHealth,
    int? maxFear,
    int? currentFear,
    int? knowledge,
    List<Item>? inventory,
  }) {
    return Hero(
      id: id ?? this.id,
      name: name ?? this.name,
      heroName: heroName ?? this.heroName,
      role: role ?? this.role,
      currentCampaign: currentCampaign ?? this.currentCampaign,
      currentChapter: currentChapter ?? this.currentChapter,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      wisdom: wisdom ?? this.wisdom,
      maxHealth: maxHealth ?? this.maxHealth,
      currentHealth: currentHealth ?? this.currentHealth,
      maxFear: maxFear ?? this.maxFear,
      currentFear: currentFear ?? this.currentFear,
      knowledge: knowledge ?? this.knowledge,
      inventory: inventory ?? this.inventory,
    );
  }
}