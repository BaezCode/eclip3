// To parse this JSON data, do
//
//     final folder2Model = folder2ModelFromJson(jsonString);

import 'dart:convert';

Folder2Model folder2ModelFromJson(String str) =>
    Folder2Model.fromJson(json.decode(str));

String folder2ModelToJson(Folder2Model data) => json.encode(data.toJson());

class Folder2Model {
  Folder2Model({
    required this.userID,
    required this.sub,
    required this.clase,
    required this.titulo,
    required this.tipo,
    required this.nombre,
    this.listaFold,
    required this.imagen,
    required this.cuerpo,
    required this.fecha,
    required this.updated,
    required this.time,
    required this.uid,
  });
  String userID;
  int sub;
  int clase;
  String titulo;
  int tipo;
  String nombre;
  List<Folder2Model>? listaFold;
  String imagen;
  String cuerpo;
  String fecha;
  String updated;
  String time;
  String uid;

  factory Folder2Model.fromJson(Map<String, dynamic> json) => Folder2Model(
        userID: json["userID"],
        sub: json["sub"],
        clase: json["clase"],
        titulo: json["titulo"],
        tipo: json["tipo"],
        nombre: json["nombre"],
        listaFold: [],
        imagen: json["imagen"],
        cuerpo: json["cuerpo"],
        fecha: json["fecha"],
        updated: json["updated"],
        time: json["time"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "sub": sub,
        "clase": clase,
        "titulo": titulo,
        "tipo": tipo,
        "nombre": nombre,
        "listaFold": listaFold,
        "imagen": imagen,
        "cuerpo": cuerpo,
        "fecha": fecha,
        "updated": updated,
        "time": time,
        "uid": uid,
      };
}
