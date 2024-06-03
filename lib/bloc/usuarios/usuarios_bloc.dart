import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/models/usuarios.response.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

part 'usuarios_event.dart';
part 'usuarios_state.dart';

class UsuariosBloc extends HydratedBloc<UsuariosEvent, UsuariosState> {
  var uuid = const Uuid();
  final prefs = PreferenciasUsuario();
  int contador = 0;

  UsuariosBloc() : super(UsuariosState()) {
    on<GetUsuarios>((event, emit) {
      emit(state.copyWith(usuarios: event.usuarios));
    });

    on<SelectIndex>((event, emit) {
      emit(state.copyWith(indexHome: event.indexHome));
    });
    on<GroupValue>((event, emit) {
      emit(state.copyWith(groupValue: event.groupValue));
    });
    on<SetCofreOpen>((event, emit) {
      emit(state.copyWith(cofreOpen: event.cofreOpen));
    });
    on<SetConectado>((event, emit) {
      emit(state.copyWith(conectado: event.conectado));
    });
    on<SetLoading>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });

    on<SetEnChat>((event, emit) {
      emit(state.copyWith(enChat: event.enChat));
    });

    on<SetEnLlamada>((event, emit) {
      emit(state.copyWith(enLlamada: event.enLlamada));
    });
    on<SetReenviar>((event, emit) {
      emit(state.copyWith(
        reenviar: event.reenviar,
      ));
    });

    _loading();
  }

  void _loading() async {
    await getUsuarios();
  }

  Future selectedIndex(int index) async {
    add(SelectIndex(index));
  }

  void changeContactName(Usuario usuario, String nombre) {
    final index = state.usuarios.indexOf(usuario);
    state.usuarios[index].newName = nombre;
    add(GetUsuarios(state.usuarios));
  }

  Future<bool> deleteUser(Usuario usuario) async {
    try {
      final uri =
          Uri.parse("${Environment.apiUrl}/usuarios/delete/${usuario.uid}");
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

  Future<bool> updateUsuario(
    String nombre,
    String? palabra,
  ) async {
    final data = {
      'nombre': nombre,
      'tokenPush': prefs.tokenPush,
      'palabra': palabra
    };
    try {
      final uri = Uri.parse("${Environment.apiUrl}/usuarios/update");
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        prefs.nombreUsuario = nombre;

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addUser(String idSoli, Usuario usuario) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/usuarios/add");
      final data = {'uidUser': usuario.uid, 'idSoli': idSoli};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });

      switch (resp.statusCode) {
        case 400:
          return false;
        case 200:
          state.usuarios.add(usuario);
          add(GetUsuarios(state.usuarios));
          return true;
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getUsuarios() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/usuarios");

      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });

      if (resp.statusCode == 200) {
        final List<Usuario> lista =
            usuariosResponseFromJson(resp.body).usuarios;
        for (var element in state.usuarios) {
          final index = lista.indexWhere((data) => data.uid == element.uid);
          if (index == -1) {
          } else {
            lista[index].newName = element.newName;
          }
        }
        add(GetUsuarios(lista));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  UsuariosState? fromJson(Map<String, dynamic> json) {
    try {
      final lista =
          List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x)));
      return UsuariosState(usuarios: lista);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UsuariosState state) {
    return {
      'usuarios': state.usuarios,
    };
  }
}
