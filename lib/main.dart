import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_plan_provider.dart';
import 'screens/home_screen.dart';
import 'screens/meal_planner_screen.dart';
import 'screens/grocery_list_screen.dart';
import 'screens/recipe_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
      child: const GreenBitesApp(),
    ),
  );
}

class GreenBitesApp extends StatelessWidget {
  const GreenBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenBites',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/meal-planner': (context) => const MealPlannerScreen(),
        '/grocery-list': (context) => const GroceryListScreen(),
        '/recipes': (context) => const RecipeScreen(),
      },
    );
  }
}
