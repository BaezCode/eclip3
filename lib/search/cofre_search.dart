import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/pages/folders/widgets/empty_folder.dart';
import 'package:eclips_3/pages/folders/widgets/folder_body.dart';
import 'package:flutter/material.dart';

class CofreSearchDelegate extends SearchDelegate {
  final List<Folder2Model> folders;

  CofreSearchDelegate({required this.folders});

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
      return const EmptyFolder();
    } else {
      final list = folders
          .where((user) =>
              user.nombre.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
      return list.isEmpty
          ? const EmptyFolder()
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: list.length,
              itemBuilder: (ctx, i) =>
                  FadeIn(child: FolderBody(data: list[i])));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return folders.isEmpty
        ? const EmptyFolder()
        : ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: folders.length,
            itemBuilder: (ctx, i) =>
                FadeIn(child: FolderBody(data: folders[i])));
  }
}
