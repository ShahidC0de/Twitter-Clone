import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';

abstract interface class AuthRepository {
  FutureEither<UserEntity> signUp({
    required String email,
    required String password,
  });
  FutureEither<UserEntity> signIn({
    required String email,
    required String password,
  });
  FutureEither<UserEntity> getCurrentUser();
}
