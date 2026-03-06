import 'package:flutter/material.dart';

class Widget1 extends StatelessWidget {
  const Widget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hallo, Peserta!\u{1F44B}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('Temukan kompetisi terbaik untuk karirmu.'),
        SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'Cari kompetisi impoanmu',
            icon: Icon(Icons.search),
            suffixIcon: Icon(Icons.filter_list),
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Kategori populer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
