part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class AuthStatusSubscriptionRequested extends AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  AuthLoginRequested({required this.username, required this.password});
}

final class AuthLogoutRequested extends AuthEvent {}
