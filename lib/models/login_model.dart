import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginModel {
  final int? id;
  final String nama;
  final String password;
  final String email;
  final String tlpon;
  LoginModel({
    this.id,
    required this.nama,
    required this.password,
    required this.email,
    required this.tlpon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'password': password,
      'email': email,
      'tlpon': tlpon,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      id: map['id'] != null ? map['id'] as int : null,
      nama: map['nama'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      tlpon: map['tlpon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
