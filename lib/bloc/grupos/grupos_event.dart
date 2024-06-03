part of 'grupos_bloc.dart';

@immutable
abstract class GruposEvent {}

class SetLoadingGrupos extends GruposEvent {
  final bool loading;

  SetLoadingGrupos(this.loading);
}

class SetListUsuariosGroup extends GruposEvent {
  final List<Usuario> usuarios;

  SetListUsuariosGroup(this.usuarios);
}

class SetGrupo extends GruposEvent {
  final Grupo? grupo;

  SetGrupo(this.grupo);
}
