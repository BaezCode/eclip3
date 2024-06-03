part of 'llamadas_bloc.dart';

@immutable
abstract class LlamadasEvent {}

class SetEnllamada extends LlamadasEvent {
  final bool enLlamada;

  SetEnllamada(this.enLlamada);
}

class SetLoadingCalls extends LlamadasEvent {
  final bool loadingCalls;

  SetLoadingCalls(this.loadingCalls);
}

class SetCallsList extends LlamadasEvent {
  final List<Call> calls;

  SetCallsList(this.calls);
}

class SetIsJoinded extends LlamadasEvent {
  final bool isJoined;

  SetIsJoinded(this.isJoined);
}

class SetMicrophone extends LlamadasEvent {
  final bool openMicrophone;

  SetMicrophone(this.openMicrophone);
}

class SetSpeakerPhone extends LlamadasEvent {
  final bool enableSpeakerphone;

  SetSpeakerPhone(this.enableSpeakerphone);
}

class SetEffect extends LlamadasEvent {
  final bool playEffect;

  SetEffect(this.playEffect);
}

class SetRecordDuration extends LlamadasEvent {
  final int recordDuration;

  SetRecordDuration(this.recordDuration);
}
