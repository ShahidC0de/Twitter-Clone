import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements Usecase<UserEntity, NoParams> {
  final AuthRepository _authRepository;
  GetCurrentUser({required AuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  FutureEither<UserEntity> call(NoParams params) async {
    return _authRepository.getCurrentUser();
  }
}
