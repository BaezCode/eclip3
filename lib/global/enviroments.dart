import 'dart:io';

class Environment {
  static String apiUrl = 'https://eclips32-server.herokuapp.com/api';
  static String socketUrl = 'https://eclips32-server.herokuapp.com/';

  /*
  static String apiUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000/api'
      : 'http://192.168.10.214:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000'
      : 'http://192.168.10.214:3000';
      */
}
