// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.nombre,
    this.newName,
    this.tokenPush,
    required this.email,
    this.online,
    required this.valido,
    required this.uid,
    required this.rol,
    required this.selected,
    required this.createdAt,
    this.idCorto,
    this.habilitado,
    required this.enLlamada,
    this.uidCall,
    this.muteAudio = false,
    this.isJoinded = false,
    required this.call,
    this.voipID,
    required this.groupCall,
    this.videoLlamada,
    this.palabra,
    this.estadoCall = "Escuchando",
    this.iMEI,
  });

  String? nombre;
  String? newName;
  String? tokenPush;
  String email;
  bool? online;
  int? valido;
  String uid;
  String rol;
  bool? selected;
  String? createdAt;
  String? idCorto;
  bool enLlamada;
  bool? habilitado;
  int? uidCall;
  bool muteAudio;
  bool isJoinded;
  bool call;
  String? voipID;
  bool groupCall;
  bool? videoLlamada;
  String? palabra;
  String estadoCall;
  String? iMEI;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        newName: json["newName"],
        tokenPush: json["tokenPush"],
        email: json["email"],
        online: json["online"],
        valido: json["valido"],
        uid: json["uid"],
        rol: json["rol"],
        selected: json["selected"],
        createdAt: json["createdAt"],
        idCorto: json["idCorto"],
        habilitado: json["habilitado"],
        uidCall: json["uidCall"],
        muteAudio: false,
        isJoinded: false,
        call: json["call"],
        voipID: json["voipID"],
        groupCall: json["groupCall"],
        videoLlamada: json["videoLlamada"],
        palabra: json["palabra"],
        estadoCall: "Escuchando",
        enLlamada: json["enLlamada"],
        iMEI: json["iMEI"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "newName": newName,
        "tokenPush": tokenPush,
        "email": email,
        "online": online,
        "valido": valido,
        "uid": uid,
        "rol": rol,
        "selected": selected,
        "createdAt": createdAt,
        "idCorto": idCorto,
        "habilitado": habilitado,
        "uidCall": uidCall,
        "muteAudio": muteAudio,
        "isJoinded": isJoinded,
        "call": call,
        "voipID": voipID,
        "groupCall": groupCall,
        "videoLlamada": videoLlamada,
        "palabra": palabra,
        "enLlamada": enLlamada,
        "estadoCall": estadoCall,
        "iMEI": iMEI,
      };
}
