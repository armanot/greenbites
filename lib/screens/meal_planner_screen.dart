
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_plan_provider.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Planner'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: MealPlannerBody(),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: AvailableMealsList(),
          ),
        ],
      ),
    );
  }
}

class MealPlannerBody extends StatelessWidget {
  const MealPlannerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plan Your Week's Meals",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: MealPlannerGrid(),
          ),
        ],
      ),
    );
  }
}

class MealPlannerGrid extends StatelessWidget {
  static const List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  static const List<String> meals = ["Breakfast", "Lunch", "Dinner"];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: days.length, // 7 columns for days
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: days.length * meals.length,
      itemBuilder: (context, index) {
        final day = days[index % days.length];
        final meal = meals[index ~/ days.length];
        return DroppableMealSlot(day: day, mealType: meal);
      },
    );
  }
}


class DroppableMealSlot extends StatelessWidget {
  final String day;
  final String mealType;

  const DroppableMealSlot({super.key, required this.day, required this.mealType});

  @override
  Widget build(BuildContext context) {
    final mealPlanProvider = Provider.of<MealPlanProvider>(context);
    final plannedMeal = mealPlanProvider.getMeal(day, mealType);

    return DragTarget<String>(
      onAccept: (meal) {
        mealPlanProvider.addMeal(day, mealType, meal);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              plannedMeal ?? "$day\n$mealType",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

class AvailableMealsList extends StatelessWidget {
  static const List<String> availableMeals = [
    "Avocado Toast",
    "Grilled Chicken Salad",
    "Spaghetti Carbonara",
    "Vegetable Stir-Fry",
    "Pancakes",
    "Fruit Smoothie",
    "Tuna Sandwich",
  ];

  const AvailableMealsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: availableMeals.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return DraggableMeal(meal: availableMeals[index]);
        },
      ),
    );
  }
}

class DraggableMeal extends StatelessWidget {
  final String meal;

  const DraggableMeal({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: meal,
      feedback: Material(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            meal,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          meal,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}



