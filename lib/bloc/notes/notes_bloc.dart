import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/models/folder_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  DateTime now = DateTime.now();
  Map<String, TextStyle> patter = {};
  Folder2Model? carpeta;
  List<Folder2Model> lista = [];
  NotesBloc() : super(NotesState()) {
    on<SetTitulo>((event, emit) {
      emit(state.copyWith(titulo: event.titulo));
    });
    on<AppBarActive>((event, emit) {
      emit(state.copyWith(appBarActive: event.appBarActive));
    });
    on<SetTextSize>((event, emit) {
      emit(state.copyWith(textSize: event.textSize));
    });

    on<ChargeData>((event, emit) {
      emit(state.copyWith(
        updated: event.updated,
        titulo: event.titulo,
      ));
    });
    on<ClearNotes>((event, emit) {
      emit(state.copyWith(
        updated: false,
        titulo: 'Title',
      ));
    });
    on<ActivePin>((event, emit) {
      emit(state.copyWith(activePin: event.activePin));
    });

    on<SetAprovado>((event, emit) {
      emit(state.copyWith(pass: event.pass));
    });
    on<SetLoadingFolders>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });
    on<SetFolders>((event, emit) {
      emit(state.copyWith(folders: event.folders));
    });
    on<SetSeleccionado>((event, emit) {
      emit(state.copyWith(
        mover: event.mover,
        seleccionado: event.seleccionado,
      ));
    });
    on<SetCompartirFolders>((event, emit) {
      emit(state.copyWith(
          compartirFol: event.compartirFol,
          compartirFolders: event.compartirFolders,
          nombreCompartir: event.nombreCompartir));
    });
  }

  void clearALL() {
    add(SetSeleccionado(null, false));
    add(SetCompartirFolders(const [], false, ''));
  }

  void removeArchive(
    Folder2Model data,
  ) {
    final index = state.compartirFolders.indexWhere(
      (element) => element.uid == data.uid,
    );
    lista.removeAt(index);
    add(SetCompartirFolders(lista, true, state.nombreCompartir));
  }

  void cancelar() {
    lista = [];
    add(SetCompartirFolders(lista, false, ''));
  }

  void compartirFolder(
    Folder2Model data,
  ) {
    final index = state.compartirFolders.indexWhere(
      (element) => element.uid == data.uid,
    );
    if (index != -1) {
      lista.removeAt(index);
      add(SetCompartirFolders(lista, true, state.nombreCompartir));
    } else {
      lista.add(data);
      add(SetCompartirFolders(lista, true, state.nombreCompartir));
    }
  }

  Future<bool> folderInserMany(
      List<Folder2Model> lista, Map<String, Object> folder) async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/savemany");
    try {
      final data = {'lista': lista, 'data': folder};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> mostrarFolder(List<String> lista, String id) async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/shared");
    try {
      final data = {'lista': lista, 'id': id};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final folderModel = folder2ModelFromJson(resp.body);
        final index = state.folders
            .indexWhere((element) => element.uid == folderModel.uid);
        state.folders[index] = folderModel;
        add(SetFolders(state.folders));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFolder(String id) async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/shared/remove");
    try {
      final data = {'id': id};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final index = state.folders.indexWhere(
          (element) => element.uid == id,
        );
        state.folders.removeAt(index);
        add(SetFolders(state.folders));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFolders(String id) async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/eliminar/$id");
    try {
      final resp = await http.post(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        state.folders.removeWhere((element) => element.uid == id);
        add(SetFolders(state.folders));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> cargarScanPorClase(int clase, int tipo) async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/clase");
    try {
      final data = {'clase': clase, 'tipo': tipo};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final folderModel = folder2ModelResponseFromJson(resp.body);
        add(SetFolders(folderModel.folders));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> nuevoFolderDB(int tipo, String nombre, int clase, String cuerpo,
      String image, String time, String userID) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    var random = Random();
    final uri = Uri.parse("${Environment.apiUrl}/folder/");
    try {
      final data = {
        'userID': userID,
        'cuerpo': cuerpo,
        'imagen': image,
        'selected': 0,
        'tipo': tipo,
        'sub': random.nextInt(100000000) * 5,
        'clase': clase,
        'nombre': nombre,
        'fecha': formattedDate,
        'time': time
      };
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final folderModel = folder2ModelFromJson(resp.body);
        state.folders.insert(0, folderModel);
        add(SetFolders(state.folders));

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Folder2Model>> getFolders(int tipo) async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/$tipo");
    try {
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final folderModel = folder2ModelResponseFromJson(resp.body);
        add(SetFolders(folderModel.folders));
        return folderModel.folders;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Folder2Model>> getSharedFiles() async {
    final uri = Uri.parse("${Environment.apiUrl}/folder/shared/files");
    try {
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final folderModel = folder2ModelResponseFromJson(resp.body);
        add(SetFolders(folderModel.folders));
        return folderModel.folders;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateFolderDB(
      Folder2Model prodData,
      String titulo,
      String cuerpo,
      int tipo,
      String? images,
      String? time,
      String userID) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    final nuevoFolder = Folder2Model(
        tipo: tipo,
        uid: prodData.uid,
        updated: prodData.updated,
        sub: prodData.sub,
        userID: userID,
        clase: prodData.clase,
        nombre: titulo,
        titulo: titulo,
        imagen: images!,
        cuerpo: cuerpo,
        fecha: formattedDate,
        time: time!);

    final uri = Uri.parse("${Environment.apiUrl}/folder/update");
    try {
      final data = {'folderModel': nuevoFolder};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final index =
            state.folders.indexWhere((element) => element.uid == prodData.uid);
        state.folders[index] = nuevoFolder;
        add(SetFolders(state.folders));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> moverScan(Folder2Model prodData, String userID) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    final nuevoFolder = Folder2Model(
        uid: prodData.uid,
        updated: prodData.updated,
        userID: userID,
        tipo: carpeta != null ? carpeta!.sub : 1,
        clase: prodData.clase,
        nombre: prodData.nombre,
        titulo: prodData.titulo,
        imagen: prodData.imagen,
        sub: prodData.sub,
        cuerpo: prodData.cuerpo,
        fecha: formattedDate,
        time: prodData.time);

    final uri = Uri.parse("${Environment.apiUrl}/folder/update");
    try {
      final data = {'folderModel': nuevoFolder};
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        state.folders.add(nuevoFolder);
        add(SetFolders(state.folders));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
