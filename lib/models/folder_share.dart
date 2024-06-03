// To parse this JSON data, do
//
//     final folderShare = folderShareFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/folder_2model.dart';

FolderShare folderShareFromJson(String str) =>
    FolderShare.fromJson(json.decode(str));

String folderShareToJson(FolderShare data) => json.encode(data.toJson());

class FolderShare {
  String nombre;
  List<Folder2Model> archives;

  FolderShare({
    required this.nombre,
    required this.archives,
  });

  factory FolderShare.fromJson(Map<String, dynamic> json) => FolderShare(
        nombre: json["nombre"],
        archives: List<Folder2Model>.from(
            json["archives"].map((x) => Folder2Model.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "archives": List<dynamic>.from(archives.map((x) => x.toJson())),
      };
}
