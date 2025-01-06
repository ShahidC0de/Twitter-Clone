import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';

// Want to sign up, want to get user account -> Account, from service class
// Want to access user-related data  -> model.Account, from models class

abstract interface class AuthRemoteDataSource {
  UserOfFuture<UserCredential> signUp({
    required String email,
    required String password,
  });
  UserOfFuture<String> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  UserOfFuture<UserCredential> signUp(
      {required String email, required String password}) async {
    try {
      // Create a user account using Appwrite
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.code, stackTrace: StackTrace.current);
    } catch (e, stackTrace) {
      throw ServerException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  UserOfFuture<String> signIn(
      {required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
