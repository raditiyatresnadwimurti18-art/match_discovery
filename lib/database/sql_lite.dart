import 'package:match_discovery/database/preferences.dart';

import 'package:match_discovery/models/login_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(
        dbPath,
        'Match_Discovery_db',
      ), // Gunakan underscore agar nama file lebih aman
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, password TEXT, email TEXT, tlpon TEXT)',
        );
        // Jika user baru instal, langsung buat tabel lomba
        await _createLombaTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Jika user lama update app, tambahkan tabel lomba
        if (oldVersion < 2) {
          await _createLombaTable(db);
        }
      },
    );
  }

  static Future<void> _createLombaTable(Database db) async {
    await db.execute('''
    CREATE TABLE lomba (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT,
      gambarPath TEXT,
      kuota INTEGER,
      jenis TEXT,
      tanggal TEXT,
      lokasi TEXT,
      deskripsi TEXT
    )
  ''');
  }

  static Future<void> registerUser(LoginModel user) async {
    final dbs = await db();
    await dbs.insert('user', user.toMap());
  }

  static Future<LoginModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(
      "user",
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      final data = LoginModel.fromMap(result.first);
      PreferenceHandler.storingId(data.id!);
      return LoginModel.fromMap(result.first);
    }
    return null;
  }

  static Future<LoginModel?> getUserById(int id) async {
    final dbs = await db(); // Memanggil fungsi db() yang sudah ada
    final List<Map<String, dynamic>> result = await dbs.query(
      "user",
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return LoginModel.fromMap(
        result.first,
      ); // Mengonversi hasil query menjadi objek
    }
    return null;
  }

  // Fungsi Simpan Lomba
  static Future<void> insertLomba(Map<String, dynamic> data) async {
    final dbs = await db();
    await dbs.insert(
      'lomba',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi Ambil Semua Lomba
  static Future<List<Map<String, dynamic>>> getAllLomba() async {
    final dbs = await db();
    return await dbs.query('lomba', orderBy: "id DESC");
  }

  static Future<int> deleteLomba(int id) async {
    final dbs = await db();
    return await dbs.delete('lomba', where: 'id = ?', whereArgs: [id]);
  }
}
