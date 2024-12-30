import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';

// Want to sign up, want to get user account -> Account, from service class
// Want to access user-related data  -> model.Account, from models class

abstract interface class AuthRemoteDataSource {
  UserOfFuture<model.User> signUp({
    required String email,
    required String password,
  });
  UserOfFuture<model.User> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Account _account;

  AuthRemoteDataSourceImpl({required Account account}) : _account = account;

  @override
  UserOfFuture<model.User> signUp(
      {required String email, required String password}) async {
    try {
      // Create a user account using Appwrite
      final model.User response = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return response;
    } on AppwriteException catch (e, stackTrace) {
      if (e.code == 400) {
        throw ServerException(
            message: 'Invalid email or password', stackTrace: stackTrace);
      } else if (e.code == 409) {
        throw ServerException(
            message: 'Email already used', stackTrace: stackTrace);
      } else if (e.code == 401) {
        throw ServerException(
            message: 'Unauthorized access', stackTrace: stackTrace);
      } else {
        throw ServerException(
          message: 'An unexpected error has been occured',
          stackTrace: stackTrace,
        );
      }
    } catch (e, stackTrace) {
      throw ServerException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  UserOfFuture<model.User> signIn({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }
}
