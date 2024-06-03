part of 'grupos_bloc.dart';

class GruposState {
  final List<Grupo> grupos;
  final bool loading;
  final List<Usuario> usuarios;
  final Grupo? grupo;

  GruposState(
      {this.grupos = const [],
      this.loading = false,
      this.usuarios = const [],
      this.grupo});

  GruposState copyWith(
          {List<Grupo>? grupos,
          bool? loading,
          List<Usuario>? usuarios,
          Grupo? grupo}) =>
      GruposState(
          grupos: grupos ?? this.grupos,
          loading: loading ?? this.loading,
          usuarios: usuarios ?? this.usuarios,
          grupo: grupo ?? this.grupo);
}
