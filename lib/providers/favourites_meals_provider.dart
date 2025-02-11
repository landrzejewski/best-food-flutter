import 'package:best_food/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesMealsProvider extends StateNotifier<List<Meal>> {
  FavouritesMealsProvider() : super([]);

  bool toggleFavouriteStatus(Meal meal) {
    final isFavourite = state.contains(meal);
    if (isFavourite) {
      state = state.where((currentMeal) => currentMeal.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favouriteMealsProvider = StateNotifierProvider<FavouritesMealsProvider, List<Meal>>((ref) {
  return FavouritesMealsProvider();
});
