import 'package:best_food/providers/places_provider.dart';
import 'package:best_food/screens/add_place.dart';
import 'package:best_food/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).load();
  }

  void _addPlace() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const AddPlaceScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      OutlinedButton(onPressed: _addPlace, child: Text('Add')),
                      Spacer(),
                      PlacesList(
                        places: places,
                      ),
                      Spacer(),
                    ],
                  ),
      ),
    );
  }
}
