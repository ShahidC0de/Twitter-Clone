import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/auth/data/remote_data_source/remote_data_source_impl.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:twitter_clone/core/models/user_model.dart';

class RepostoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  RepostoryImpl({required AuthRemoteDataSource authRemoteDataSource})
      : _authRemoteDataSource = authRemoteDataSource;
  @override
  @override
  FutureEither<UserModel> signUp(
      {required String email, required String password}) async {
    try {
      final user =
          await _authRemoteDataSource.signUp(email: email, password: password);
      if (user.id.isNotEmpty) {
        final UserModel usermodel = await _authRemoteDataSource
            .storeCurrentUserDataInFirestore(UserModel(
                uid: user.id,
                name: "",
                email: user.email,
                followers: [],
                following: [],
                profilePic: "",
                bannerPic: "",
                bio: "",
                isTwitterBlue: false));
        return right(usermodel);
      }
      return left(
          Failure('User cannot be created in firestore', StackTrace.current));
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      final user =
          await _authRemoteDataSource.signIn(email: email, password: password);
      if (user.id.isNotEmpty) {
        final UserModel userModel =
            await _authRemoteDataSource.getCurrentUserDataInFirestore(user.id);
        return right(userModel);
      }
      return left(Failure('some error has been occured ', StackTrace.current));
    } catch (e) {
      return left(
        Failure(e.toString(), StackTrace.current),
      );
    }
  }

  @override
  FutureEither<UserModel> getCurrentUser() async {
    try {
      final response = _authRemoteDataSource.currentUserSession;
      if (response != null) {
        final UserModel userModel = await _authRemoteDataSource
            .getCurrentUserDataInFirestore(response.uid);
        return right(userModel);
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
