// To parse this JSON data, do
//
//     final conversacionesResponse = conversacionesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/conversaciones.dart';

ConversacionesResponse conversacionesResponseFromJson(String str) =>
    ConversacionesResponse.fromJson(json.decode(str));

String conversacionesResponseToJson(ConversacionesResponse data) =>
    json.encode(data.toJson());

class ConversacionesResponse {
  ConversacionesResponse({
    required this.ok,
    required this.conversaciones,
  });

  bool ok;
  List<Conversaciones> conversaciones;

  factory ConversacionesResponse.fromJson(Map<String, dynamic> json) =>
      ConversacionesResponse(
        ok: json["ok"],
        conversaciones: List<Conversaciones>.from(
            json["conversaciones"].map((x) => Conversaciones.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "conversaciones":
            List<dynamic>.from(conversaciones.map((x) => x.toJson())),
      };
}
