import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/auth/data/models/auth_user_model.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';

// Want to sign up, want to get user account -> Account, from service class
// Want to access user-related data  -> model.Account, from models class

abstract interface class AuthRemoteDataSource {
  User? get currentUserSession;

  UserOfFuture<AuthUserModel> signUp({
    required String email,
    required String password,
  });
  UserOfFuture<AuthUserModel> signIn({
    required String email,
    required String password,
  });
  UserOfFuture<UserModel> storeCurrentUserDataInFirestore(UserModel usermodel);
  UserOfFuture<UserModel> getCurrentUserDataInFirestore(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRemoteDataSourceImpl(
      {required FirebaseFirestore firebaseFirestore,
      required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;
  @override
  User? get currentUserSession => _firebaseAuth.currentUser;

  @override
  UserOfFuture<AuthUserModel> signUp(
      {required String email, required String password}) async {
    try {
      // Create a user account using Appwrite
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return AuthUserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? 'No Email Available');
      } else {
        throw ServerException(
            message: 'User creation Failed', stackTrace: StackTrace.current);
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.code, stackTrace: StackTrace.current);
    } catch (e, stackTrace) {
      throw ServerException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  UserOfFuture<AuthUserModel> signIn(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return AuthUserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? 'No Email Available');
      } else {
        throw ServerException(
            message: 'User signing Failed', stackTrace: StackTrace.current);
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  UserOfFuture<UserModel> storeCurrentUserDataInFirestore(
      UserModel usermodel) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConstants.userCollection)
          .doc(currentUserSession!.uid)
          .set(usermodel.toMap());
      return usermodel;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  UserOfFuture<UserModel> getCurrentUserDataInFirestore(String userId) async {
    try {
      final DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .get();
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
