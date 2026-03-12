import 'package:flutter/material.dart';
import 'package:match_discovery/home_user/asset_lomba/daftar_lomba.dart';
import 'package:match_discovery/home_user/promo_lomba.dart';
import 'package:match_discovery/home_user/widget1.dart';

class IsiHomeUser extends StatefulWidget {
  const IsiHomeUser({super.key});

  @override
  State<IsiHomeUser> createState() => _IsiHomeUserState();
}

class _IsiHomeUserState extends State<IsiHomeUser> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Widget1(),
            PromoSlider(),
            SizedBox(height: 10),
            DaftarLomba(),
          ],
        ),
      ),
    );
  }
}
