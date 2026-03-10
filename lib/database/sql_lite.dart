import 'package:match_discovery/database/preferences.dart';

import 'package:match_discovery/models/login_model.dart';
import 'package:match_discovery/models/riwayat_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'Match_Discovery_db'),
      version: 4,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, password TEXT, email TEXT, tlpon TEXT, profilePath TEXT)',
        );
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
        await db.execute('''
        CREATE TABLE riwayat (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idUser INTEGER,
          idLomba INTEGER,
          tanggalDaftar TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Command untuk menambah tabel jika user melakukan update app
          await db.execute('''
            CREATE TABLE IF NOT EXISTS lomba (
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
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE user ADD COLUMN profilePath TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS riwayat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idUser INTEGER,
            idLomba INTEGER,
            tanggalDaftar TEXT
          )
        ''');
        }
      },
    );
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

  static Future<int> updateLomba(int id, Map<String, dynamic> data) async {
    final dbs = await db();
    return await dbs.update('lomba', data, where: 'id = ?', whereArgs: [id]);
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

  static Future<int> updateUserProfile(int id, String imagePath) async {
    final dbs = await db();
    return await dbs.update(
      'user',
      {'profilePath': imagePath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Fungsi untuk mengambil riwayat lomba berdasarkan User ID
  static Future<void> ikutiLomba(RiwayatModel riwayat) async {
    final dbs = await db();
    int result = await dbs.insert('riwayat', riwayat.toMap());
    print(
      "Hasil simpan database: $result",
    ); // Jika muncul angka > 0, berarti berhasil
  }

  // Fungsi untuk mengambil riwayat lomba berdasarkan User ID
  static Future<List<Map<String, dynamic>>> getRiwayatLomba(int idUser) async {
    final dbs = await db();
    // Menggunakan JOIN untuk mengambil detail lombanya sekaligus
    return await dbs.rawQuery(
      '''
    SELECT lomba.* FROM lomba 
    INNER JOIN riwayat ON lomba.id = riwayat.idLomba 
    WHERE riwayat.idUser = ?
  ''',
      [idUser],
    );
  }
}
