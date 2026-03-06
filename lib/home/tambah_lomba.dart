import 'dart:io';
import 'package:flutter/material.dart';
import 'package:match_discovery/database/lomba_controller.dart';
import 'package:match_discovery/models/lomba_model.dart';

class TambahLomba extends StatefulWidget {
  const TambahLomba({super.key});

  @override
  State<TambahLomba> createState() => _TambahLombaState();
}

class _TambahLombaState extends State<TambahLomba> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _kuotaCtrl = TextEditingController();
  final _lokasiCtrl = TextEditingController();
  final _deskripsiCtrl = TextEditingController();

  String _jenisLomba = 'Teknologi';
  DateTime _selectedDate = DateTime.now();
  File? _imageFile;

  // Fungsi ambil gambar
  Future<void> _pickImage() async {
    final controller = LombaControler(); // Pastikan instance controller benar
    // final image = await controller.ambilGambar(); // Aktifkan jika sudah ada di controller
    // setState(() => _imageFile = image);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Poster
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      style: BorderStyle.none,
                    ),
                  ),
                  child: _imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              size: 40,
                              color: Colors.blue,
                            ),
                            Text(
                              "Unggah Poster",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul Lomba
            _buildLabel("Judul Lomba *"),
            TextFormField(
              controller: _judulCtrl,
              decoration: _inputDecoration("Contoh: Hackathon Nasional 2024"),
            ),

            const SizedBox(height: 15),
            // Kategori
            _buildLabel("Kategori *"),
            DropdownButtonFormField(
              value: _jenisLomba,
              items: ['Teknologi', 'Olahraga', 'Seni', 'Akademik'].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) => setState(() => _jenisLomba = val.toString()),
              decoration: _inputDecoration("Pilih Kategori"),
            ),

            const SizedBox(height: 15),
            // Lokasi
            _buildLabel("Lokasi *"),
            TextFormField(
              controller: _lokasiCtrl,
              decoration: _inputDecoration("E.g. Jakarta, Indonesia"),
            ),

            const SizedBox(height: 15),
            // Deskripsi
            _buildLabel("Deskripsi Singkat *"),
            TextFormField(
              controller: _deskripsiCtrl,
              maxLines: 4,
              decoration: _inputDecoration("Berikan gambaran umum..."),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic data = LombaModel(
                      judul: _judulCtrl.text,
                      gambarPath: _imageFile?.path ?? '',
                      kuota: int.tryParse(_kuotaCtrl.text) ?? 0,
                      jenis: _jenisLomba,
                      tanggal: _selectedDate.toIso8601String(),
                      lokasi: _lokasiCtrl.text,
                      deskripsi: _deskripsiCtrl.text,
                    );

                    await LombaControler.insertLomba(data);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lomba Berhasil Diterbitkan!"),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Terbitkan Lomba",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
    );
  }
}
