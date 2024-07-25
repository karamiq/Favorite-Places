import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Location? pickedLocation;
  LocationData? loc;
  bool isGettingLocation = false;
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
    setState(() => isGettingLocation = false);
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
    if (loc != null) {
      previewContent = Text(
        '${loc!.latitude} , ${loc!.longitude}',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
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
              onPressed: () {},
              label: const Text('Select on Map'),
              icon: const Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
