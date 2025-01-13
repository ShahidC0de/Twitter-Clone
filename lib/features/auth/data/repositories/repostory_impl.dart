import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/auth/data/remote_data_source/remote_data_source_impl.dart';
import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';

class RepostoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  RepostoryImpl({required AuthRemoteDataSource authRemoteDataSource})
      : _authRemoteDataSource = authRemoteDataSource;
  @override
  @override
  FutureEither<UserEntity> signUp(
      {required String email, required String password}) async {
    try {
      final response =
          await _authRemoteDataSource.signUp(email: email, password: password);
      return right(
          UserEntity(id: response.user!.uid, email: response.user!.email!));
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<UserEntity> signIn(
      {required String email, required String password}) async {
    try {
      final response =
          await _authRemoteDataSource.signIn(email: email, password: password);
      return right(
          UserEntity(id: response.user!.uid, email: response.user!.email!));
    } catch (e) {
      return left(
        Failure(e.toString(), StackTrace.current),
      );
    }
  }

  @override
  FutureEither<UserEntity> getCurrentUser() async {
    try {
      final response = _authRemoteDataSource.currentUserSession;
      if (response != null) {
        return right(UserEntity(id: response.uid, email: response.email!));
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
