import 'package:flutter/material.dart';

class Widget2 extends StatefulWidget {
  const Widget2({super.key});

  @override
  State<Widget2> createState() => _Widget2State();
}

class _Widget2State extends State<Widget2> {
  String selectedCategory = 'Semua';
  final List<String> categories = ['Semua', 'Teknologi', 'Olahraga', 'Desain'];

  // Fungsi untuk membangun tampilan konten di dalam Card
  Widget _buildContent() {
    String deskripsi = '';
    IconData icon = Icons.info_outline;

    switch (selectedCategory) {
      case 'Teknologi':
        deskripsi = 'Gadget terbaru, AI, dan tutorial coding harian.';
        icon = Icons.terminal;
        break;
      case 'Bisnis':
        deskripsi = 'Update pasar saham, tips startup, dan strategi marketing.';
        icon = Icons.trending_up;
        break;
      case 'Desain':
        deskripsi = 'Inspirasi UI/UX, teori warna, dan tren branding.';
        icon = Icons.palette;
        break;
      default:
        deskripsi = 'Jelajahi berbagai kompetisi dari semua kategori.';
        icon = Icons.explore;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF6366F1)),
          const SizedBox(height: 10),
          Text(
            deskripsi,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris Chip Kategori
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              bool isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: const Color(0xFF6366F1),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.grey[100],
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 15),

        // Tampilan Konten dengan Card (Hapus Expanded di sini)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _buildContent(),
        ),
      ],
    );
  }
}
