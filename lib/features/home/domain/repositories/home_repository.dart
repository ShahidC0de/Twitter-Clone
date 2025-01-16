import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/domain/entities/user.dart';

abstract interface class HomeRepository {
  FutureEitherVoid saveUserData(UserEntity user);
}
