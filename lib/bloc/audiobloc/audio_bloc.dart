import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  Timer? _timer;
  // Initialise

  AudioBloc() : super(AudioState()) {
    on<SetTimer>((event, emit) {
      emit(state.copyWith(
          recordDuration: event.recordDuration,
          seconds: event.seconds,
          minutes: event.minutes,
          path: ''));
    });
    on<StopStart>((event, emit) {
      emit(state.copyWith(stop: event.stop));
    });
    on<SetPath>((event, emit) {
      emit(state.copyWith(
          totalDuration: '${state.minutes}:${state.seconds}',
          stop: event.stop,
          path: event.path));
    });
    on<SetDuration>((event, emit) {
      emit(state.copyWith(duration: event.duration));
    });
    on<SetPosition>((event, emit) {
      emit(state.copyWith(position: event.position));
    });

    on<ChargerAudio>((event, emit) {
      emit(state.copyWith(path: event.path));
    });
    on<SetisRecording>((event, emit) {
      emit(state.copyWith(isRecording: event.isRecording));
    });
    on<SetIdPlay>((event, emit) {
      emit(state.copyWith(idPlay: event.idPlay));
    });
    on<SetIsplaying>((event, emit) {
      emit(state.copyWith(isPlaying: event.isPlaying));
    });
  }

  void starTimer(int timer) {
    int duration0 = timer == 0 ? 0 : state.recordDuration;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      duration0++;
      String minutes = _formatNumber(duration0 ~/ 60);
      String seconds = _formatNumber(duration0 % 60);
      add(SetTimer(minutes, seconds, duration0));
    });
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  String formatTime(Duration duration) {
    String towDigits(int n) => n.toString().padLeft(2, '0');
    final hours = towDigits(duration.inHours);
    final minutes = towDigits(duration.inMinutes.remainder(60));
    final seconds = towDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
