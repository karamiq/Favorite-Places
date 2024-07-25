import 'package:flutter/material.dart';
import '../models/place.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({super.key, required this.place});
  final Place place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title,
         style:  Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),),
      ),
      body: Stack(
        children: [
          Image.file(place.image,fit: BoxFit.cover, height:double.infinity,width: double.infinity,)
        ],
      ),
    );
  }
}
