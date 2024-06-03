part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class SetTitulo extends NotesEvent {
  final String titulo;

  SetTitulo(this.titulo);
}

class AppBarActive extends NotesEvent {
  final bool appBarActive;

  AppBarActive(this.appBarActive);
}

class SetTextSize extends NotesEvent {
  final double textSize;

  SetTextSize(this.textSize);
}

class SetContent extends NotesEvent {
  final String contenido;

  SetContent(this.contenido);
}

class ChargeData extends NotesEvent {
  final String titulo;
  final bool updated;

  ChargeData(this.titulo, this.updated);
}

class ClearNotes extends NotesEvent {}

class ActivePin extends NotesEvent {
  final bool activePin;

  ActivePin(this.activePin);
}

class SetAprovado extends NotesEvent {
  final bool pass;

  SetAprovado(this.pass);
}

class SetLoadingFolders extends NotesEvent {
  final bool loading;

  SetLoadingFolders(this.loading);
}

class SetFolders extends NotesEvent {
  final List<Folder2Model> folders;

  SetFolders(this.folders);
}

class SetSeleccionado extends NotesEvent {
  final Folder2Model? seleccionado;
  final bool mover;

  SetSeleccionado(
    this.seleccionado,
    this.mover,
  );
}

class SetCompartirFolders extends NotesEvent {
  final List<Folder2Model> compartirFolders;
  final bool compartirFol;
  final String nombreCompartir;

  SetCompartirFolders(
      this.compartirFolders, this.compartirFol, this.nombreCompartir);
}
