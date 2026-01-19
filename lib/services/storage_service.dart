import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload multiple images
  Future<List<String>> uploadImages(List<File> imageFiles, String basePath) async {
    final List<String> urls = [];
    for (var i = 0; i < imageFiles.length; i++) {
      final url = await uploadImage(
        imageFiles[i],
        '$basePath/${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
      );
      urls.add(url);
    }
    return urls;
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Pick image from gallery
  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return File(image.path);
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    return images.map((xFile) => File(xFile.path)).toList();
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return File(image.path);
  }
}
