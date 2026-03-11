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
      version: 5,
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
        // Tabel Admin (BARU)
        await db.execute('''
          CREATE TABLE admin (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');

        // Opsional: Masukkan 1 akun admin default saat database dibuat
        await db.insert('admin', {'username': '111', 'password': '222'});
        await db.execute('''
  CREATE TABLE riwayatEvent (
    id INTEGER PRIMARY KEY,
    judul TEXT,
    jenis TEXT,
    tanggal TEXT,
    lokasi TEXT,
    gambarPath TEXT,
    deskripsi TEXT
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
        if (oldVersion < 5) {
          // Tambah tabel admin jika user melakukan update ke versi 5
          await db.execute('''
            CREATE TABLE IF NOT EXISTS admin (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT,
              password TEXT
            )
          ''');

          // Tambahkan admin default
          await db.insert('admin', {
            'username': 'admin123',
            'password': 'adminpassword',
          });
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
  // --- FUNGSI KHUSUS ADMIN ---

  static Future<bool> loginAdmin({
    required String username,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(
      "admin",
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      // Simpan status admin di Preference jika perlu
      await PreferenceHandler.storingId(result.first['id']);
      // Kamu bisa buat PreferenceHandler.setRole('admin') jika ingin membedakan session
      return true;
    }
    return false;
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
    final db = await DBHelper.db();

    await db.transaction((txn) async {
      // 1. Simpan data ke tabel riwayat (User mengikuti lomba)
      await txn.insert('riwayat', riwayat.toMap());

      // 2. Kurangi kuota di tabel lomba (Auto Decrement)
      await txn.rawUpdate('UPDATE lomba SET kuota = kuota - 1 WHERE id = ?', [
        riwayat.idLomba,
      ]);

      // 3. Ambil data lomba terbaru untuk cek kuota
      List<Map<String, dynamic>> res = await txn.query(
        'lomba',
        where: 'id = ?',
        whereArgs: [riwayat.idLomba],
      );

      if (res.isNotEmpty) {
        int kuotaSekarang = res.first['kuota'];

        // 4. Jika kuota habis (0), pindahkan ke tabel riwayatEvent
        if (kuotaSekarang <= 0) {
          Map<String, dynamic> lombaSelesai = Map.from(res.first);

          // Hapus kolom kuota sebelum dipindahkan ke riwayatEvent
          lombaSelesai.remove('kuota');

          // Masukkan ke tabel riwayatEvent
          await txn.insert('riwayatEvent', lombaSelesai);

          // Hapus dari tabel lomba aktif agar tidak muncul di daftar
          await txn.delete(
            'lomba',
            where: 'id = ?',
            whereArgs: [riwayat.idLomba],
          );
        }
      }
    });
  }

  static Future<List<Map<String, dynamic>>> getRiwayatEvent() async {
    final db = await DBHelper.db();
    // Mengambil semua data dari tabel riwayatEvent
    return await db.query('riwayatEvent', orderBy: 'id DESC');
  }

  static Future<List<Map<String, dynamic>>> getRiwayatUser(int userId) async {
    final db = await DBHelper.db();
    // Mengambil data lomba yang diikuti oleh USER tertentu
    return await db.rawQuery(
      '''
    SELECT lomba.judul, lomba.lokasi, lomba.tanggal, lomba.gambarPath
    FROM riwayat
    INNER JOIN lomba ON riwayat.idLomba = lomba.id
    WHERE riwayat.idUser = ?
  ''',
      [userId],
    );
  }
}
