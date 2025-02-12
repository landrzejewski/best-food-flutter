import 'dart:io';

import 'package:best_food/models/location.dart';
import 'package:best_food/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

const createDatabase = """create table places (
      id text primary key,
      name text,
      image_path text,
      lat real,
      lng real,
      address text
      )""";
const version = 1;

Future<sql.Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) => db.execute(createDatabase), version: version);
  return db;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  Place toPlace(Map<String, Object?> row) {
    return Place(
      id: row['id'] as String,
      name: row['name'] as String,
      image: File(row['image_path'] as String),
      location: PlaceLocation(
        latitude: row['lat'] as double,
        longitude: row['lng'] as double,
        address: row['address'] as String,
      ),
    );
  }

  Future<void> load() async {
    final db = await _getDatabase();
    final data = await db.query('places');
    final places = data.map(toPlace).toList();
    await Future.delayed(Duration(seconds: 2));
    state = places;
  }

  void add(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final image = await place.image.copy('${appDir.path}/$filename');
    final db = await _getDatabase();
    db.insert('places', {
      'id': place.id,
      'name': place.name,
      'image_path': image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address
    });
    final newPlace = Place(
      id: place.id,
      name: place.name,
      image: image,
      location: place.location,
    );
    state = [newPlace, ...state];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
