import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/auth/data/models/auth_user_model.dart';
import 'package:twitter_clone/features/auth/data/remote_data_source/remote_data_source_impl.dart';
import 'package:twitter_clone/core/entities/auth_user_entity.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';

class RepostoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  RepostoryImpl({required AuthRemoteDataSource authRemoteDataSource})
      : _authRemoteDataSource = authRemoteDataSource;
  @override
  @override
  FutureEither<AuthUserEntity> signUp(
      {required String email, required String password}) async {
    try {
      final AuthUserModel userModel =
          await _authRemoteDataSource.signUp(email: email, password: password);
      return right(AuthUserEntity(id: userModel.id, email: userModel.email));
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<AuthUserEntity> signIn(
      {required String email, required String password}) async {
    try {
      final AuthUserModel userModel =
          await _authRemoteDataSource.signIn(email: email, password: password);
      return right(AuthUserEntity(id: userModel.id, email: userModel.email));
    } catch (e) {
      return left(
        Failure(e.toString(), StackTrace.current),
      );
    }
  }

  @override
  FutureEither<AuthUserEntity> getCurrentUser() async {
    try {
      final response = _authRemoteDataSource.currentUserSession;
      if (response != null) {
        return right(AuthUserEntity(id: response.uid, email: response.email!));
      } else {
        return left(Failure('User is null', StackTrace.current));
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
