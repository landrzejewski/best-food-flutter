import 'dart:convert';

import 'package:best_food/models/location.dart';
import 'package:best_food/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyCmABbU2QbTkOFlK0En4xwGqg-uWif8QQg';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var _isLoading = false;
  PlaceLocation? _pickedLocation;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey';
  }

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

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context)
    .push<LatLng>(MaterialPageRoute(builder: (ctx) => const MapScreen()),);
    if (pickedLocation == null) {
      return;
    }
    _save(pickedLocation.latitude, pickedLocation.longitude);
  }

  Future<void> _save(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final address = data['results'][0]['formatted_address'];
    _pickedLocation = PlaceLocation(
        latitude: latitude, longitude: longitude, address: address);
    setState(() => _isLoading = false);
    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget preview = Text(
      'No location selected',
      style: TextStyle(color: const Color.fromARGB(255, 195, 181, 235)),
      textAlign: TextAlign.center,
    );

    if (_pickedLocation != null) {
      preview = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

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
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
