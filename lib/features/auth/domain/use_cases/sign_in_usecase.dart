import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';

class UserSignIn implements Usecase<UserEntity, UserSignInParams> {
  final AuthRepository _authRepository;
  UserSignIn({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  FutureEither<UserEntity> call(params) async {
    return _authRepository.signIn(
        email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;
  UserSignInParams({
    required this.email,
    required this.password,
  });
}
