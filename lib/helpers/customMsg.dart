import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMsg {
  CustomMsg._();

  static IconData icons(int leido) {
    switch (leido) {
      case 0:
        return Icons.access_time_outlined;
      case 2:
        return Icons.remove_red_eye_sharp;
      case 1:
        return Icons.panorama_fish_eye_sharp;
      default:
        return Icons.abc;
    }
  }

  static IconData reply(String type) {
    switch (type) {
      case 'image':
        return CupertinoIcons.photo;
      case 'audio':
        return CupertinoIcons.mic;
      case 'nota':
        return CupertinoIcons.archivebox;
      case 'folder':
        return CupertinoIcons.folder;
      case 'contacto':
        return CupertinoIcons.person;
      default:
        return Icons.abc;
    }
  }

  static String texto(String type, String texto) {
    switch (type) {
      case 'texto':
        return texto;
      case 'image':
        return 'Image File';
      case 'audio':
        return 'Mensaje de Voz';
      case 'nota':
        return 'Archivo';
      case 'folder':
        return 'Carpeta compartida';
      case 'contacto':
        return 'Contacto';
      default:
        return texto;
    }
  }
}
