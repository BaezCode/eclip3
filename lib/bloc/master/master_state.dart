part of 'master_bloc.dart';

class MasterState {
  final List<Usuario> usuarios;
  Usuario? contacts;

  MasterState({this.usuarios = const [], this.contacts});

  MasterState copyWith(
          {final List<Usuario>? usuarios, final Usuario? contacts}) =>
      MasterState(
          usuarios: usuarios ?? this.usuarios,
          contacts: contacts ?? this.contacts);
}
