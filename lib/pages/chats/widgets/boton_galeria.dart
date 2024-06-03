import 'dart:convert';
import 'dart:io';

import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:images_picker/images_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class BotonGaleria extends StatefulWidget {
  const BotonGaleria({
    super.key,
  });

  @override
  State<BotonGaleria> createState() => _BotonGaleriaState();
}

class _BotonGaleriaState extends State<BotonGaleria>
    with TickerProviderStateMixin {
  late SocketBloc socketBloc;
  late LoginBloc loginBloc;
  late MsgBloc msgBloc;
  late ConversacionesBloc conversacionesBloc;
  late UsuariosBloc usuariosBloc;
  late GruposBloc gruposBloc;

  var uid = const Uuid();
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    socketBloc = BlocProvider.of<SocketBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return IconButton(
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (bc) {
              return Theme(
                data: ThemeData.dark(),
                child: CupertinoActionSheet(
                  cancelButton: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar")),
                  actions: [
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          _camera();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.camera,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              data.tab76,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          _seleccionargaleria();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.photo,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              data.tab75,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          CustomContact.buildCompartirContacto(context);
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Contacto",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                    /*
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          _video();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.video_camera,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              data.tab77,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                        */
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          CustomWIdgets.dialogTimerDelete(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.time,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              data.tab74,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(
          CupertinoIcons.add,
          color: Colors.blue[700],
        ));
  }

  _video() async {
    conversacionesBloc.noPin = true;
    final resp = await ImagesPicker.openCamera(
      pickType: PickType.video,
      maxSize: 500,
      quality: 0.1,
      maxTime: 7, // record video max time
    );
    if (resp == null) {
      conversacionesBloc.noPin = false;

      return;
    } else {
      File file = File(resp[0].path);
      final info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      final uidFinal = uid.v4();
      final newMessage = MsgModel(
        replyDe: msgBloc.state.replyDe,
        replyMsg: msgBloc.state.replyMsg,
        replyType: msgBloc.state.replyType,
        leido: 0,
        uid: uidFinal,
        nombre: loginBloc.usuario!.nombre,
        type: 'video',
        createdAt: DateTime.now().toUtc(),
        de: loginBloc.usuario!.uid,
        para: msgBloc.para,
        mensaje: 'loading',
      );
      await msgBloc.addChats(newMessage, true);
      final secureURL = await msgBloc.uploadImage(info!.path!);
      msgBloc.state.messages[0].mensaje = secureURL;
      msgBloc.add(SetMsgs(msgBloc.state.messages));
      socketBloc.socket.emit('mensaje-personal', {
        "de": loginBloc.usuario!.uid,
        "nombre": loginBloc.usuario!.nombre,
        "para": msgBloc.para,
        "lastID": loginBloc.usuario!.idCorto,
        "leido": usuariosBloc.state.enChat ? 2 : 1,
        "uid": uidFinal,
        "mensaje": secureURL,
        "tokenPush": msgBloc.tokenPush,
        "type": 'video',
        "timer": prefs.timerDelete
      });
      conversacionesBloc.noPin = false;
    }
  }

  _camera() async {
    conversacionesBloc.noPin = true;
    List<Media>? res = await ImagesPicker.openCamera(
      cropOpt: CropOption(),
      maxSize: 500,
      quality: 0.6,
      language: Language.System,
      pickType: PickType.image,
    );

    if (res == null) {
      conversacionesBloc.noPin = false;
      return;
    } else if (mounted) {
      for (var element in res) {
        File file = File(element.path);
        String img64 = base64Encode(file.readAsBytesSync());
        final uidFinal = uid.v4();
        final newMessage = MsgModel(
          replyDe: msgBloc.state.replyDe,
          replyMsg: msgBloc.state.replyMsg,
          replyType: msgBloc.state.replyType,
          leido: 0,
          uid: uidFinal,
          nombre: loginBloc.usuario!.nombre,
          type: 'image',
          createdAt: DateTime.now().toUtc(),
          de: loginBloc.usuario!.uid,
          tokenPush: msgBloc.grupo == false ? msgBloc.tokenPush : '',
          tokenGroup: msgBloc.grupo == false
              ? []
              : List.generate(gruposBloc.state.usuarios.length,
                  (index) => gruposBloc.state.usuarios[index].tokenPush!),
          para: msgBloc.para,
          mensaje: img64,
        );
        await msgBloc.addChats(newMessage, true);
        if (msgBloc.grupo) {
          msgBloc.add(SetReplyChat(false, '', '', ''));

          await msgBloc.enviarMensajeGrupo(newMessage, prefs.timerDelete);
        } else {
          msgBloc.add(SetReplyChat(false, '', '', ''));

          await msgBloc.enviarMensaje(
              newMessage, prefs.timerDelete, usuariosBloc.state.enChat);
        }
        conversacionesBloc.noPin = false;
      }
    }
  }

  _seleccionargaleria() async {
    conversacionesBloc.noPin = true;

    List<Media>? res = await ImagesPicker.pick(
      cropOpt: CropOption(),
      maxSize: 500,
      quality: 0.6,
      language: Language.System,
      count: 10,
      pickType: PickType.image,
    );
    if (res == null) {
      conversacionesBloc.noPin = false;

      return;
    } else if (mounted) {
      for (var element in res) {
        File file = File(element.path);
        String img64 = base64Encode(file.readAsBytesSync());
        final uidFinal = uid.v4();
        final newMessage = MsgModel(
          replyDe: msgBloc.state.replyDe,
          replyMsg: msgBloc.state.replyMsg,
          replyType: msgBloc.state.replyType,
          leido: 0,
          uid: uidFinal,
          nombre: loginBloc.usuario!.nombre,
          type: 'image',
          createdAt: DateTime.now().toUtc(),
          de: loginBloc.usuario!.uid,
          tokenPush: msgBloc.grupo == false ? msgBloc.tokenPush : '',
          tokenGroup: msgBloc.grupo == false
              ? []
              : List.generate(gruposBloc.state.usuarios.length,
                  (index) => gruposBloc.state.usuarios[index].tokenPush!),
          para: msgBloc.para,
          mensaje: img64,
        );
        await msgBloc.addChats(newMessage, true);
        if (msgBloc.grupo) {
          msgBloc.add(SetReplyChat(false, '', '', ''));

          await msgBloc.enviarMensajeGrupo(newMessage, prefs.timerDelete);
        } else {
          msgBloc.add(SetReplyChat(false, '', '', ''));
          await msgBloc.enviarMensaje(
              newMessage, prefs.timerDelete, usuariosBloc.state.enChat);
        }
        /*
        socketBloc.socket.emit('mensaje-personal', {
          "de": loginBloc.usuario!.uid,
          "para": msgBloc.para,
          "lastID": loginBloc.usuario!.idCorto,
          "nombre": loginBloc.usuario!.nombre,
          "leido": usuariosBloc.state.enChat ? 2 : 1,
          "uid": uidFinal,
          "tokenPush": msgBloc.tokenPush,
          "mensaje": img64,
          "type": 'image',
          "timer": prefs.timerDelete
        });
        await msgBloc.addChats(newMessage);
        */
        conversacionesBloc.noPin = false;
      }
    }
  }
}
