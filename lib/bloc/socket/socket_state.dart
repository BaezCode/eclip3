part of 'socket_bloc.dart';

class SocketState {
  final bool online;

  SocketState({
    this.online = false,
  });

  SocketState copyWith({
    bool? online,
  }) =>
      SocketState(
        online: online ?? this.online,
      );
}
