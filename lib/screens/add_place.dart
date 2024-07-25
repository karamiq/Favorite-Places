import 'dart:io';

import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/image_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});
  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final titleController = TextEditingController();
  File? _pickImage;
  void _savePlace() {
    print(_pickImage);
    final enteredText = titleController.text;
    if (enteredText.isEmpty || _pickImage == null) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(enteredText, _pickImage!);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInput(
              onPickImage: (image) => _pickImage= image,
            ),
            const SizedBox(
              height: 16,
            ),
            const LocationInput(),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'))
          ],
        ),
      ),
    );
  }
}
