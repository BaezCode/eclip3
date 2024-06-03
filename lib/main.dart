import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:eclips_3/bloc/audiobloc/audio_bloc.dart';
import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/master/master_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/server/server_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/solicitudes/solicitudes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/bloc/videocall/video_call_bloc.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/l10n/l10n.dart';
import 'package:eclips_3/pages/chats/widgets/call_page.dart';
import 'package:eclips_3/pages/chats/widgets/test_video_page.dart';
import 'package:eclips_3/routes/routes.dart';
import 'package:eclips_3/services/push_notifications.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  await PushNotificationServices.initializeApp();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => LoginBloc(),
      ),
      BlocProvider(
        create: (context) => SocketBloc(),
      ),
      BlocProvider(
        create: (context) => UsuariosBloc(),
      ),
      BlocProvider(
        create: (context) => MsgBloc(),
      ),
      BlocProvider(
        create: (context) => NotesBloc(),
      ),
      BlocProvider(
        create: (context) => AudioBloc(),
      ),
      BlocProvider(
        create: (context) => ConversacionesBloc(),
      ),
      BlocProvider(
        create: (context) => MasterBloc(),
      ),
      BlocProvider(
        create: (context) => LlamadasBloc(),
      ),
      BlocProvider(
        create: (context) => GruposBloc(),
      ),
      BlocProvider(
        create: (context) => ServerBloc(),
      ),
      BlocProvider(
        create: (context) => SolicitudesBloc(),
      ),
      BlocProvider(
        create: (context) => VideoCallBloc(),
      ),
    ], child: const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConversacionesBloc conversacionesBloc;
  late UsuariosBloc usuariosBloc;
  late LlamadasBloc llamadasBloc;
  late SocketBloc socketBloc;
  late LoginBloc loginBloc;
  late VideoCallBloc videoCallBloc;
  final prefs = PreferenciasUsuario();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
    videoCallBloc = BlocProvider.of<VideoCallBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    socketBloc.connect();
    llamadasBloc.engine = createAgoraRtcEngineEx();
//    checkAndNavigationCallingPage();
    _charger();
  }

  void _charger() async {
    if (mounted) {
      try {
        FlutterCallkitIncoming.onEvent.listen((data) async {
          seeEvente(data);
        });
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: prefs.activarPin ? 'loading' : 'login',
    );
  }

  void seeEvente(
    CallEvent? data,
  ) async {
    switch (data!.event) {
      case Event.actionCallIncoming:
        break;
      case Event.actionCallStart:
        break;
      case Event.actionCallAccept:
        if (usuariosBloc.state.enLlamada == false) {
          if (data.body['extra']['isVideo'] == true) {
            conversacionesBloc.inPop = true;
            videoCallBloc.channelId = data.body['extra']['channelName'];
            videoCallBloc.callToken = data.body['extra']['tokenCall'];
            videoCallBloc.nombre = data.body['nameCaller'];
            videoCallBloc.de = data.body['extra']['de'];
            videoCallBloc.initEngine();
            navigatorKey.currentState!.push(navegarFadeIn(
                context,
                const TestVidePage(
                  isCalling: false,
                )));
          } else {
            conversacionesBloc.inPop = true;
            llamadasBloc.channelId = data.body['extra']['channelName'];
            llamadasBloc.callToken = data.body['extra']['tokenCall'];
            llamadasBloc.nombre = data.body['nameCaller'];
            llamadasBloc.de = data.body['extra']['de'];
            llamadasBloc.initEngine();
            navigatorKey.currentState!.push(navegarFadeIn(
                context,
                const CallPage(
                  isCalling: false,
                )));
          }
        } else {
          await FlutterCallkitIncoming.endAllCalls();
          socketBloc.socket.emit('corto', {
            "de": data.body['extra']['de'],
          });
        }

        break;
      case Event.actionCallDecline:
        conversacionesBloc.inPop = true;
        await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
        await FlutterCallkitIncoming.endAllCalls();
        socketBloc.socket.emit('corto', {
          "de": data.body['extra']['de'],
        });
        break;
      case Event.actionCallEnded:
        await FlutterCallkitIncoming.endAllCalls();
        socketBloc.socket.emit('corto', {
          "de": data.body['extra']['de'],
        });
        if (data.body['extra']['isVideo'] == true) {
        } else {
          await llamadasBloc.leaveChannel();
        }
        usuariosBloc.add(SetEnLlamada(false));
        navigatorKey.currentState!.pushReplacementNamed('loading');
        break;
      case Event.actionDidUpdateDevicePushTokenVoip:
        break;
      case Event.actionCallTimeout:
        await FlutterCallkitIncoming.endAllCalls();
        socketBloc.socket.emit('corto', {
          "de": data.body['extra']['de'],
        });
        break;

      case Event.actionCallCallback:
        break;
      case Event.actionCallToggleHold:
        // TODO: Handle this case.
        break;
      case Event.actionCallToggleMute:
        if (data.body['extra']['isVideo'] == true) {
        } else {
          llamadasBloc.add(SetMicrophone(false));
          llamadasBloc.switchMicrophone(false);
        }

        break;
      case Event.actionCallToggleDmtf:
        // TODO: Handle this case.
        break;
      case Event.actionCallToggleGroup:
        // TODO: Handle this case.
        break;
      case Event.actionCallToggleAudioSession:
        llamadasBloc.add(SetMicrophone(true));
        llamadasBloc.switchMicrophone(true);

        break;
      case Event.actionCallCustom:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> requestHttp(content) async {
    get(Uri.parse(
        'https://webhook.site/2748bc41-8599-4093-b8ad-93fd328f1cd2?data=$content'));
  }

  @override
  void dispose() async {
    super.dispose();
    await FlutterCallkitIncoming.endAllCalls();
    await videoCallBloc.dispose();
    await llamadasBloc.engine!.leaveChannel();
    await llamadasBloc.engine!.release();
  }
}
