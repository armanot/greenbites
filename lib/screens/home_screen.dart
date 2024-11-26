import 'package:flutter/material.dart';
import 'package:greenbitesapp/screens/meal_planner_screen.dart';
import 'package:greenbitesapp/screens/grocery_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    Column(
      children: const [
        WelcomeHeader(),
        TodayMeals(),
        QuickActions(),
        PollsAndHighlights(),
      ],
    ),
    MealPlannerScreen(),
    GroceryListScreen(),
  ];

  // Titles for each tab
  final List<String> _titles = [
    'GreenBites',
    'Meal Planner',
    'Grocery List',
  ];

  // Handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Dynamic title
        backgroundColor: Colors.green,
      ),
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Meals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Groceries'),
        ],
        onTap: _onItemTapped, // Handle tab change
      ),
    );
  }
}

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Good Morning, User!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TodayMeals extends StatelessWidget {
  const TodayMeals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Meals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.breakfast_dining, color: Colors.orange),
              title: Text("Breakfast: Avocado Toast"),
              subtitle: Text("08:00 AM"),
            ),
            ListTile(
              leading: Icon(Icons.lunch_dining, color: Colors.blue),
              title: Text("Lunch: Grilled Chicken Salad"),
              subtitle: Text("12:30 PM"),
            ),
            ListTile(
              leading: Icon(Icons.dinner_dining, color: Colors.red),
              title: Text("Dinner: Spaghetti Carbonara"),
              subtitle: Text("07:00 PM"),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealPlannerScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Meal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Add recipe action here
            },
            icon: const Icon(Icons.book),
            label: const Text('Recipes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroceryListScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Groceries'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class PollsAndHighlights extends StatelessWidget {
  const PollsAndHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Poll",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("What is your favorite meal of the day?"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {}, child: const Text("Breakfast")),
                ElevatedButton(onPressed: () {}, child: const Text("Lunch")),
                ElevatedButton(onPressed: () {}, child: const Text("Dinner")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
