import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/models/usuarios.response.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'grupos_event.dart';
part 'grupos_state.dart';

class GruposBloc extends Bloc<GruposEvent, GruposState> {
  GruposBloc() : super(GruposState()) {
    on<SetLoadingGrupos>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });

    on<SetListUsuariosGroup>((event, emit) {
      emit(state.copyWith(usuarios: event.usuarios));
    });
    on<SetGrupo>((event, emit) {
      emit(state.copyWith(grupo: event.grupo));
    });
  }

  Future<bool> deleteGroup(Grupo grupo) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/grupos/delete");
      final data = {
        'uid': grupo.uid,
      };
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

  Future<bool> createGroup(String nombre, String img, List<String> integrantes,
      List<String> admins, String uidmy) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/grupos");
      final list = List.generate(1, (index) => uidmy);
      final data = {
        'nombre': nombre,
        'img': img,
        'leido': list,
        'integrantes': integrantes,
        'admins': admins
      };
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

  Future<bool> getIntegrantes() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/grupos/integrantes");
      final data = {'lista': state.grupo!.integrantes};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final data = usuariosResponseFromJson(resp.body);
        add(SetListUsuariosGroup(data.usuarios));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateGroup() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/grupos/update");
      final data = {'grupo': state.grupo};
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
}
