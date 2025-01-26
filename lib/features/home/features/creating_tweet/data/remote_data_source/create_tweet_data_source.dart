import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/data/models/tweetmodel.dart';

abstract interface class CreateTweetRemoteDataSource {
  Future<void> shareTweet({required Tweetmodel tweetModel});
}

class CreateTweetRemoteDataSourceImpl implements CreateTweetRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  CreateTweetRemoteDataSourceImpl({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;

  @override
  Future<void> shareTweet({required Tweetmodel tweetModel}) async {
    try {
      log('and here i am in remote data source');
      List<String> imageUrls = [];
      if (tweetModel.imageList.isNotEmpty) {
        imageUrls = await _storeImagesInFirebaseStorage(tweetModel);
      }

      final Tweetmodel tweet = tweetModel.copyWith(imageList: imageUrls);
      await _firebaseFirestore
          .collection('UserTweets')
          .doc(tweet.userId)
          .collection(tweet.userId)
          .doc(tweet.tweetId)
          .set(tweet.toMap());
      return;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

  Future<List<String>> _storeImagesInFirebaseStorage(
      Tweetmodel tweetModel) async {
    try {
      return await Future.wait(tweetModel.imageList.map((image) async {
        if (!(await File(image).exists())) {
          throw ServerException(
              message: 'Invalid or non-existent image file: $image',
              stackTrace: StackTrace.current);
        }
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference ref = _firebaseStorage.ref('${tweetModel.tweetId}/$fileName');
        UploadTask uploadTask = ref.putFile(File(image));
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }));
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }
}
