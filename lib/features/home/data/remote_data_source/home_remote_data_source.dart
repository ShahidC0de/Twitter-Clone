import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/core/models/user_model.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';
import 'package:twitter_clone/features/home/data/remote_data_source/storage_remote_data_source.dart';

abstract interface class HomeRemoteDataSource {
  String get getUserId;
  Future<List<Tweetmodel>> getAllTweets();
  Future<Tweetmodel> shareTweet(Tweetmodel tweet);
  Future<UserModel> getUserData(String userId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final StorageRemoteDataSource _storageRemoteDataSource;
  HomeRemoteDataSourceImpl({
    required StorageRemoteDataSource storageRemoteDataSource,
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth,
        _storageRemoteDataSource = storageRemoteDataSource;

// GETTING CURRENT USER ID;
  @override
  String get getUserId => _firebaseAuth.currentUser!.uid;
// GETTING ALL TWEETS OF ALL USERS;
  @override
  Future<List<Tweetmodel>> getAllTweets() async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collectionGroup('tweets').get();

      log("this is the new query data and documents are${querySnapshot.docs.length.toString()}");
      // Use a collection group query to fetch all tweets from all users
      QuerySnapshot tweetsSnapshot = await _firebaseFirestore
          .collectionGroup(
              'tweets') // Use a common sub-collection name for all users
          .get();

      // Map tweets to TweetModel and add to the list
      List<Tweetmodel> allTweets = tweetsSnapshot.docs
          .map(
            (doc) => Tweetmodel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();

      // Log tweets for debugging
      for (var i = 0; i < allTweets.length; i++) {
        log('Tweet ${i + 1}: ${allTweets[i].toMap()}');
      }

      return allTweets;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<Tweetmodel> shareTweet(Tweetmodel tweetModel) async {
    try {
      log('and here i am in remote data source');
      List<String> imageUrls = [];
      if (tweetModel.imageList.isNotEmpty) {
        imageUrls = await _storageRemoteDataSource.storeListOfImages(
            tweetModel.imageList, tweetModel.tweetId);
      }

      final Tweetmodel tweet = tweetModel.copyWith(imageList: imageUrls);
      await _firebaseFirestore
          .collection(FirebaseConstants.usersTweetsCollection)
          .doc(tweet.userId)
          .collection('tweets')
          .doc(tweet.tweetId)
          .set(tweet.toMap());
      return tweet;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    try {
      log(userId.toString());
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection('Users')
          .doc('NyGnaafKlybWYLVKzVZU0LpCps92')
          .get();
      log(documentSnapshot.data().toString());
      final rawData = documentSnapshot.data();

      return UserModel.fromMap(rawData as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }
}
