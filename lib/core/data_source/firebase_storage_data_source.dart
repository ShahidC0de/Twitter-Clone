import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';

abstract interface class FirebaseStorageDataSource {
  Future<String> uploadSinglePhoto(
      String image, String folderNameInFirebaseStorage);
  Future<List<String>> uploadListOfImages(
      List<String> imageList, String folderNameInFirebaseStorage);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage _firebaseStorage;
  FirebaseStorageDataSourceImpl({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  @override
  @override
  Future<String> uploadSinglePhoto(
      String image, String folderNameInFirebaseStorage) async {
    try {
      if (!(await File(image).exists())) {
        throw ServerException(
            message: 'Invalid or non-existent image file: $image',
            stackTrace: StackTrace.current);
      }
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();

      Reference reference =
          _firebaseStorage.ref('$folderNameInFirebaseStorage/$fileName');
      UploadTask uploadTask = reference.putFile(File(image));
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<List<String>> uploadListOfImages(
      List<String> imageList, String folderNameInFirebaseStorage) async {
    try {
      return await Future.wait(imageList.map((image) async {
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
