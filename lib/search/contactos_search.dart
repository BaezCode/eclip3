import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/contactos/widgets/body_usuarios.dart';
import 'package:eclips_3/pages/contactos/widgets/empty_contacts.dart';
import 'package:flutter/material.dart';

class ContactosSearchDelegate extends SearchDelegate {
  final List<Usuario> contactos;

  ContactosSearchDelegate({required this.contactos});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      hintColor: Colors.white,
      textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.white)),
      appBarTheme: const AppBarTheme(color: Color(0xff21232A)),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return _listviewUsuarios(contactos);
    } else {
      final list = contactos
          .where((user) => user.newName != null
              ? user.newName!.toLowerCase().contains(query.trim().toLowerCase())
              : user.nombre!.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();

      return list.isEmpty ? const EmptyContacts() : _listviewUsuarios(list);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return contactos.isEmpty
        ? const EmptyContacts()
        : _listviewUsuarios(contactos);
  }

  ListView _listviewUsuarios(List<Usuario> dataresul) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => BodyUsuarios(contacts: dataresul[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: dataresul.length);
  }
}
