import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/chat_response.dart';
import 'package:eclips_3/models/conversaciones.dart';
import 'package:eclips_3/models/conversaciones_response.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:eclips_3/models/grupos_response.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'conversaciones_event.dart';
part 'conversaciones_state.dart';

class ConversacionesBloc
    extends Bloc<ConversacionesEvent, ConversacionesState> {
  final prefs = PreferenciasUsuario();
  Conversaciones? conversaciones;
  List<ChatResponse> folders = [];
  bool noPin = false;
  bool inPop = false;
  ConversacionesBloc() : super(ConversacionesState()) {
    on<SetListConv>((event, emit) {
      emit(state.copyWith(conversaciones: event.conversaciones));
    });

    on<LoadingConv>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });
    on<SelectedGroup>((event, emit) {
      emit(state.copyWith(selectedGroup: event.selectedGroup));
    });
    on<SetListGrupos>((event, emit) {
      emit(state.copyWith(grupos: event.grupos));
    });
    on<SetEntro>((event, emit) {
      emit(state.copyWith(entro: event.entro));
    });
  }

  Future<bool> getGrupos() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/grupos");
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final data = gruposResponseFromJson(resp.body);
        add(SetListGrupos(data.grupos));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void updateOrCreateConv(List<MsgModel> msg, String contactUID) {
    final index = state.conversaciones.indexWhere(
        (element) => element.de == contactUID || element.para == contactUID);
    if (index == -1) {
    } else {
      state.conversaciones[index].msg = msg.reversed.toList();
      add(SetListConv(state.conversaciones));
    }
  }

  Future<bool> deleteChats(String uidConv, String idContact) async {
    try {
      final body = {
        'convID': uidConv,
        'mensajesDe': idContact,
      };
      final uri = Uri.parse("${Environment.apiUrl}/conversaciones/delete");
      final resp = await http.post(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
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

  Future<bool> deleteMensajes(String de) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/mensajes/delete/$de");
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final index = state.conversaciones
            .indexWhere((element) => element.uid == conversaciones!.uid);
        if (index != -1) {
          state.conversaciones[index].msg = [];
          add(SetListConv(state.conversaciones));
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getConversaciones() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/conversaciones");
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final response = conversacionesResponseFromJson(resp.body);
        add(SetListConv(response.conversaciones));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
