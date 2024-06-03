part of 'socket_bloc.dart';

abstract class SocketEvent {}

class SetServerStatus extends SocketEvent {
  final bool online;

  SetServerStatus(this.online);
}
