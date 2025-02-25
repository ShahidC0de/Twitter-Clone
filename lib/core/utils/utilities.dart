import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<List<File>> pickImages() async {
  List<File> images = []; // impty list of image
  final ImagePicker picker = ImagePicker(); // object of imagepicker
  final imageFiles =
      await picker.pickMultiImage(); // to pick more than one image at a time;
  if (imageFiles.isNotEmpty) {
    // if the picked images are not empty;
    for (final image in imageFiles) {
      // then take each image from imageFiles.
      images.add(File(image.path)); // add it to the list of images;
    }
  }
  return images; // and return the list;
}

Future<File?> pickImage() async {
  final ImagePicker imagePicker = ImagePicker();
  final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
  if (imageFile != null) {
    return File(imageFile.path);
  } else {
    return null;
  }
}
