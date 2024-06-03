part of 'audio_bloc.dart';

class AudioState {
  final int recordDuration;
  final String seconds;
  final String minutes;
  final bool stop;
  final String path;
  final Duration duration;
  final Duration position;
  final bool isRecording;
  final String totalDuration;
  final String idPlay;
  final bool isPlaying;

  AudioState(
      {this.recordDuration = 0,
      this.minutes = '00',
      this.seconds = '00',
      this.stop = false,
      this.path = '',
      this.duration = Duration.zero,
      this.position = Duration.zero,
      this.isRecording = false,
      this.totalDuration = '00:00',
      this.idPlay = '',
      this.isPlaying = false});

  AudioState copyWith({
    int? recordDuration,
    String? seconds,
    String? minutes,
    bool? stop,
    String? path,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    bool? isRecording,
    String? totalDuration,
    String? idPlay,
  }) =>
      AudioState(
          recordDuration: recordDuration ?? this.recordDuration,
          seconds: seconds ?? this.seconds,
          minutes: minutes ?? this.minutes,
          stop: stop ?? this.stop,
          path: path ?? this.path,
          duration: duration ?? this.duration,
          position: position ?? this.position,
          isPlaying: isPlaying ?? this.isPlaying,
          isRecording: isRecording ?? this.isRecording,
          totalDuration: totalDuration ?? this.totalDuration,
          idPlay: idPlay ?? this.idPlay);
}
