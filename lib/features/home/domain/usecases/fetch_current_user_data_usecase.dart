import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class FetchCurrentUserDataUsecase implements Usecase<UserEntity, UserIdParams> {
  final HomeRepository _homeRepository;
  FetchCurrentUserDataUsecase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEither<UserEntity> call(UserIdParams params) async {
    return _homeRepository.getCurrentUserData(params.userId);
  }
}

class UserIdParams {
  final String userId;
  UserIdParams({
    required this.userId,
  });
}
