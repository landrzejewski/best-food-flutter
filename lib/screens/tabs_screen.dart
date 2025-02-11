import 'package:best_food/providers/favourites_meals_provider.dart';
import 'package:best_food/providers/filters_provider.dart';
import 'package:best_food/screens/categories_screen.dart';
import 'package:best_food/screens/filters_screen.dart';
import 'package:best_food/screens/meals_screen.dart';
import 'package:best_food/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedTabIndex = 0;

  void _setTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _setScreen(String id) async {
    Navigator.pop(context);
    if (id == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen()
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(filteredMealsProvider);
    final favouriteMeals = ref.watch(favouriteMealProvider);

    final activeTab = switch (_selectedTabIndex) {
      0 => CategoriesScreen(meals: meals),
      1 => MealsScreen(meals: favouriteMeals),
      _ => throw UnimplementedError()
    };

    final activeTabTitle = switch (_selectedTabIndex) {
      0 => 'Categories',
      1 => 'Favourites',
      _ => throw UnimplementedError()
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(activeTabTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activeTab,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _setTab,
        currentIndex: _selectedTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
          )
        ],
      ),
    );
  }
}
