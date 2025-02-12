import 'dart:io';

import 'package:best_food/models/location.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    String? id,
    required this.name,
    required this.image,
    required this.location,
  }) : id = id ?? uuid.v6();

  final String id;
  final String name;
  final File image;
  final PlaceLocation location;
}
