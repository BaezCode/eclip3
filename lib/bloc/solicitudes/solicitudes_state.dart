part of 'solicitudes_bloc.dart';

class SolicitudesState {
  final List<Solicitudes> solicitudes;
  final List<Usuario> usuariosSolicitudes;
  final bool loadingSolicitudes;

  SolicitudesState({
    this.solicitudes = const [],
    this.usuariosSolicitudes = const [],
    this.loadingSolicitudes = false,
  });

  SolicitudesState copyWith({
    List<Solicitudes>? solicitudes,
    List<Usuario>? usuariosSolicitudes,
    bool? loadingSolicitudes,
  }) =>
      SolicitudesState(
          solicitudes: solicitudes ?? this.solicitudes,
          usuariosSolicitudes: usuariosSolicitudes ?? this.usuariosSolicitudes,
          loadingSolicitudes: loadingSolicitudes ?? this.loadingSolicitudes);
}
