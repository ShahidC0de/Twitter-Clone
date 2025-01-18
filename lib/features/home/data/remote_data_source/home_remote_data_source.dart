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
      final rawData = documentSnapshot.data();
      if (rawData != null) {
        return UserModel.fromMap(rawData as Map<String, dynamic>);
      } else {
        throw ServerException(
            message: 'Data is not present', stackTrace: StackTrace.current);
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
