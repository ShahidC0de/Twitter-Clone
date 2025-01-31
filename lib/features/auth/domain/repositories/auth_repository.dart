import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/models/user_model.dart';

abstract interface class AuthRepository {
  FutureEither<UserModel> signUp({
    required String email,
    required String password,
  });
  FutureEither<UserModel> signIn({
    required String email,
    required String password,
  });
  FutureEither<UserModel> getCurrentUser();
}
