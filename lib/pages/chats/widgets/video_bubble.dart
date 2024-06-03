import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/pages/chats/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VideoBubble extends StatelessWidget {
  final DateTime dateTime;
  final String texto;
  final String uid;
  final int leido;
  const VideoBubble(
      {super.key,
      required this.dateTime,
      required this.texto,
      required this.uid,
      required this.leido});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Container(
      child: uid == loginBloc.usuario!.uid
          ? _myMessage(context)
          : _notMyMessage(context),
    );
  }

  Widget _myMessage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateLocal = dateTime.toLocal();

    String formattedDate = DateFormat('kk:mm').format(dateLocal);

    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              navegarFadeIn(context, VideoPlayer(file: null, url: texto)));
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: 10, bottom: 5, left: 50),
              decoration: BoxDecoration(
                  color: const Color(0xfff20262e),
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    width: size.width * 0.55,
                    height: size.height * 0.30,
                    child: texto == 'loading'
                        ? const Center(child: CircularProgressIndicator())
                        : Image.asset(
                            'images/video.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                      bottom: 5,
                      right: 7,
                      child: Row(
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Icon(
                            _icons(leido),
                            color: Colors.black,
                            size: 13,
                          ),
                        ],
                      )),
                ],
              )),
        ));
  }

  Widget _notMyMessage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);

    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              navegarFadeIn(context, VideoPlayer(file: null, url: texto)));
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 10, bottom: 5, right: 50),
            decoration: BoxDecoration(
                color: const Color(0xffE4E5E8),
                borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Image.asset(
                  'images/video.png',
                  fit: BoxFit.cover,
                  width: size.width * 0.55,
                  height: size.height * 0.30,
                ),
                Positioned(
                  bottom: 3,
                  right: 7,
                  child: Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  IconData _icons(int leido) {
    switch (leido) {
      case 0:
        return Icons.access_time_outlined;
      case 2:
        return Icons.remove_red_eye_sharp;
      case 1:
        return Icons.panorama_fish_eye_sharp;
      default:
        return Icons.abc;
    }
  }
}
