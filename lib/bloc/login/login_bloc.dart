import 'dart:convert';

import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/login_response.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Usuario? usuario;
  final key = Key.fromLength(32);
  final iv = IV.fromLength(16);
  final prefs = PreferenciasUsuario();

  LoginBloc() : super(LoginState()) {
    on<Loading>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });
    on<SetPassed>((event, emit) {
      emit(state.copyWith(passed: event.passed));
    });
    on<SetUid>((event, emit) {
      emit(state.copyWith(uid: event.uid));
    });
    on<SetUsuario>((event, emit) {
      emit(state.copyWith(usuario: event.usuario));
    });
    init();
  }
  void init() async {
    await isLoggedIn();
  }

  static Future<void> deletoken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: "token");
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: "token") ?? "";
    final uri = Uri.parse("${Environment.apiUrl}/login/renew/${prefs.voipID}");

    try {
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      });
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        add(SetUsuario(usuario!));
        add(SetUid(usuario!.uid));
        prefs.nombreUsuario = usuario!.nombre!;
        prefs.idCorto = usuario!.idCorto!;
        await _guardarToken(loginResponse.token);
        return true;
      } else {
        // logout();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      return token!;
    } catch (e) {
      return '';
    }
  }

  Future _guardarToken(String token) async {
    return await storage.write(key: "token", value: token);
  }

  Future<bool> login(String email, String password, String imeiNo) async {
    final encrypter = Encrypter(AES(key));

    final data = {
      "email": email.trim(),
      "password": password.trim(),
      "iMEI": imeiNo
    };

    add(Loading(true));
    try {
      final uri = Uri.parse("${Environment.apiUrl}/login");
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      add(Loading(false));
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        add(SetUsuario(usuario!));
        prefs.idCat = encrypter.encrypt(usuario!.uid, iv: iv).base64;
        prefs.idCorto = usuario!.idCorto!;
        await _guardarToken(loginResponse.token);
        return true;
      } else {
        final loginResponse = jsonDecode(resp.body);
        prefs.msgError = loginResponse['msg'];
        return false;
      }
    } catch (e) {
      prefs.msgError = 'Error Contacte con Soporte';
      return false;
    }
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    try {
      final respose = Usuario.fromJson(json['user']);
      usuario = respose;
      return LoginState(uid: json['uid'], usuario: respose);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    return {'uid': state.uid, 'user': state.usuario};
  }
}
