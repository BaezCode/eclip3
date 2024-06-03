// To parse this JSON data, do
//
//     final msgModel = msgModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

MsgModel msgModelFromJson(String str) => MsgModel.fromJson(json.decode(str));

String msgModelToJson(MsgModel data) => json.encode(data.toJson());

class MsgModel {
  MsgModel({
    this.id,
    required this.type,
    required this.mensaje,
    required this.createdAt,
    required this.de,
    required this.para,
    this.lastID,
    this.animated,
    this.nombre,
    this.tokenPush,
    required this.leido,
    this.tokenGroup,
    this.reenviado,
    required this.uid,
    this.enviar = false,
    this.segundos,
    this.minutos,
    this.replyDe,
    this.replyMsg,
    this.replyType,
  });
  String? id;
  String de;
  String para;
  String? lastID;
  AnimationController? animated;
  String? nombre;
  String? tokenPush;
  String mensaje;
  DateTime createdAt;
  String type;
  int leido;
  List<String>? tokenGroup;
  bool? reenviado;
  bool? enviar;
  String uid;
  String? segundos;
  String? minutos;
  String? replyDe;
  String? replyMsg;
  String? replyType;

  factory MsgModel.fromJson(Map<String, dynamic> json) => MsgModel(
        id: json["id"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        mensaje: json["mensaje"],
        de: json["de"],
        para: json["para"],
        lastID: json["lastID"],
        animated: null,
        nombre: json["nombre"],
        tokenPush: json["tokenPush"],
        leido: json["leido"],
        tokenGroup: [],
        reenviado: json["reenviado"],
        enviar: false,
        uid: json["uid"],
        segundos: json["segundos"],
        minutos: json["minutos"],
        replyDe: json["replyDe"],
        replyMsg: json["replyMsg"],
        replyType: json["replyType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "mensaje": mensaje,
        "de": de,
        "para": para,
        "lastID": lastID,
        "nombre": nombre,
        "tokenPush": tokenPush,
        "leido": leido,
        "tokenGroup": tokenGroup,
        "reenviado": reenviado,
        "enviar": enviar,
        "uid": uid,
        "segundos": segundos,
        "minutos": minutos,
        "replyDe": replyDe,
        "replyMsg": replyMsg,
        "replyType": replyType,
      };
}
