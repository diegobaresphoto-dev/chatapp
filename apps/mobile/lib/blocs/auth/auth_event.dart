part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String identifier;
  final String password;
  LoginRequested(this.identifier, this.password);
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String username;
  final String password;
  final String inviteCode;
  RegisterRequested({
    required this.email,
    required this.username,
    required this.password,
    required this.inviteCode,
  });
}

class LogoutRequested extends AuthEvent {}
