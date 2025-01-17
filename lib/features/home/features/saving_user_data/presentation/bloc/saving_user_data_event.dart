part of 'saving_user_data_bloc.dart';

@immutable
sealed class SavingUserDataEvent {}

final class SaveUserDataEvent extends SavingUserDataEvent {
  final String uid;
  final String name;
  final String email;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final String isTwitterBlue;
  SaveUserDataEvent({
    required this.uid,
    required this.name,
    required this.email,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.bio,
    required this.isTwitterBlue,
  });
}
