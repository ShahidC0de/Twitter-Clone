part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  SignUpEvent({
    required this.email,
    required this.password,
  });
}
