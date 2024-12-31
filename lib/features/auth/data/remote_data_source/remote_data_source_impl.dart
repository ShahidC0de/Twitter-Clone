import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/core/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';

// Want to sign up, want to get user account -> Account, from service class
// Want to access user-related data  -> model.Account, from models class

abstract interface class AuthRemoteDataSource {
  UserOfFuture<model.User> signUp({
    required String email,
    required String password,
  });
  UserOfFuture<model.Session> signIn({
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
      log(response.toString());
      return response;
    } on AppwriteException catch (e) {
      if (e.code != null) {
        final String message = generateErrorMessage(e.code!);
        log(message);
        throw ServerException(message: message, stackTrace: StackTrace.current);
      } else {
        log(e.toString());
        throw ServerException(
            message: e.toString(), stackTrace: StackTrace.current);
      }
    } catch (e, stackTrace) {
      throw ServerException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  UserOfFuture<model.Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _account.createEmailPasswordSession(
          email: email, password: password);
      log(response.toString());
      return response;
    } on AppwriteException catch (e) {
      if (e.code != null) {
        final message = generateErrorMessage(e.code!);
        log(message);
        throw ServerException(message: message, stackTrace: StackTrace.current);
      } else {
        log(e.toString());
        throw ServerException(
            message: e.toString(), stackTrace: StackTrace.current);
      }
    }
  }

// this will find the error using the error code and provide an informative message about what is wrong;
  String generateErrorMessage(int code) {
    return AppwriteConstants.errorCodesAndTheirMessages[code] ??
        'An error has been occured ';
  }
}
