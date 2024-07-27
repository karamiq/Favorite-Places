import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key, PlaceLocation? location, this.isSelecting = true})
      : location = location ??
            PlaceLocation(address: '', lat: 33.312805, lng: 44.361488);

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting
            ? 'Pick your location'
            : widget.location.address),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () => Navigator.pop<LatLng>(context, pickedLocation),
                icon: const Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        onTap: (pos) =>
            !widget.isSelecting ? null : setState(() => pickedLocation = pos),
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.lat, widget.location.lng),
          zoom: 16,
        ),
        markers: (pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('marker'),
                    position: pickedLocation ??
                        LatLng(widget.location.lat, widget.location.lng)),
              },
      ),
    );
  }
}
