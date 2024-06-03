part of 'server_bloc.dart';

@immutable
abstract class ServerEvent {}

class SetServer extends ServerEvent {
  final Grupo server;

  SetServer(this.server);
}
