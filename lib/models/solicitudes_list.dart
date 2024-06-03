// To parse this JSON data, do
//
//     final solicitudesList = solicitudesListFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/solicitudes_model.dart';

SolicitudesList solicitudesListFromJson(String str) =>
    SolicitudesList.fromJson(json.decode(str));

String solicitudesListToJson(SolicitudesList data) =>
    json.encode(data.toJson());

class SolicitudesList {
  List<Solicitudes> solicitudes;

  SolicitudesList({
    required this.solicitudes,
  });

  factory SolicitudesList.fromJson(Map<String, dynamic> json) =>
      SolicitudesList(
        solicitudes: List<Solicitudes>.from(
            json["solicitudes"].map((x) => Solicitudes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "solicitudes": List<dynamic>.from(solicitudes.map((x) => x.toJson())),
      };
}
