import 'dart:io';

import 'package:flutter/material.dart';
import 'package:match_discovery/database/preferences.dart';
import 'package:match_discovery/database/sql_lite.dart';
import 'package:match_discovery/extension/navigator.dart';
import 'package:match_discovery/home/history_lomba.dart';
import 'package:match_discovery/home/isihome.dart';
import 'package:match_discovery/home/profil.dart';
import 'package:match_discovery/home/tambah_lomba.dart';
import 'package:match_discovery/login/login.dart';
import 'package:match_discovery/models/login_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const List<Widget> _widgetOption = <Widget>[
    IsiHome(),
    HistoryLomba(),
    TambahLomba(),
  ];
  int _selectIndex = 0;
  void _ketikaDitekan(int index2) {
    _selectIndex = index2;
    setState(() {});
  }

  int? _userId;
  LoginModel? _user;
  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchUserData();
  }

  Future<void> _loadUserId() async {
    int? id = await PreferenceHandler.getId();
    setState(() {
      _userId = id;
    });
  }

  Future<void> _fetchUserData() async {
    if (_userId != null) {
      var data = await DBHelper.getUserById(_userId!);
      setState(() {
        _user = data; // Pastikan data ini berisi profilePath terbaru
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logof1.png'),
        title: Text('Discovery', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              context.push(ProfilUser());
            },
            icon: ClipOval(
              child:
                  _user?.profilePath != null && _user!.profilePath!.isNotEmpty
                  ? Image.file(
                      File(_user!.profilePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 80),
                    )
                  : const Icon(Icons.person, size: 80),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: const Color.fromARGB(255, 105, 105, 105),
            height: 1,
          ),
        ),
      ),
      body: Center(child: _widgetOption.elementAt(_selectIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Daftarkan'),
        ],
        currentIndex: _selectIndex,
        onTap: _ketikaDitekan,

        // selectedItemColor: Colors.blueAccent,
      ),
    );
  }
}
