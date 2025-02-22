import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/user_profile/domain/usecases/get_user_tweet.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserTweetUseCase _getUserTweetsUsecase;

  UserProfileBloc({
    required GetUserTweetUseCase getUserTweetUsecase,
  })  : _getUserTweetsUsecase = getUserTweetUsecase,
        super(UserProfileInitial()) {
    on<GetUserTweetsEvent>(_getUserTweets);
  }

  Future<void> _getUserTweets(
      GetUserTweetsEvent event, Emitter<UserProfileState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _getUserTweetsUsecase.call(GetUserTweetParams(
        userId: event.userId,
      ));
      response.fold((failure) {
        emit(state.copyWith(errorMessage: failure.message));
      }, (success) {
        emit(state.copyWith(isLoading: false, userTweets: success));
      });
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
