import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get msgError {
    return _prefs.getString('msgError') ?? '';
  }

  set msgError(String value) {
    _prefs.setString('msgError', value);
  }

  String get idCat {
    return _prefs.getString('idCat') ?? '';
  }

  set idCat(String value) {
    _prefs.setString('idCat', value);
  }

  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String value) {
    _prefs.setString('nombreUsuario', value);
  }

  String get tokenPush {
    return _prefs.getString('tokenPush') ?? '';
  }

  set token(String value) {
    _prefs.setString('tokenPush', value);
  }

  String get idCorto {
    return _prefs.getString('idCorto') ?? '';
  }

  set idCorto(String value) {
    _prefs.setString('idCorto', value);
  }

  String get voipID {
    return _prefs.getString('voipID') ?? '';
  }

  set voipID(String value) {
    _prefs.setString('voipID', value);
  }

  int get timerDelete {
    return _prefs.getInt('timerDelete') ?? 86400;
  }

  set timerDelete(int value) {
    _prefs.setInt('timerDelete', value);
  }

  String get nameTimerDelete {
    return _prefs.getString('nameTimerDelete') ?? '24hs';
  }

  set nameTimerDelete(String value) {
    _prefs.setString('nameTimerDelete', value);
  }

  bool get activarPin {
    return _prefs.getBool('activarPin') ?? false;
  }

  set activarPin(bool value) {
    _prefs.setBool('activarPin', value);
  }

  String get pinUsuario {
    return _prefs.getString('pinUsuario') ?? '';
  }

  set pinUsuario(String value) {
    _prefs.setString('pinUsuario', value);
  }

  int get getIntentos {
    return _prefs.getInt('getIntentos') ?? 10;
  }

  set getIntentos(int value) {
    _prefs.setInt('getIntentos', value);
  }

  int get intentados {
    return _prefs.getInt('intentados') ?? 0;
  }

  set intentados(int value) {
    _prefs.setInt('intentados', value);
  }

  bool get pinCarpetasActivado {
    return _prefs.getBool('pinCarpetasActivado') ?? false;
  }

  set pinCarpetasActivado(bool value) {
    _prefs.setBool('pinCarpetasActivado', value);
  }

  String get pinCarpetas {
    return _prefs.getString('pinCarpetas') ?? 'null';
  }

  set pinCarpetas(String value) {
    _prefs.setString('pinCarpetas', value);
  }

  String get callToken {
    return _prefs.getString('callToken') ?? '';
  }

  set callToken(String value) {
    _prefs.setString('callToken', value);
  }

  String get channelId {
    return _prefs.getString('channelId') ?? '';
  }

  set channelId(String value) {
    _prefs.setString('channelId', value);
  }

  set letra(int value) {
    _prefs.setInt('letra', value);
  }

  int get letra {
    return _prefs.getInt('letra') ?? 15;
  }

  bool get eula {
    return _prefs.getBool('eula') ?? false;
  }

  set eula(bool value) {
    _prefs.setBool('eula', value);
  }
}
