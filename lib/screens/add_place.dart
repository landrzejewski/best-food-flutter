import 'dart:io';

import 'package:best_food/models/location.dart';
import 'package:best_food/models/place.dart';
import 'package:best_food/providers/places_provider.dart';
import 'package:best_food/widgets/image_input.dart';
import 'package:best_food/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _nameController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text;
    if (name.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }
    final place =
        Place(name: name, image: _selectedImage!, location: _selectedLocation!);
        
    ref.read(placesProvider.notifier).add(place);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new place'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: _nameController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              ImageInput(onPickImage: (image) => _selectedImage = image),
              const SizedBox(height: 10),
              LocationInput(
                  onSelectLocation: (location) => _selectedLocation = location),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.add),
                label: const Text('Add place'),
              )
            ],
          ),
        ));
  }
}
