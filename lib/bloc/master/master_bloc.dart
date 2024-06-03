import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/login_response.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/models/usuarios.response.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  Usuario? usuario;
  final prefs = PreferenciasUsuario();
  MasterBloc() : super(MasterState()) {
    on<GetUsuarios>((event, emit) {
      emit(state.copyWith(usuarios: event.usuarios));
    });
    on<SetContacto>((event, emit) {
      emit(state.copyWith(contacts: event.contacts));
    });
  }

  Future<bool> updateUsuario(
    String valido,
    String idUser,
  ) async {
    final data = {
      'valido': valido,
      'idUser': idUser,
    };
    try {
      final uri = Uri.parse("${Environment.apiUrl}/usuarios/update/master");
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

  Future<bool> updateSenha(
    String password,
    String idUser,
  ) async {
    try {
      final data = {'id': idUser, 'password': password};
      final uri = Uri.parse("${Environment.apiUrl}/login/change");
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

  Future<bool> updateVideoLlamada(
    bool updated,
    String idUser,
  ) async {
    try {
      final data = {'id': idUser, 'updated': updated};
      final uri = Uri.parse("${Environment.apiUrl}/login/video");
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        state.contacts!.videoLlamada = updated;
        add(SetContacto(state.contacts!));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser(Usuario usuario) async {
    try {
      final uri = Uri.parse(
          "${Environment.apiUrl}/usuarios/delete/master/${usuario.uid}");
      final resp = await http.post(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        state.usuarios.remove(usuario);
        add(GetUsuarios(state.usuarios));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(
      String email, String password, String idCorto, String valido) async {
    final data = {
      "email": email.trim(),
      "password": password.trim(),
      "idCorto": idCorto,
      "valido": int.parse(valido)
    };

    try {
      final uri = Uri.parse("${Environment.apiUrl}/login/new");
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        state.usuarios.add(loginResponse.usuario);
        add(GetUsuarios(state.usuarios));
        return true;
      } else {
        final loginResponse = jsonDecode(resp.body);
        prefs.msgError = loginResponse['msg'];
        return false;
      }
    } catch (e) {
      prefs.msgError = 'Error Contacte con Soporte';
      return false;
    }
  }

  Future<bool> getUsuarios(String myid) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/usuarios/master");

      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });

      if (resp.statusCode == 200) {
        final List<Usuario> lista =
            usuariosResponseFromJson(resp.body).usuarios;
        final datos = lista.where((i) => i.uid != myid).toList();
        add(GetUsuarios(datos));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
