import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/remote_data_source/home_remote_data_source.dart';
import 'package:twitter_clone/features/home/domain/entities/user.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  HomeRepositoryImpl({
    required HomeRemoteDataSource homeRemoteDataSource,
  }) : _homeRemoteDataSource = homeRemoteDataSource;
  @override
  FutureEither<UserEntity> getCurrentUserData(String userId) async {
    try {
      final UserEntity userEntity =
          await _homeRemoteDataSource.getCurrentUserData(userId);

      return right(userEntity);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
