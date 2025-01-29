import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';

abstract interface class StorageRemoteDataSource {
  Future<List<String>> storeListOfImages(
      List<String> images, String folderNameInFirebaseStorage);
}

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  final FirebaseStorage _firebaseStorage;
  StorageRemoteDataSourceImpl({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;
  // THIS FUNCTION IS RESPONSIBLE FOR UPLOADING A LIST OF IMAGES AND RETURN THOSE IMAGES LINKS IN,
  // THAT ARE UPLOADED TO FIREBASE STORAGE;
  @override
  Future<List<String>> storeListOfImages(
      List<String> images, String folderNameInFirebaseStorage) async {
    try {
      return await Future.wait(images.map((image) async {
        if (!(await File(image).exists())) {
          throw ServerException(
              message: 'Invalid or non-existent image file: $image',
              stackTrace: StackTrace.current);
        }
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference ref =
            _firebaseStorage.ref('$folderNameInFirebaseStorage/$fileName');
        UploadTask uploadTask = ref.putFile(File(image));
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }));
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }
}
