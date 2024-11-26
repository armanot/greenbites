import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealPlanProvider with ChangeNotifier {
  Map<String, Map<String, String>> _mealPlan = {};
  final List<Map<String, dynamic>> _groceryList = [];

  Map<String, Map<String, String>> get mealPlan => _mealPlan;
  List<Map<String, dynamic>> get groceryList => _groceryList;

  // Load meal plan and grocery list from local storage
  Future<void> loadMealPlan() async {
    final prefs = await SharedPreferences.getInstance();

    // Load meal plan
    final String? savedPlan = prefs.getString('mealPlan');
    if (savedPlan != null) {
      _mealPlan = Map<String, Map<String, String>>.from(jsonDecode(savedPlan));
    }

    // Load grocery list
    final String? savedGroceryList = prefs.getString('groceryList');
    if (savedGroceryList != null) {
      _groceryList
        ..clear()
        ..addAll(List<Map<String, dynamic>>.from(jsonDecode(savedGroceryList)));
    }

    notifyListeners();
  }

  // Save meal plan and grocery list to local storage
  Future<void> saveMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mealPlan', jsonEncode(_mealPlan));
  }

  Future<void> saveGroceryList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('groceryList', jsonEncode(_groceryList));
  }

  // Add a meal to the plan
  void addMeal(String day, String mealType, String meal) {
    _mealPlan.putIfAbsent(day, () => {});
    _mealPlan[day]![mealType] = meal;
    saveMealPlan(); // Persist changes
    notifyListeners();
  }

  // Get a meal for a specific day and meal type
  String? getMeal(String day, String mealType) {
    return _mealPlan[day]?[mealType];
  }

  // Clear the meal plan
  void clearMealPlan() {
    _mealPlan.clear();
    _groceryList.clear(); // Clear grocery list as well
    saveMealPlan();
    saveGroceryList();
    notifyListeners();
  }

  // Generate a grocery list from the meal plan
  List<Map<String, dynamic>> generateGroceryList() {
    final Map<String, int> ingredientCount = {};

    final Map<String, List<String>> mealIngredients = {
      "Avocado Toast": ["Avocado", "Bread", "Salt"],
      "Grilled Chicken Salad": ["Chicken", "Lettuce", "Dressing"],
      "Spaghetti Carbonara": ["Spaghetti", "Eggs", "Cheese", "Bacon"],
    };

    _mealPlan.forEach((day, meals) {
      meals.forEach((mealType, mealName) {
        final ingredients = mealIngredients[mealName] ?? [];
        for (var ingredient in ingredients) {
          ingredientCount[ingredient] = (ingredientCount[ingredient] ?? 0) + 1;
        }
      });
    });

    _groceryList.clear();
    _groceryList.addAll(ingredientCount.entries.map((entry) {
      return {
        'name': "${entry.key} (${entry.value})",
        'purchased': false,
      };
    }).toList());

    saveGroceryList(); // Persist grocery list
    notifyListeners();

    return _groceryList;
  }

  // Mark an item as purchased
  void markItemAsPurchased(int index, bool purchased) {
    if (index >= 0 && index < _groceryList.length) {
      _groceryList[index]['purchased'] = purchased;
      saveGroceryList(); // Persist changes
      notifyListeners();
    }
  }
}
