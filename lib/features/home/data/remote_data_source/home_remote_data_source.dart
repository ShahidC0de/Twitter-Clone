import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<UserModel> getCurrentUserData(String currentUserId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;
  HomeRemoteDataSourceImpl({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

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
}
