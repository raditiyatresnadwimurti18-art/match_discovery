import 'package:flutter/material.dart';
import 'package:match_discovery/extension/navigator.dart';
import 'package:match_discovery/login/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.pushAndRemoveAll(Login());
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Center(child: Text('Hello word')),
    );
  }
}
