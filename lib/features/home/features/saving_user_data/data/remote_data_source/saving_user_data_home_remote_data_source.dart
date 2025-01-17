import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';

abstract interface class SavingUserDataSource {
  Future<void> storeUserInfo(UserModel usermodel);
  String get getCurrentUserId;
}

class SavingUserDataSourceImpl implements SavingUserDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  SavingUserDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  @override
  String get getCurrentUserId => _firebaseAuth.currentUser!.uid;

  @override
  Future<void> storeUserInfo(UserModel usermodel) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(getCurrentUserId)
          .set(usermodel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }
}
