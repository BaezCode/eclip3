part of 'conversaciones_bloc.dart';

@immutable
abstract class ConversacionesEvent {}

class SetListConv extends ConversacionesEvent {
  final List<Conversaciones> conversaciones;

  SetListConv(
    this.conversaciones,
  );
}

class LoadingConv extends ConversacionesEvent {
  final bool loading;

  LoadingConv(this.loading);
}

class SelectedGroup extends ConversacionesEvent {
  final int selectedGroup;

  SelectedGroup(this.selectedGroup);
}

class SetListGrupos extends ConversacionesEvent {
  final List<Grupo> grupos;

  SetListGrupos(this.grupos);
}

class SetEntro extends ConversacionesEvent {
  final bool entro;

  SetEntro(this.entro);
}
