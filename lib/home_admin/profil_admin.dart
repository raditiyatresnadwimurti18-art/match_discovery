import 'dart:io';

import 'package:flutter/material.dart';
import 'package:match_discovery/database/preferences.dart';
import 'package:match_discovery/database/sql_lite.dart';
import 'package:match_discovery/extension/navigator.dart';
import 'package:match_discovery/login/login.dart';
import 'package:match_discovery/models/login_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && _user != null) {
      // 1. Update ke Database
      await DBHelper.updateUserProfile(_user!.id!, image.path);

      // 2. Refresh data di UI
      _fetchUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    }
  }

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
                    child: Stack(
                      // Gunakan Stack agar bisa menaruh tombol edit di atas foto
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff0f2a55),
                              width: 4.0,
                            ),
                          ),
                          child: ClipOval(
                            child:
                                _user?.profilePath != null &&
                                    _user!.profilePath!.isNotEmpty
                                ? Image.file(
                                    File(_user!.profilePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.person, size: 80),
                                  )
                                : const Icon(Icons.person, size: 80),
                          ),
                        ),
                        // Tombol Edit
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xff0f2a55),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
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
