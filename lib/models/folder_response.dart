// To parse this JSON data, do
//
//     final folder2ModelResponse = folder2ModelResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/folder_2model.dart';

Folder2ModelResponse folder2ModelResponseFromJson(String str) =>
    Folder2ModelResponse.fromJson(json.decode(str));

String folder2ModelResponseToJson(Folder2ModelResponse data) =>
    json.encode(data.toJson());

class Folder2ModelResponse {
  List<Folder2Model> folders;

  Folder2ModelResponse({
    required this.folders,
  });

  factory Folder2ModelResponse.fromJson(Map<String, dynamic> json) =>
      Folder2ModelResponse(
        folders: List<Folder2Model>.from(
            json["folders"].map((x) => Folder2Model.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "folders": List<dynamic>.from(folders.map((x) => x.toJson())),
      };
}
