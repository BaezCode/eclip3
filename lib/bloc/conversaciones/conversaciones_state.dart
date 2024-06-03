part of 'conversaciones_bloc.dart';

class ConversacionesState {
  final List<Conversaciones> conversaciones;
  final bool loading;
  final int selectedGroup;
  final List<Grupo> grupos;
  final bool entro;

  ConversacionesState(
      {this.conversaciones = const [],
      this.loading = false,
      this.selectedGroup = 0,
      this.grupos = const [],
      this.entro = false});

  ConversacionesState copyWith(
          {List<Conversaciones>? conversaciones,
          bool? loading,
          int? selectedGroup,
          List<Grupo>? grupos,
          bool? entro}) =>
      ConversacionesState(
          conversaciones: conversaciones ?? this.conversaciones,
          loading: loading ?? this.loading,
          selectedGroup: selectedGroup ?? this.selectedGroup,
          grupos: grupos ?? this.grupos,
          entro: entro ?? this.entro);
}
