part of 'master_bloc.dart';

@immutable
abstract class MasterEvent {}

class GetUsuarios extends MasterEvent {
  final List<Usuario> usuarios;

  GetUsuarios(this.usuarios);
}

class SetContacto extends MasterEvent {
  final Usuario contacts;

  SetContacto(this.contacts);
}
