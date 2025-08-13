import 'package:flutter/foundation.dart';
import '../models/hero.dart';
import '../db/database_helper.dart';
import '../models/item.dart';
import '../models/skillcard.dart';
import '../models/specialability.dart';

class HeroViewModel {
  final DatabaseHelper _databaseHelper;

  final ValueNotifier<List<Hero>> _heroesNotifier = ValueNotifier([]);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<String?> _errorMessageNotifier = ValueNotifier(null);

  ValueListenable<List<Hero>> get heroesListenable => _heroesNotifier;
  ValueListenable<bool> get isLoadingListenable => _isLoadingNotifier;
  ValueListenable<String?> get errorMessageListenable => _errorMessageNotifier;

  HeroViewModel({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper {
    loadHeroes();
  }

  Future<void> loadHeroes() async {
    _isLoadingNotifier.value = true;
    _errorMessageNotifier.value = null;

    try {
      final loadedHeroes = await _databaseHelper.getHeroes();
      _heroesNotifier.value = loadedHeroes;
    } catch (e) {
      _errorMessageNotifier.value = 'Error loading heroes: $e';
      debugPrint('Error loading heroes: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  Future<void> addHero(Hero hero) async {
    _isLoadingNotifier.value = true;
    _errorMessageNotifier.value = null;

    try {
      await _databaseHelper.insertHero(hero);
      await loadHeroes();
    } catch (e) {
      _errorMessageNotifier.value = 'Error adding hero: $e';
      debugPrint('Error adding hero: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  Future<void> updateHero(Hero hero) async {
    _isLoadingNotifier.value = true;
    _errorMessageNotifier.value = null;

    try {
      await _databaseHelper.updateHero(hero);
      await loadHeroes();
    } catch (e) {
      _errorMessageNotifier.value = 'Error updating hero: $e';
      debugPrint('Error updating hero: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  Future<void> deleteHero(String id) async {
    _isLoadingNotifier.value = true;
    _errorMessageNotifier.value = null;

    try {
      await _databaseHelper.deleteHero(id);
      await loadHeroes();
    } catch (e) {
      _errorMessageNotifier.value = 'Error deleting hero: $e';
      debugPrint('Error deleting hero: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  Future<void> addItemToHero(String heroId, Item item) async {
    final heroIndex = _heroesNotifier.value.indexWhere((h) => h.id == heroId);
    if (heroIndex == -1) {
      _errorMessageNotifier.value = 'Hero not found to add item.';
      return;
    }

    final currentHero = _heroesNotifier.value[heroIndex];
    final newInventory = List<Item>.from(currentHero.inventory)..add(item);
    final updatedHero = currentHero.copyWith(inventory: newInventory);

    await updateHero(updatedHero);
  }

  Future<void> removeItemFromHero(String heroId, String itemId) async {
    final heroIndex = _heroesNotifier.value.indexWhere((h) => h.id == heroId);
    if (heroIndex == -1) {
      _errorMessageNotifier.value = 'Hero not found to remove item.';
      return;
    }

    final currentHero = _heroesNotifier.value[heroIndex];
    final newInventory = List<Item>.from(currentHero.inventory)
      ..removeWhere((item) => item.id == itemId);

    final updatedHero = currentHero.copyWith(inventory: newInventory);

    await updateHero(updatedHero);
  }

  Future<void> addSkillCardToHero(String heroId, SkillCard skillCard) async {
    final heroIndex = _heroesNotifier.value.indexWhere((h) => h.id == heroId);
    if (heroIndex == -1) {
      _errorMessageNotifier.value = 'Hero not found to add skill card.';
      return;
    }

    final currentHero = _heroesNotifier.value[heroIndex];
    final newSkillDeck = List<SkillCard>.from(currentHero.skillDeck)..add(skillCard);
    final updatedHero = currentHero.copyWith(skillDeck: newSkillDeck);

    await updateHero(updatedHero);
  }

  Future<void> removeSkillCardFromHero(String heroId, String skillCardId) async {
    final heroIndex = _heroesNotifier.value.indexWhere((h) => h.id == heroId);
    if (heroIndex == -1) {
      _errorMessageNotifier.value = 'Hero not found to remove skill card.';
      return;
    }

    final currentHero = _heroesNotifier.value[heroIndex];
    final newSkillDeck = List<SkillCard>.from(currentHero.skillDeck)
      ..removeWhere((skill) => skill.id == skillCardId);
    final updatedHero = currentHero.copyWith(skillDeck: newSkillDeck);

    await updateHero(updatedHero);
  }

  Future<void> addSpecialAbilityToHero(String heroId, SpecialAbility ability) async {
    final heroIndex = _heroesNotifier.value.indexWhere((h) => h.id == heroId);
    if (heroIndex == -1) {
      _errorMessageNotifier.value = 'Hero not found to add special ability.';
      return;
    }

    final currentHero = _heroesNotifier.value[heroIndex];
    final newAbilities = List<SpecialAbility>.from(currentHero.specialAbilities)..add(ability);
    final updatedHero = currentHero.copyWith(specialAbilities: newAbilities);

    await updateHero(updatedHero);
  }

  Future<void> removeSpecialAbilityFromHero(String heroId, String abilityId) async {
    final heroIndex = _heroesNotifier.value.indexWhere((h) => h.id == heroId);
    if (heroIndex == -1) {
      _errorMessageNotifier.value = 'Hero not found to remove special ability.';
      return;
    }

    final currentHero = _heroesNotifier.value[heroIndex];
    final newAbilities = List<SpecialAbility>.from(currentHero.specialAbilities)
      ..removeWhere((ability) => ability.id == abilityId);
    final updatedHero = currentHero.copyWith(specialAbilities: newAbilities);

    await updateHero(updatedHero);
  }

  void dispose() {
    _heroesNotifier.dispose();
    _isLoadingNotifier.dispose();
    _errorMessageNotifier.dispose();
  }
}