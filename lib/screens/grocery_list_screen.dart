import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_plan_provider.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the meal plan and grocery list from the provider
    final mealPlanProvider = Provider.of<MealPlanProvider>(context);
    final mealPlan = mealPlanProvider.mealPlan;
    final groceryItems = mealPlanProvider.generateGroceryList();

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
                      mealPlanProvider.markItemAsPurchased(index, value!); // Corrected method
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
}
