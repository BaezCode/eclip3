part of 'video_call_bloc.dart';

@immutable
abstract class VideoCallEvent {}

class SetIsJoinded extends VideoCallEvent {
  final bool isJoined;

  SetIsJoinded(this.isJoined);
}

class SetSwitchCamera extends VideoCallEvent {
  final bool switchCamera;

  SetSwitchCamera(this.switchCamera);
}

class SetVideo extends VideoCallEvent {
  final bool video;

  SetVideo(this.video);
}

class SetloadingCall extends VideoCallEvent {
  final bool loading;

  SetloadingCall(this.loading);
}

class SetEnableBackround extends VideoCallEvent {
  final bool isEnabledVirtualBackgroundImage;

  SetEnableBackround(this.isEnabledVirtualBackgroundImage);
}

class SetMicroPhoneStatus extends VideoCallEvent {
  final bool microphone;

  SetMicroPhoneStatus(this.microphone);
}

class SetContactUID extends VideoCallEvent {
  final int contactUID;

  SetContactUID(this.contactUID);
}

class SetRecordDuration extends VideoCallEvent {
  final int recordDuration;

  SetRecordDuration(this.recordDuration);
}
