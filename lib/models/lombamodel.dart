// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LombaModel {
  int? id;
  String? judul;
  String? gambar; // Simpan path gambar di sini
  int? kuota;
  String? jenis; // "Individu" atau "Tim"

  LombaModel({this.id, this.judul, this.gambar, this.kuota, this.jenis});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'judul': judul,
      'gambar': gambar,
      'kuota': kuota,
      'jenis': jenis,
    };
  }

  factory LombaModel.fromMap(Map<String, dynamic> map) {
    return LombaModel(
      id: map['id'] != null ? map['id'] as int : null,
      judul: map['judul'] != null ? map['judul'] as String : null,
      gambar: map['gambar'] != null ? map['gambar'] as String : null,
      kuota: map['kuota'] != null ? map['kuota'] as int : null,
      jenis: map['jenis'] != null ? map['jenis'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LombaModel.fromJson(String source) =>
      LombaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
