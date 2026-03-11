import 'dart:io';
import 'package:flutter/material.dart';
import 'package:match_discovery/home_user/asset_lomba/daftar_lomba.dart';

class IsiHomeUser extends StatefulWidget {
  const IsiHomeUser({super.key});

  @override
  State<IsiHomeUser> createState() => _IsiHomeUserState();
}

class _IsiHomeUserState extends State<IsiHomeUser> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [DaftarLomba()]));
  }
}
