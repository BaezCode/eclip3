part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class Loading extends LoginEvent {
  final bool loading;

  Loading(this.loading);
}

class SetPassed extends LoginEvent {
  final bool passed;

  SetPassed(this.passed);
}

class SetUid extends LoginEvent {
  final String uid;

  SetUid(this.uid);
}

class SetUsuario extends LoginEvent {
  final Usuario usuario;

  SetUsuario(this.usuario);
}
