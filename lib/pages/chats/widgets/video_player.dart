import 'dart:io';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class VideoPlayer extends StatefulWidget {
  final String url;
  final File? file;
  const VideoPlayer({super.key, required this.url, required this.file});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late NotesBloc notesBloc;
  late LoginBloc loginBloc;

  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    videoPlayerController = widget.file == null
        ? VideoPlayerController.network(widget.url)
        : VideoPlayerController.file(widget.file!);
    videoPlayerController.initialize().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    final rs = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final action =
                      await Dialogs.yesAbortDialog(context, rs.tab84, rs.tab58);
                  if (action == DialogAction.yes && mounted) {
                    CustomWIdgets.loading(context);
                    final request = await http.get(Uri.parse(widget.url));
                    final dera = await getTemporaryDirectory();
                    final path = "${dera.path}/myFile.mp4";
                    File data =
                        await File(path).writeAsBytes(request.bodyBytes);
                    await notesBloc.nuevoFolderDB(1, ' Nuevo Video', 4, '',
                        data.path, '', loginBloc.usuario!.uid);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        msg: rs.tab89);
                  } else {}
                },
                icon: const Icon(Icons.save))
          ],
          backgroundColor: Colors.black,
          title: const Text("Video Player"),
        ),
        body: Container(
          color: Colors.black,
          child: SafeArea(
              child: const Center(
            child: CircularProgressIndicator(),
          )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }
}
