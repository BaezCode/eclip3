part of 'video_call_bloc.dart';

class VideoCallState {
  final bool isJoined;
  final bool switchCamera;
  final bool switchRender;
  final bool video;
  final bool loading;
  final bool isEnabledVirtualBackgroundImage;
  final bool microphone;
  final int contactUID;
  final int recordDuration;

  VideoCallState(
      {this.isJoined = false,
      this.switchCamera = true,
      this.switchRender = false,
      this.video = false,
      this.loading = false,
      this.isEnabledVirtualBackgroundImage = false,
      this.microphone = false,
      this.contactUID = 0,
      this.recordDuration = 0});

  VideoCallState copyWith(
          {bool? isJoined,
          bool? switchCamera,
          bool? switchRender,
          bool? video,
          bool? loading,
          bool? isEnabledVirtualBackgroundImage,
          bool? microphone,
          int? contactUID,
          int? recordDuration}) =>
      VideoCallState(
          isJoined: isJoined ?? this.isJoined,
          switchCamera: switchCamera ?? this.switchCamera,
          switchRender: switchRender ?? this.switchRender,
          video: video ?? this.video,
          loading: loading ?? this.loading,
          microphone: microphone ?? this.microphone,
          contactUID: contactUID ?? this.contactUID,
          recordDuration: recordDuration ?? this.recordDuration,
          isEnabledVirtualBackgroundImage: isEnabledVirtualBackgroundImage ??
              this.isEnabledVirtualBackgroundImage);
}
