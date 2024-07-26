//import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
//import 'package:http/http.dart' as http;
import 'location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation loc) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;
  bool isGettingLocation = false;

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }
    final lat = pickedLocation!.lat;
    final lng = pickedLocation!.lng;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:\A%7C$lat,$lng&key=AIzaSyBv8iIG_q19bWpIrOsM-mlCzPhwdVhHtOI';
  }

  void selectLocation() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MapScreen(),
    ));
  }

  LocationData? loc;
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() => isGettingLocation = true);
    locationData = await location.getLocation();
    loc = locationData;
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }

    final response = await convertToAddress(lat, lng);
    print(await response);

/*
    I would have used Dio but since i dont have a billing account and thus unable to even
    debug the response body i used the convertToAddress that i used in my other projects

    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyBv8iIG_q19bWpIrOsM-mlCzPhwdVhHtOI');
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      final address = responseData['results'][0]['formatted_address'];

      print(response);
    } catch (e) {
      print('error at: $e');
    }
*/
    if (mounted) {
      setState(() {
        pickedLocation = PlaceLocation(
            lat: lat,
            lng: lng,
            address:
                '${response.street}, ${response.subLocality}, ${response.locality}, ${response.isoCountryCode}');
        isGettingLocation = false;
      });
    }
    widget.onSelectLocation(pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );
    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    if (pickedLocation != null) {
      //here when the image fails which ofc it will it'll
      //return the text with lat$lng
      previewContent = Image.network(
        locationImage,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Text(
            '${pickedLocation!.lat} , ${pickedLocation!.lng}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          );
        },
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).colorScheme.primary)),
            height: 170,
            width: double.infinity,
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: selectLocation,
              label: const Text('Select on Map'),
              icon: const Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
