import 'dart:async';

import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

class PushNotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  @pragma('vm:entry-point')
  static Future _onbackgroundHandler(RemoteMessage message) async {
    if (message.data['type'] == "endCall") {
      await FlutterCallkitIncoming.endAllCalls();
    } else if (message.data['type'] == "Llamada") {}
  }

  static Future _onMessageHandle(
    RemoteMessage message,
  ) async {
    if (message.data['type'] == "endCall") {
      await FlutterCallkitIncoming.endAllCalls();
    } else if (message.data['type'] == "Llamada") {}
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    if (message.data['type'] == "endCall") {
      await FlutterCallkitIncoming.endAllCalls();
    } else if (message.data['type'] == "Llamada") {}
  }

  static requestPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future initializeApp() async {
    final prefs = PreferenciasUsuario();

    // Push Notifications
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    final tokenVOIP = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    prefs.voipID = tokenVOIP;
    prefs.token = token!;

    // Handlers
    FirebaseMessaging.onMessage.listen(_onMessageHandle);
    FirebaseMessaging.onBackgroundMessage(_onbackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    // Local Notifications
  }

  static Future setLlamada(Map<String, dynamic> data) async {
    var uid = const Uuid();
    CallKitParams callKitParams = CallKitParams(
      id: uid.v4(),
      nameCaller: data['name'], // message['name'],
      appName: 'Cryptho',
      handle: '*********',
      type: 0,
      textAccept: 'Aceptar',
      textDecline: 'Cortar',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      duration: 30000,
      extra: <String, dynamic>{
        'nombre': data['name'],
        'de': data['de'],
        'channelId': data['channelName'],
        'callToken': data['tokenCall'],
      },
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      ios: const IOSParams(
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }
}
