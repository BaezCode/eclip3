import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/solicitudes_list.dart';
import 'package:eclips_3/models/solicitudes_model.dart';
import 'package:eclips_3/models/solicitudes_response.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/models/usuarios.response.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'solicitudes_event.dart';
part 'solicitudes_state.dart';

class SolicitudesBloc extends Bloc<SolicitudesEvent, SolicitudesState> {
  final prefs = PreferenciasUsuario();
  SolicitudesBloc() : super(SolicitudesState()) {
    on<SetSolicitudesList>((event, emit) {
      emit(state.copyWith(solicitudes: event.solicitudes));
    });
    on<SetUsuarioSolicitudes>((event, emit) {
      emit(state.copyWith(usuariosSolicitudes: event.usuariosSolicitudes));
    });
    on<SetLoadingSolicitudes>((event, emit) {
      emit(state.copyWith(loadingSolicitudes: event.loadingSolicitudes));
    });
  }

  Future<Solicitudes?> enviarSolicitud(String de, String para) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/solicitudes");
      final data = {"de": de, "para": para};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final solicitud = solicitudesResponseFromJson(resp.body);
        state.solicitudes.add(solicitud.solicitudes);
        add(SetSolicitudesList(state.solicitudes));
        return solicitud.solicitudes;
      } else {
        final data = jsonDecode(resp.body);
        prefs.msgError = data['msg'];
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> getSolicitudes() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/solicitudes");
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final solicitud = solicitudesListFromJson(resp.body);
        add(SetSolicitudesList(solicitud.solicitudes));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Usuario>> getUsuariosSolicitudes(List<String> lista) async {
    try {
      final data = {'lista': lista};
      final uri = Uri.parse("${Environment.apiUrl}/solicitudes/usuarios");
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final usuarios = usuariosResponseFromJson(resp.body);
        add(SetUsuarioSolicitudes(usuarios.usuarios));
        return usuarios.usuarios;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> eliminarSolicitud(String id) async {
    try {
      final data = {'id': id};
      final uri = Uri.parse("${Environment.apiUrl}/solicitudes/delete");
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
