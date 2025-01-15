import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/core/entities/auth_user_entity.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';

class UserSignUp implements Usecase<AuthUserEntity, UserSignUpParams> {
  final AuthRepository _authRepository;
  UserSignUp({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  FutureEither<AuthUserEntity> call(params) async {
    return await _authRepository.signUp(
        email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  UserSignUpParams({
    required this.email,
    required this.password,
  });
}
