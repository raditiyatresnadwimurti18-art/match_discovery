import 'package:flutter/material.dart';
import 'package:match_discovery/extension/navigator.dart';
import 'package:match_discovery/login/persyaratan.dart';

class Reggister extends StatelessWidget {
  const Reggister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Image.asset('assets/images/logof1.png', height: 300),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                  icon: Icon(Icons.email),
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                  icon: Icon(Icons.password),
                  hintText: 'Pasword',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                  icon: Icon(Icons.person),
                  hintText: 'Nama',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                  icon: Icon(Icons.phone),
                  hintText: 'No Tlpon',
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(Persyaratan());
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Daftar',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),

                            Icon(
                              Icons.chevron_right,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
