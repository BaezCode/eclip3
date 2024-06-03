import 'package:eclips_3/models/usuario.dart';

class Call {
  Call({
    required this.de,
    required this.para,
    required this.mensaje,
    this.usuario,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });
  String de;
  String para;
  String mensaje;
  Usuario? usuario;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        usuario: null,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "usuario": usuario,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}
