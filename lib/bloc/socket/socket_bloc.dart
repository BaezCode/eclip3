import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  late IO.Socket _socket;
  final prefs = PreferenciasUsuario();
  bool enLlamada = false;

  SocketBloc() : super(SocketState()) {
    on<SetServerStatus>((event, emit) {
      emit(state.copyWith(online: event.online));
    });
  }

  Future<bool> inhabilitar(bool value, String uid) async {
    try {
      final data = {"habilitado": value, "uid": uid};
      final uri = Uri.parse("${Environment.apiUrl}/usuarios/inhabilitar");
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  IO.Socket get socket => _socket;

  Future<void> connect() async {
    final token = await LoginBloc.getToken();
    // Dart client
    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {
      add(SetServerStatus(true));
    });

    _socket.on('disconnect', (_) {
      add(SetServerStatus(false));
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
