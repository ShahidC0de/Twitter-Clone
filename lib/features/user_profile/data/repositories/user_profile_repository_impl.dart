import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';
import 'package:twitter_clone/features/user_profile/data/data_source/user_profile_remote_data_source.dart';
import 'package:twitter_clone/features/user_profile/domain/repositories/user_profile_repoistory.dart';

class UserProfileRepositoryImpl implements UserProfileRepoistory {
  final UserProfileRemoteDataSource _userProfileRemoteDataSource;
  UserProfileRepositoryImpl({
    required UserProfileRemoteDataSource userProfileRemoteDataSource,
  }) : _userProfileRemoteDataSource = userProfileRemoteDataSource;
  @override
  FutureEither<List<Tweetmodel>> getUserTweets(String userId) async {
    try {
      final response = await _userProfileRemoteDataSource.getUserTweets(userId);
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
