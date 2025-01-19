import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/domain/entities/user_entity.dart';

abstract interface class SavingUserDataRepository {
  FutureEitherVoid saveUserData(UserEntity user);
}
