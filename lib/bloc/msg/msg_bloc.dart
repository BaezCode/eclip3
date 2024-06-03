import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/models/msg_response.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'msg_event.dart';
part 'msg_state.dart';

class MsgBloc extends Bloc<MsgEvent, MsgState> {
  Usuario? contacto;
  String para = '';
  String tokenPush = '';
  bool grupo = false;
  final key = Key.fromLength(32);
  final iv = IV.fromLength(16);
  List<MsgModel> chats = [];
  final ScrollController controller = ScrollController();

  MsgBloc() : super(MsgState()) {
    on<SetMsgs>((event, emit) {
      emit(state.copyWith(messages: event.messages));
    });
    on<SetEscribiendo>((event, emit) {
      emit(state.copyWith(estaEscribiendo: event.estaEscribiendo));
    });
    on<SetUidConv>((event, emit) {
      emit(state.copyWith(uidConv: event.uidConv));
    });
    on<SetReplyChat>((event, emit) {
      emit(state.copyWith(
          replyDe: event.replyDe,
          replyType: event.replyType,
          replyMsg: event.replyMsg,
          reply: event.reply));
    });
  }

  void loadChats() {
    chats.clear();
    add(SetMsgs(chats));
  }

  String decryptmesaje(String mesaje) {
    final encrypter = Encrypter(AES(key));
    final msg = encrypter.decrypt64(mesaje, iv: iv);
    return msg;
  }

  Future<void> addChats(MsgModel newMessage, bool enChat) async {
    final index = chats.indexWhere((element) => element.uid == newMessage.uid);
    if (index == -1) {
      if (newMessage.type == 'text') {
        final encrypter = Encrypter(AES(key));
        newMessage.mensaje =
            encrypter.encrypt(newMessage.mensaje, iv: iv).base64;
      }
      chats.insert(0, newMessage);
      add(SetMsgs(chats));
      if (enChat) {
        controller.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    } else {}
  }

  Future<bool> enviarMensaje(MsgModel msg, int time, bool enChatUser) async {
    final uri = Uri.parse("${Environment.apiUrl}/mensajes/grabar");
    try {
      final data = {'payload': msg, 'time': time, 'enChat': enChatUser};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });

      if (resp.statusCode == 200) {
        final msg = msgModelFromJson(resp.body);
        final index = chats.indexWhere(
          (element) => element.uid == msg.uid,
        );
        chats[index] = msg;
        add(SetMsgs(chats));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> enviarMensajeGrupo(MsgModel msg, int time) async {
    final uri = Uri.parse("${Environment.apiUrl}/mensajes/grabar/grupo");
    try {
      final data = {'payload': msg, 'time': time};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });

      if (resp.statusCode == 200) {
        final msg = msgModelFromJson(resp.body);
        final index = chats.indexWhere(
          (element) => element.uid == msg.uid,
        );
        chats[index] = msg;
        add(SetMsgs(chats));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMsg(List<String> lista, String userID) async {
    final uri = Uri.parse("${Environment.apiUrl}/mensajes/delete/msg");

    try {
      final data = {"lista": lista, 'userID': userID};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });

      if (resp.statusCode == 200) {
        for (var element in lista) {
          state.messages.removeWhere((data) => data.uid == element);
        }
        chats = state.messages;
        add(SetMsgs(state.messages));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getChat(String usuarioID, String idChat) async {
    final uri = Uri.parse("${Environment.apiUrl}/mensajes/nuevo/$usuarioID");

    try {
      final data = {'de': usuarioID, 'idChat': idChat};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });

      if (resp.statusCode == 200) {
        final response = mensajesResponseFromJson(resp.body);
        chats.addAll(response.mensajes.reversed.toList());
        add(SetMsgs(response.mensajes.reversed.toList()));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> enviarMensajes(List<MsgModel> lista, payload) async {
    final uri = Uri.parse("${Environment.apiUrl}/mensajes/reenviar/data");

    try {
      final data = {"lista": lista.reversed.toList(), 'payload': payload};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
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

  Future<bool> getGroupChat(String usuarioID) async {
    final uri = Uri.parse("${Environment.apiUrl}/grupos/$usuarioID");

    try {
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });

      if (resp.statusCode == 200) {
        final response = mensajesResponseFromJson(resp.body);
        chats.addAll(response.mensajes.reversed.toList());
        add(SetMsgs(response.mensajes.reversed.toList()));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadImage(String path) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/archives",
    );
    Map<String, String> headers = {"x-token": await LoginBloc.getToken()};
    try {
      final imageUplodaRequest = http.MultipartRequest(
        'POST',
        uri,
      );
      imageUplodaRequest.headers.addAll(headers);
      final file = await http.MultipartFile.fromPath('archivo', path);
      imageUplodaRequest.files.add(file);
      final streamResponse = await imageUplodaRequest.send();
      final resp = await http.Response.fromStream(streamResponse);
      if (resp.statusCode == 201) {
        final respose = jsonDecode(resp.body);
        return respose['singURL'][0];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
