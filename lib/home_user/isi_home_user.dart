import 'dart:async';
import 'package:flutter/material.dart';
import 'package:match_discovery/home_user/asset_lomba/daftar_lomba.dart';
import 'package:match_discovery/home_user/widget1.dart';

class IsiHomeUser extends StatefulWidget {
  const IsiHomeUser({super.key});

  @override
  State<IsiHomeUser> createState() => _IsiHomeUserState();
}

class _IsiHomeUserState extends State<IsiHomeUser> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  final List<String> images = [
    "assets/images/gambar1.png",
    "assets/images/gambar2.png",
    "assets/images/gambar3.png",
    "assets/images/gambar4.png",
    "assets/images/gambar5.png",
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi Timer untuk geser otomatis
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Widget1(),

            // WRAPPER UNTUK SLIDER
            SizedBox(
              height: 200, // Tentukan tinggi slider Anda
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // INDIKATOR TITIK (DOTS) - Opsional
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),

            SizedBox(height: 10),
            DaftarLomba(),
          ],
        ),
      ),
    );
  }
}
