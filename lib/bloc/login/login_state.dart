part of 'login_bloc.dart';

class LoginState {
  final bool loading;
  final bool passed;
  final String uid;
  final Usuario? usuario;

  LoginState(
      {this.loading = false, this.passed = false, this.uid = '', this.usuario});

  LoginState copyWith(
          {final bool? loading,
          final bool? passed,
          final String? uid,
          final Usuario? usuario}) =>
      LoginState(
          loading: loading ?? this.loading,
          passed: passed ?? this.passed,
          uid: uid ?? this.uid,
          usuario: usuario ?? this.usuario);
}
