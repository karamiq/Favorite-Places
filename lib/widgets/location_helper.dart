import 'package:geocoding/geocoding.dart';

//This section wasn't in the course but wass added cuz i dont have a billing account
//to convert the lat & lng to address
Future<Placemark> convertToAddress(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    return placemarks.first;
  } catch (e) {
    throw Exception('Failed to convert coordinates to address: $e');
  }
}
