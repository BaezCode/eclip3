part of 'llamadas_bloc.dart';

class LlamadasState {
  final bool enLlamada;
  final List<Call> calls;
  final bool loadingCalls;
  final bool isJoined;
  final bool openMicrophone;
  final bool enableSpeakerphone;
  final bool playEffect;
  final int recordDuration;

  LlamadasState(
      {this.enLlamada = false,
      this.calls = const [],
      this.loadingCalls = false,
      this.isJoined = false,
      this.openMicrophone = true,
      this.enableSpeakerphone = false,
      this.playEffect = false,
      this.recordDuration = 0});

  LlamadasState copyWith(
          {bool? enLlamada,
          List<Call>? calls,
          bool? loadingCalls,
          bool? isJoined,
          bool? openMicrophone,
          bool? enableSpeakerphone,
          bool? playEffect,
          int? recordDuration}) =>
      LlamadasState(
          enLlamada: enLlamada ?? this.enLlamada,
          calls: calls ?? this.calls,
          loadingCalls: loadingCalls ?? this.loadingCalls,
          isJoined: isJoined ?? this.isJoined,
          openMicrophone: openMicrophone ?? this.openMicrophone,
          enableSpeakerphone: enableSpeakerphone ?? this.enableSpeakerphone,
          playEffect: playEffect ?? this.playEffect,
          recordDuration: recordDuration ?? this.recordDuration);
}
