part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class SignUpFailure extends AuthState {
  final String message;
  SignUpFailure({required this.message});
}

final class SignUpSuccess extends AuthState {
  final UserEntity user;
  SignUpSuccess({required this.user});
}

final class SignInFailure extends AuthState {
  final String message;
  SignInFailure({required this.message});
}

final class SignInSuccess extends AuthState {
  final UserEntity user;
  SignInSuccess({required this.user});
}

final class CurrentUserFailure extends AuthState {
  final String message;
  CurrentUserFailure({required this.message});
}

final class CurrentUserExist extends AuthState {
  final UserEntity user;
  CurrentUserExist({required this.user});
}
