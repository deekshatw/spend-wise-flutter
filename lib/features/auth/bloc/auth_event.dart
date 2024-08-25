part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  AuthLoginEvent(this.email, this.password, this.context);
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final BuildContext context;

  AuthRegisterEvent(this.name, this.email, this.password, this.context);
}
