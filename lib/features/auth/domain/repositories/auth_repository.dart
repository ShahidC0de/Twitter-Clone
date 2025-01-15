import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/entities/auth_user_entity.dart';

abstract interface class AuthRepository {
  FutureEither<AuthUserEntity> signUp({
    required String email,
    required String password,
  });
  FutureEither<AuthUserEntity> signIn({
    required String email,
    required String password,
  });
  FutureEither<AuthUserEntity> getCurrentUser();
}
