import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<UserModel> getCurrentUserData(String currentUserId);
  Future<void> storeCurrentUserdata(UserModel usermodel);
  String get getUserId;
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  HomeRemoteDataSourceImpl({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth;

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

  @override
  String get getUserId => _firebaseAuth.currentUser!.uid;
}
