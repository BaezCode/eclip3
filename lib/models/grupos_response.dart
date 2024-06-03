// To parse this JSON data, do
//
//     final gruposResponse = gruposResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/grupo_model.dart';

GruposResponse gruposResponseFromJson(String str) =>
    GruposResponse.fromJson(json.decode(str));

String gruposResponseToJson(GruposResponse data) => json.encode(data.toJson());

class GruposResponse {
  bool ok;
  List<Grupo> grupos;

  GruposResponse({
    required this.ok,
    required this.grupos,
  });

  factory GruposResponse.fromJson(Map<String, dynamic> json) => GruposResponse(
        ok: json["ok"],
        grupos: List<Grupo>.from(json["grupos"].map((x) => Grupo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "grupos": List<dynamic>.from(grupos.map((x) => x.toJson())),
      };
}
