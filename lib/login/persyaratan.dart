import 'package:flutter/material.dart';
import 'package:match_discovery/extension/navigator.dart';
import 'package:match_discovery/home/home.dart';

class Persyaratan extends StatefulWidget {
  const Persyaratan({super.key});

  @override
  State<Persyaratan> createState() => _PersyaratanState();
}

class _PersyaratanState extends State<Persyaratan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Text('Selamat Datang')),
            ElevatedButton(
              onPressed: () {
                context.pushAndRemoveAll(Home());
              },
              child: Text('Masuk Home'),
            ),
          ],
        ),
      ),
    );
  }
}
