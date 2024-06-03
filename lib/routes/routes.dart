import 'package:eclips_3/pages/account/widgets/configuracion_chat.dart';
import 'package:eclips_3/pages/account/widgets/pin_carpetas.dart';
import 'package:eclips_3/pages/account/widgets/pin_seguridad.dart';
import 'package:eclips_3/pages/chats/widgets/show_image.dart';
import 'package:eclips_3/pages/contactos/contactos_page.dart';
import 'package:eclips_3/pages/contactos/widgets/compartir_folder.dart';
import 'package:eclips_3/pages/homeGroup/widgets/chat_grupos.dart';
import 'package:eclips_3/pages/homeGroup/widgets/options_group.dart';
import 'package:eclips_3/pages/login/first_1.dart';
import 'package:eclips_3/pages/login/firts_0.dart';
import 'package:eclips_3/pages/login/loading_page.dart';
import 'package:eclips_3/pages/login/login_page.dart';
import 'package:eclips_3/pages/master/master_page.dart';
import 'package:eclips_3/pages/screens/tabs_screen.dart';
import 'package:eclips_3/pages/screens/widgets/no_conexion.dart';
import 'package:eclips_3/pages/server/server_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (_) => const TabsScreen(),
  'contactos': (_) => const ContactosPage(),
  'login': (_) => const LoginPage(),
  'firts0': (_) => const First0(),
  'loading': (_) => const LoadingPage(),
  'imageshow': (_) => const ShowImagePage(),
  'seguridad': (_) => const PinSeguridad(),
  'pinCarpetas': (_) => const PinCarpetas(),
  'first1': (_) => const First1(),
  'Master': (_) => const MasterPage(),
  'offline': (_) => const NoConexionPage(),
  'groupOptions': (_) => const OptionsGroup(),
  'chatGrupo': (_) => const ChatsGrupos(),
  'callGrupo': (_) => const ServerPage(),
  'chatConfig': (_) => const ConfiguracionChat(),
  'compartirFolder': (_) => const CompartirFolder(),
};
