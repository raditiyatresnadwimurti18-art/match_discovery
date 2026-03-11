import 'package:flutter/material.dart';
import 'package:match_discovery/database/preferences.dart';
import 'package:match_discovery/database/sql_lite.dart';

class HistoryUser extends StatefulWidget {
  const HistoryUser({super.key});

  @override
  State<HistoryUser> createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  Future<List<Map<String, dynamic>>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _initHistory();
  }

  void _initHistory() async {
    int? id = await PreferenceHandler.getId();
    if (id != null) {
      setState(() {
        // Panggil fungsi getRiwayat yang sudah diperbaiki di DBHelper
        _historyFuture = DBHelper.getRiwayatUser(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Saya"),
      ), // Tambahkan AppBar agar rapi
      body: _historyFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                // ... logic snapshot sama seperti kode Anda ...

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      // Gunakan Card agar tampilannya lebih menarik
                      child: ListTile(
                        leading: const Icon(
                          Icons.event_available,
                          color: Colors.blue,
                        ),
                        title: Text(
                          item['judul'] ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${item['lokasi']} • ${item['tanggal']}",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
