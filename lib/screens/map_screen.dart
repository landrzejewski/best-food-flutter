import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const defaultLocation = LatLng(51.9194, 19.1451);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick location'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(_pickedLocation),
              icon: Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: defaultLocation, zoom: 14),
        onTap: (position) {
          setState(() => _pickedLocation = position);
        },
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('position'),
                    position: _pickedLocation ?? defaultLocation)
              },
      ),
    );
  }
}
