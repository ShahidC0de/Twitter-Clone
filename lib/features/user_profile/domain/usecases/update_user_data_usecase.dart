import 'dart:io';

import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/user_profile/domain/repositories/user_profile_repoistory.dart';

class UpdateUserDataUsecase implements Usecase<void, UpdateUserParams> {
  final UserProfileRepoistory _userProfileRepoistory;
  UpdateUserDataUsecase({
    required UserProfileRepoistory userProfileRepository,
  }) : _userProfileRepoistory = userProfileRepository;
  @override
  FutureEither<void> call(UpdateUserParams params) async {
    return _userProfileRepoistory.updateUserData(
        params.user, params.profileFile, params.profileFile);
  }
}

class UpdateUserParams {
  final UserEntity user;
  final File? profileFile;
  final File? bannerFile;
  UpdateUserParams({
    required this.user,
    required this.bannerFile,
    required this.profileFile,
  });
}
