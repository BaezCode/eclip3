part of 'solicitudes_bloc.dart';

@immutable
abstract class SolicitudesEvent {}

class SetSolicitudesList extends SolicitudesEvent {
  final List<Solicitudes> solicitudes;

  SetSolicitudesList(this.solicitudes);
}

class SetUsuarioSolicitudes extends SolicitudesEvent {
  final List<Usuario> usuariosSolicitudes;

  SetUsuarioSolicitudes(this.usuariosSolicitudes);
}

class SetLoadingSolicitudes extends SolicitudesEvent {
  final bool loadingSolicitudes;

  SetLoadingSolicitudes(this.loadingSolicitudes);
}
