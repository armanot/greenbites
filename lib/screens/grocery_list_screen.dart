import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_plan_provider.dart';

class GroceryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the meal plan from the provider
    final mealPlan = Provider.of<MealPlanProvider>(context).mealPlan;

    // Generate the grocery list
    final groceryItems = Provider.of<MealPlanProvider>(context).generateGroceryList();


    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
        backgroundColor: Colors.green,
      ),
      body: groceryItems.isEmpty
          ? const Center(
              child: Text(
                "No items in your grocery list. Add meals to generate your list!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: groceryItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: groceryItems[index]['purchased'],
                    onChanged: (value) {
                      // Handle checkbox toggle (optional: persist state)
                    },
                  ),
                  title: Text(
                    groceryItems[index]['name'],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }

  // Generate a grocery list based on the meal plan
  List<Map<String, dynamic>> _generateGroceryList(
      Map<String, Map<String, String>> mealPlan) {
    final Map<String, int> ingredientCount = {};

    // Example meal-to-ingredient mapping
    final Map<String, List<String>> mealIngredients = {
      "Avocado Toast": ["Avocado", "Bread", "Salt"],
      "Grilled Chicken Salad": ["Chicken", "Lettuce", "Dressing"],
      "Spaghetti Carbonara": ["Spaghetti", "Eggs", "Cheese", "Bacon"],
    };

    // Populate ingredient counts
    mealPlan.forEach((day, meals) {
      meals.forEach((mealType, mealName) {
        final ingredients = mealIngredients[mealName] ?? [];
        for (var ingredient in ingredients) {
          ingredientCount[ingredient] = (ingredientCount[ingredient] ?? 0) + 1;
        }
      });
    });

    // Convert to a list of grocery items
    return ingredientCount.entries.map((entry) {
      return {
        'name': "${entry.key} (${entry.value})",
        'purchased': false,
      };
    }).toList();
  }
}
