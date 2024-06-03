part of 'server_bloc.dart';

class ServerState {
  final String password;
  final Grupo? server;

  ServerState({this.password = '', this.server});

  ServerState copyWith({String? password, Grupo? server}) => ServerState(
      password: password ?? this.password, server: server ?? this.server);
}
