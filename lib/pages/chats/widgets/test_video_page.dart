import 'package:agora_uikit/agora_uikit.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/bloc/videocall/video_call_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestVidePage extends StatefulWidget {
  final bool isCalling;

  const TestVidePage({super.key, required this.isCalling});

  @override
  State<TestVidePage> createState() => _TestVidePageState();
}

class _TestVidePageState extends State<TestVidePage> {
  late VideoCallBloc videoCallBloc;
  late UsuariosBloc usuariosBloc;

  @override
  void initState() {
    super.initState();
    videoCallBloc = BlocProvider.of<VideoCallBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    initAgora();
  }

  void initAgora() async {
    try {
      await videoCallBloc.agoraClient!.initialize();
      if (widget.isCalling) {
        videoCallBloc.startTimer();
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<VideoCallBloc, VideoCallState>(
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: AgoraVideoViewer(
                  showNumberOfUsers: true,
                  client: videoCallBloc.agoraClient!,
                  layoutType: Layout.floating,
                  enableHostControls: true, // Add this to enable host controls
                ),
              ),
              BlocListener<VideoCallBloc, VideoCallState>(
                listener: (context, stateHandler) async {
                  if (stateHandler.recordDuration >= 30) {
                    Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER,
                        msg: "${videoCallBloc.nombre} no Atendio la Llamada");
                    Navigator.pop(context);
                  }
                },
                child: AgoraVideoButtons(
                  cloudRecordingEnabled: false,
                  onDisconnect: () async {
                    Navigator.pop(context);
                    await FlutterCallkitIncoming.endAllCalls();
                  },
                  switchCameraButtonChild: CircleAvatar(
                    backgroundColor: state.switchCamera
                        ? Colors.blue[700]
                        : Colors.transparent,
                    radius: 25,
                    child: IconButton(
                        onPressed: () {
                          videoCallBloc.switchCamera(state.switchCamera);
                        },
                        icon: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                        )),
                  ),
                  extraButtons: [
                    CircleAvatar(
                      backgroundColor: state.isEnabledVirtualBackgroundImage
                          ? Colors.blue[700]
                          : Colors.grey[500],
                      child: IconButton(
                          onPressed: () async {
                            await videoCallBloc.enableVirtualBackground(
                                state.isEnabledVirtualBackgroundImage);
                          },
                          icon: const Icon(
                            Icons.door_front_door_outlined,
                            color: Colors.white,
                          )),
                    ),
                  ],
                  client: videoCallBloc.agoraClient!,
                  addScreenSharing: false, // Add this to enable screen sharing
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoCallBloc.dispose();
  }
}
