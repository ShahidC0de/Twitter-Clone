import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/data_source/firebase_storage_data_source.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';

abstract interface class CreateTweetRemoteDataSource {
  Future<void> shareTweet({required Tweetmodel tweetModel});
}

class CreateTweetRemoteDataSourceImpl implements CreateTweetRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorageDataSource _firebaseStorageDataSource;
  CreateTweetRemoteDataSourceImpl({
    required FirebaseStorageDataSource firebaseStorageDataSource,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorageDataSource = firebaseStorageDataSource;

  @override
  Future<void> shareTweet({required Tweetmodel tweetModel}) async {
    try {
      log('and here i am in remote data source');
      List<String> imageUrls = [];
      if (tweetModel.imageList.isNotEmpty) {
        imageUrls = await _firebaseStorageDataSource.uploadListOfImages(
            tweetModel.imageList, tweetModel.tweetId);
      }

      final Tweetmodel tweet = tweetModel.copyWith(imageList: imageUrls);
      await _firebaseFirestore
          .collection(FirebaseConstants.usersTweetsCollection)
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
}
