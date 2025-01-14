import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/auth/data/models/user_model.dart';

// Want to sign up, want to get user account -> Account, from service class
// Want to access user-related data  -> model.Account, from models class

abstract interface class AuthRemoteDataSource {
  User? get currentUserSession;

  UserOfFuture<UserModel> signUp({
    required String email,
    required String password,
  });
  UserOfFuture<UserModel> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;
  @override
  User? get currentUserSession => _firebaseAuth.currentUser;

  @override
  UserOfFuture<UserModel> signUp(
      {required String email, required String password}) async {
    try {
      // Create a user account using Appwrite
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel(
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
  UserOfFuture<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return UserModel(
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
}
