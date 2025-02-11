import 'package:best_food/providers/filters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filtersProvider);
    final textStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Theme.of(context).colorScheme.onSurface);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: filters[Filter.glutenFree]!,
            onChanged: (isChecked) => ref
                .read(filtersProvider.notifier)
                .setFilter(Filter.glutenFree, isChecked),
            title: Text("Gluten free", style: textStyle),
          ),
           SwitchListTile(
            value: filters[Filter.lactoseFree]!,
            onChanged: (isChecked) => ref
                .read(filtersProvider.notifier)
                .setFilter(Filter.lactoseFree, isChecked),
            title: Text("Lactose free", style: textStyle),
          ),
           SwitchListTile(
            value: filters[Filter.vegetarian]!,
            onChanged: (isChecked) => ref
                .read(filtersProvider.notifier)
                .setFilter(Filter.vegetarian, isChecked),
            title: Text("Vegetarian", style: textStyle),
          ),
           SwitchListTile(
            value: filters[Filter.vegan]!,
            onChanged: (isChecked) => ref
                .read(filtersProvider.notifier)
                .setFilter(Filter.vegan, isChecked),
            title: Text("Vegan", style: textStyle),
          )
        ],
      ),
    );
  }
}
