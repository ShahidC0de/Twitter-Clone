import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class GetUserDataUsecase implements Usecase<UserEntity, UserParams> {
  final HomeRepository _homeRepository;
  GetUserDataUsecase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;
  @override
  FutureEither<UserEntity> call(UserParams params) async {
    return _homeRepository.getUserData(params.userId);
  }
}

class UserParams {
  final String userId;
  UserParams({required this.userId});
}
