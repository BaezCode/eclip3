part of 'usuarios_bloc.dart';

class UsuariosState {
  final List<Usuario> usuarios;
  final int indexHome;
  final int groupValue;
  final bool cofreOpen;
  final bool conectado;
  final bool loading;
  final bool enChat;
  final bool enLlamada;
  final bool reenviar;

  UsuariosState({
    this.usuarios = const [],
    this.indexHome = 0,
    this.groupValue = 0,
    this.cofreOpen = false,
    this.conectado = false,
    this.loading = false,
    this.enChat = false,
    this.enLlamada = false,
    this.reenviar = false,
  });

  UsuariosState copyWith({
    List<Usuario>? usuarios,
    int? indexHome,
    int? groupValue,
    bool? cofreOpen,
    bool? conectado,
    bool? loading,
    bool? enChat,
    bool? estoyEnChat,
    bool? enLlamada,
    bool? reenviar,
  }) =>
      UsuariosState(
        usuarios: usuarios ?? this.usuarios,
        indexHome: indexHome ?? this.indexHome,
        groupValue: groupValue ?? this.groupValue,
        cofreOpen: cofreOpen ?? this.cofreOpen,
        conectado: conectado ?? this.conectado,
        loading: loading ?? this.loading,
        enChat: enChat ?? this.enChat,
        enLlamada: enLlamada ?? this.enLlamada,
        reenviar: reenviar ?? this.reenviar,
      );
}
