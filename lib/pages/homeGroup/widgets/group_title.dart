import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupTitle extends StatelessWidget {
  const GroupTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GruposBloc, GruposState>(
      builder: (context, state) {
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, 'groupOptions');
          },
          leading: Stack(
            children: [
              if (state.grupo!.img.isEmpty)
                CircleAvatar(
                  backgroundColor: Colors.grey[700],
                  child: Text(
                    state.grupo!.nombre[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              if (state.grupo!.img.isNotEmpty)
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: MemoryImage(base64Decode(state.grupo!.img)),
                )
            ],
          ),
          title: FadeIn(
            child: Text(state.grupo!.nombre,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        );
      },
    );
  }
}
