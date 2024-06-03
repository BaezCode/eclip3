part of 'notes_bloc.dart';

class NotesState {
  final String titulo;
  final bool appBarActive;
  final double textSize;
  final bool updated;
  final bool activePin;
  final bool pass;
  final bool loading;
  final List<Folder2Model> folders;
  final Folder2Model? seleccionado;
  final bool mover;
  final List<Folder2Model> compartirFolders;
  final bool compartirFol;
  final String nombreCompartir;

  NotesState(
      {this.titulo = 'Title',
      this.appBarActive = true,
      this.textSize = 18,
      this.updated = false,
      this.activePin = false,
      this.pass = false,
      this.loading = false,
      this.folders = const [],
      this.seleccionado,
      this.mover = false,
      this.compartirFolders = const [],
      this.compartirFol = false,
      this.nombreCompartir = ''});

  NotesState copyWith(
          {String? titulo,
          bool? appBarActive,
          double? textSize,
          bool? updated,
          bool? activePin,
          int? orderValue,
          bool? pass,
          bool? loading,
          List<Folder2Model>? folders,
          Folder2Model? seleccionado,
          bool? mover,
          List<Folder2Model>? compartirFolders,
          bool? compartirFol,
          String? nombreCompartir}) =>
      NotesState(
          titulo: titulo ?? this.titulo,
          appBarActive: appBarActive ?? this.appBarActive,
          textSize: textSize ?? this.textSize,
          updated: updated ?? this.updated,
          activePin: activePin ?? this.activePin,
          pass: pass ?? this.pass,
          loading: loading ?? this.loading,
          folders: folders ?? this.folders,
          seleccionado: seleccionado ?? this.seleccionado,
          mover: mover ?? this.mover,
          compartirFolders: compartirFolders ?? this.compartirFolders,
          compartirFol: compartirFol ?? this.compartirFol,
          nombreCompartir: nombreCompartir ?? this.nombreCompartir);
}
