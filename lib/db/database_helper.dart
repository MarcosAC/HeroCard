import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/hero.dart';
import '../models/item.dart';
import '../models/skillcard.dart';
import '../models/specialability.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'journeys_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE heroes(
        id TEXT PRIMARY KEY,
        name TEXT,
        heroName TEXT,
        role TEXT,
        currentCampaign TEXT,
        currentChapter INTEGER,
        strength INTEGER,
        agility INTEGER,
        wisdom INTEGER,
        maxHealth INTEGER,
        currentHealth INTEGER,
        maxFear INTEGER,
        currentFear INTEGER,
        knowledge INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE items(
        id TEXT PRIMARY KEY,
        heroId TEXT,
        name TEXT,
        type TEXT,
        description TEXT,
        FOREIGN KEY (heroId) REFERENCES heroes(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE skill_cards(
        id TEXT PRIMARY KEY,
        heroId TEXT,
        name TEXT,
        description TEXT,
        FOREIGN KEY (heroId) REFERENCES heroes(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE special_abilities(
        id TEXT PRIMARY KEY,
        heroId TEXT,
        name TEXT,
        type TEXT,
        description TEXT,
        FOREIGN KEY (heroId) REFERENCES heroes(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> insertHero(Hero hero) async {
    final db = await database;

    await db.insert(
      'heroes',
      hero.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var item in hero.inventory) {
      await insertItem(item, hero.id);
    }

    for (var skillCard in hero.skillDeck) {
      await insertSkillCard(skillCard, hero.id);
    }

    for (var specialAbility in hero.specialAbilities) {
      await insertSpecialAbility(specialAbility, hero.id);
    }
  }

  Future<void> updateHero(Hero hero) async {
    final db = await database;

    await db.update(
      'heroes',
      hero.toMap(),
      where: 'id = ?',
      whereArgs: [hero.id],
    );

    await deleteItemsByHeroId(hero.id);

    for (var item in hero.inventory) {
      await insertItem(item, hero.id);
    }

    await deleteSkillCardsByHeroId(hero.id);

    for (var skillCard in hero.skillDeck) {
      await insertSkillCard(skillCard, hero.id);
    }

    await deleteSpecialAbilitiesByHeroId(hero.id);

    for (var specialAbility in hero.specialAbilities) {
      await insertSpecialAbility(specialAbility, hero.id);
    }
  }

  Future<void> deleteHero(String id) async {
    final db = await database;

    await db.delete(
      'heroes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Hero>> getHeroes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('heroes');

    return Future.wait(maps.map((map) async {
      final inventory = await getItemsByHeroId(map['id']);
      final skillDeck = await getSkillCardsByHeroId(map['id']);
      final specialAbilities = await getSpecialAbilitiesByHeroId(map['id']);

      return Hero.fromMap(map,
          inventory: inventory,
          skillDeck: skillDeck,
          specialAbilities: specialAbilities);
    }).toList());
  }

  Future<void> insertItem(Item item, String heroId) async {
    final db = await database;

    await db.insert(
      'items',
      {...item.toMap(), 'heroId': heroId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(String itemId) async {
    final db = await database;

    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<void> deleteItemsByHeroId(String heroId) async {
    final db = await database;

    await db.delete(
      'items',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );
  }

  Future<List<Item>> getItemsByHeroId(String heroId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<void> insertSkillCard(SkillCard skillCard, String heroId) async {
    final db = await database;
    await db.insert(
      'skill_cards',
      {...skillCard.toMap(), 'heroId': heroId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSkillCard(String skillCardId) async {
    final db = await database;

    await db.delete(
      'skill_cards',
      where: 'id = ?',
      whereArgs: [skillCardId],
    );
  }

  Future<void> deleteSkillCardsByHeroId(String heroId) async {
    final db = await database;

    await db.delete(
      'skill_cards',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );
  }

  Future<List<SkillCard>> getSkillCardsByHeroId(String heroId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'skill_cards',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );

    return List.generate(maps.length, (i) {
      return SkillCard.fromMap(maps[i]);
    });
  }

  Future<void> insertSpecialAbility(SpecialAbility specialAbility, String heroId) async {
    final db = await database;

    await db.insert(
      'special_abilities',
      {...specialAbility.toMap(), 'heroId': heroId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSpecialAbility(String abilityId) async {
    final db = await database;
    await db.delete(
      'special_abilities',
      where: 'id = ?',
      whereArgs: [abilityId],
    );
  }

  Future<void> deleteSpecialAbilitiesByHeroId(String heroId) async {
    final db = await database;
    await db.delete(
      'special_abilities',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );
  }

  Future<List<SpecialAbility>> getSpecialAbilitiesByHeroId(String heroId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'special_abilities',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );

    return List.generate(maps.length, (i) {
      return SpecialAbility.fromMap(maps[i]);
    });
  }
}