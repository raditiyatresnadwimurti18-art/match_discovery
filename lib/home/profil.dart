import 'package:flutter/material.dart';
import 'package:match_discovery/database/preferences.dart';
import 'package:match_discovery/database/sql_lite.dart';
import 'package:match_discovery/extension/navigator.dart';
import 'package:match_discovery/login/login.dart';
import 'package:match_discovery/models/login_model.dart';

class ProfilUser extends StatefulWidget {
  const ProfilUser({super.key});

  @override
  State<ProfilUser> createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfilUser> {
  LoginModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    int? id = await PreferenceHandler.getId();
    if (id != null) {
      LoginModel? data = await DBHelper.getUserById(id);

      setState(() {
        _user = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff0f2a55),
        title: Text('Profil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: const Color.fromARGB(255, 105, 105, 105),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 61, 77, 104), // Biru muda lembut
                    Colors.white, // Putih bersih
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 4.0,
                        ),
                      ),
                      // Hapus padding negatif tadi!
                      child: ClipOval(
                        child: Transform.scale(
                          scale:
                              1.4, // Mengatur seberapa besar ikon/gambar (1.5 = 150%)
                          child: const FittedBox(
                            fit: BoxFit.cover,
                            child: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Selamat datang ${_user?.nama ?? 'memuat...'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  PreferenceHandler.deleteId();
                  PreferenceHandler.deleteIsLogin();
                  context.pushAndRemoveAll(Login());
                },
                child: Text('Log Out'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
