import 'package:flutter/material.dart';
import 'package:match_discovery/database/preferences.dart';
import 'package:match_discovery/database/sql_lite.dart';

class HistoryLomba extends StatefulWidget {
  const HistoryLomba({super.key});

  @override
  State<HistoryLomba> createState() => _HistoryLombaState();
}

class _HistoryLombaState extends State<HistoryLomba> {
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Fungsi untuk mengambil ID user dari memori
  Future<void> _getUserId() async {
    int? id = await PreferenceHandler.getId();
    setState(() {
      _currentUserId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DBHelper.getRiwayatLomba(_currentUserId ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Riwayat masih kosong. Silakan ikuti lomba terlebih dahulu.",
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return ListTile(
                      title: Text(item['judul'] ?? 'No Title'),
                      subtitle: Text(item['lokasi'] ?? 'No Location'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
