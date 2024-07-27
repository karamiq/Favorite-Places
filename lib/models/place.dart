import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}

class PlaceLocation {
  final double lat;
  final double lng;
  final String address;
  PlaceLocation({required this.lat, required this.lng, required this.address});
}
