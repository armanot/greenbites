import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealPlanProvider with ChangeNotifier {
  Map<String, Map<String, String>> _mealPlan = {};
  final List<Map<String, dynamic>> _groceryList = [];

  Map<String, Map<String, String>> get mealPlan => _mealPlan;
  List<Map<String, dynamic>> get groceryList => _groceryList;

  // Load meal plan from local storage
  Future<void> loadMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedPlan = prefs.getString('mealPlan');
    if (savedPlan != null) {
      _mealPlan = Map<String, Map<String, String>>.from(
        jsonDecode(savedPlan),
      );
      notifyListeners();
    }
  }

  // Save meal plan to local storage
  Future<void> saveMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mealPlan', jsonEncode(_mealPlan));
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
    saveMealPlan(); // Persist the changes
    notifyListeners();
  }

  // Generate a grocery list from the meal plan
 List<Map<String, dynamic>> generateGroceryList() {
  print("Meal Plan: $_mealPlan"); // Debug log to check the meal plan

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

  print("Ingredient Count: $ingredientCount"); // Debug log to check the ingredient count

  _groceryList.clear();
  _groceryList.addAll(ingredientCount.entries.map((entry) {
    return {
      'name': "${entry.key} (${entry.value})",
      'purchased': false,
    };
  }).toList());

  print("Generated Grocery List: $_groceryList"); // Debug log to check the grocery list

  return _groceryList;
}

  // Mark an item as purchased
  void markItemAsPurchased(int index, bool purchased) {
    if (index >= 0 && index < _groceryList.length) {
      _groceryList[index]['purchased'] = purchased;
      notifyListeners(); // Update the UI
    }
  }
}
