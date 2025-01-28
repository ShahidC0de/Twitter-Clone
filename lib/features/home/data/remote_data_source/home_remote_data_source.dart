import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<UserModel> getCurrentUserData(String currentUserId);
  Future<void> storeCurrentUserdata(UserModel usermodel);
  String get getUserId;
  Future<List<Tweetmodel>> getAllTweets();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  HomeRemoteDataSourceImpl({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth;
// GETTING CURRENT USER DATA WITH ALL ATTRIBUTES;
  @override
  Future<UserModel> getCurrentUserData(String currentUserId) async {
    try {
      final DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(FirebaseConstants.userCollection)
          .doc(currentUserId)
          .get();
      if (documentSnapshot.exists) {
        final rawData = documentSnapshot.data() as Map<String, dynamic>;
        final UserModel userModel = UserModel(
            uid: rawData['uid'],
            name: rawData['name'],
            email: rawData['email'],
            followers: rawData['followers'],
            following: rawData['following'],
            profilePic: rawData['profilePic'],
            bannerPic: rawData['bannerPic'],
            bio: rawData['bio'],
            isTwitterBlue: rawData['isTwitterBlue']);

        return userModel;
      } else {
        throw ServerException(
            message: 'DocumentSnapshot does not exist',
            stackTrace: StackTrace.current);
      }
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

// STORING CURRENT USER DATA WITH ALL ATTTRIBUTES
  @override
  Future<void> storeCurrentUserdata(UserModel usermodel) async {
    try {
      _firebaseFirestore
          .collection(FirebaseConstants.userCollection)
          .doc(getUserId)
          .set(usermodel.toMap());
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

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
}
