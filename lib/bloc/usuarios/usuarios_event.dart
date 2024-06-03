part of 'usuarios_bloc.dart';

@immutable
abstract class UsuariosEvent {}

class GetUsuarios extends UsuariosEvent {
  final List<Usuario> usuarios;

  GetUsuarios(this.usuarios);
}

class SelectIndex extends UsuariosEvent {
  final int indexHome;

  SelectIndex(this.indexHome);
}

class GroupValue extends UsuariosEvent {
  final int groupValue;

  GroupValue(this.groupValue);
}

class SetCofreOpen extends UsuariosEvent {
  final bool cofreOpen;

  SetCofreOpen(this.cofreOpen);
}

class SetConectado extends UsuariosEvent {
  final bool conectado;

  SetConectado(this.conectado);
}

class SetLoading extends UsuariosEvent {
  final bool loading;

  SetLoading(this.loading);
}

class SetEnChat extends UsuariosEvent {
  final bool enChat;

  SetEnChat(this.enChat);
}

class SetEnLlamada extends UsuariosEvent {
  final bool enLlamada;

  SetEnLlamada(this.enLlamada);
}

class SetReenviar extends UsuariosEvent {
  final bool reenviar;

  SetReenviar(
    this.reenviar,
  );
}
