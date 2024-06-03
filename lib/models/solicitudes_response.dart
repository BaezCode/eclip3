// To parse this JSON data, do
//
//     final solicitudesResponse = solicitudesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/solicitudes_model.dart';

SolicitudesResponse solicitudesResponseFromJson(String str) =>
    SolicitudesResponse.fromJson(json.decode(str));

String solicitudesResponseToJson(SolicitudesResponse data) =>
    json.encode(data.toJson());

class SolicitudesResponse {
  Solicitudes solicitudes;

  SolicitudesResponse({
    required this.solicitudes,
  });

  factory SolicitudesResponse.fromJson(Map<String, dynamic> json) =>
      SolicitudesResponse(
        solicitudes: Solicitudes.fromJson(json["solicitudes"]),
      );

  Map<String, dynamic> toJson() => {
        "solicitudes": solicitudes.toJson(),
      };
}
