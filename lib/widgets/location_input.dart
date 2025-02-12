import 'package:best_food/models/location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var _isLoading = false;

  void _getLocation() async {
    final location = Location();
    var isLocationEnabled = await location.serviceEnabled();
    if (!isLocationEnabled) {
      isLocationEnabled = await location.requestService();
      if (!isLocationEnabled) {
        return;
      }
    }
    var hasPermission = await location.requestPermission();
    if (hasPermission == PermissionStatus.denied) {
      hasPermission = await location.requestPermission();
      if (hasPermission != PermissionStatus.granted) {
        return;
      }
    }

    setState(() => _isLoading = true);

    var locationData = await location.getLocation();

    if (locationData.longitude == null || locationData.latitude == null) {
      setState(() => _isLoading = false);
      return;
    }

    _save(locationData.latitude!, locationData.longitude!);
  }

  Future<void> _save(double latitude, double longitude) async {
     setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget preview = Text(
      'No location selected',
      style: TextStyle(color: const Color.fromARGB(255, 195, 181, 235)),
      textAlign: TextAlign.center,
    );

    if (_isLoading) {
      preview = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.deepPurple),
          ),
          child: preview,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get location'),
              onPressed: _getLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}
