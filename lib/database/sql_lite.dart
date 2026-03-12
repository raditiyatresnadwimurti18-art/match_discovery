import 'package:match_discovery/database/preferences.dart';
import 'package:match_discovery/models/admin_model.dart';
import 'package:match_discovery/models/login_model.dart';
import 'package:match_discovery/models/riwayat_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    // Versi ditingkatkan ke v11 untuk memastikan perubahan role & tabel admin masuk
    return openDatabase(
      join(dbPath, 'Match_Discovery_v11_db'),
      version: 1,
      onCreate: (db, version) async {
        // 1. Tabel User
        await db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, password TEXT, email TEXT, tlpon TEXT, profilePath TEXT)',
        );

        // 2. Tabel Lomba
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

        // 3. Tabel Riwayat (Relasi User & Lomba)
        await db.execute('''
          CREATE TABLE riwayat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idUser INTEGER,
            idLomba INTEGER,
            tanggalDaftar TEXT
          )
        ''');

        // 4. Tabel Admin (LENGKAP)
        await db.execute('''
          CREATE TABLE admin (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT,
            nama TEXT,          
            profilePath TEXT,   
            role TEXT           
          )
        ''');

        // 5. Tabel Riwayat Event (Untuk event yang sudah selesai/kuota habis)
        await db.execute('''
          CREATE TABLE riwayatEvent (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idLombaAsli INTEGER,
            judul TEXT,
            jenis TEXT,
            tanggal TEXT,
            lokasi TEXT,
            gambarPath TEXT,
            deskripsi TEXT
          )
        ''');

        // MASUKKAN ADMIN DEFAULT DENGAN ROLE SUPER
        await db.insert('admin', {
          'username': '111',
          'password': '222',
          'nama': 'Super Admin',
          'role': 'super',
          'profilePath': '',
        });
      },
    );
  }

  // ==================== AUTHENTICATION ====================

  static Future<void> registerUser(LoginModel user) async {
    final dbs = await db();
    await dbs.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
      await PreferenceHandler.storingId(data.id!);
      await PreferenceHandler.storingIsLogin(true);
      await PreferenceHandler.setRole('user');
      return data;
    }
    return null;
  }

  static Future<AdminModel?> loginAdminModel({
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
      AdminModel admin = AdminModel.fromMap(result.first);
      await PreferenceHandler.storingId(admin.id!);
      await PreferenceHandler.storingIsLogin(true);
      await PreferenceHandler.setRole('admin');
      return admin;
    }
    return null;
  }

  // ==================== MANAJEMEN ADMIN ====================

  static Future<int> addAdmin(AdminModel newAdmin) async {
    final dbs = await db();
    return await dbs.insert('admin', newAdmin.toMap());
  }

  static Future<AdminModel?> getAdminById(int id) async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(
      'admin',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return AdminModel.fromMap(result.first);
    return null;
  }

  static Future<int> updateAdminProfile(AdminModel admin) async {
    final dbs = await db();
    return await dbs.update(
      'admin',
      {
        'nama': admin.nama ?? 'Admin',
        'profilePath': admin.profilePath,
        'role': admin.role,
      },
      where: 'id = ?',
      whereArgs: [admin.id],
    );
  }

  // Fungsi untuk mengambil semua data admin dari tabel admin
  static Future<List<AdminModel>> getSemuaAdmin() async {
    final dbs = await db();
    // Query semua data dari tabel 'admin'
    final List<Map<String, dynamic>> maps = await dbs.query(
      'admin',
      orderBy: 'id DESC',
    );

    // Ubah List Map jadi List AdminModel
    return List.generate(maps.length, (i) {
      return AdminModel.fromMap(maps[i]);
    });
  }

  // Bonus: Fungsi hapus admin (supaya super admin bisa mengelola)
  static Future<int> deleteAdmin(int id) async {
    final dbs = await db();
    return await dbs.delete('admin', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk update data profil (Nama, Username, Password)
  static Future<int> updateAdminDetail(
    int id,
    String nama,
    String username,
    String password,
  ) async {
    final dbs = await db();
    return await dbs.update(
      'admin', // Pastikan nama tabel di DB kamu adalah 'admin'
      {'nama': nama, 'username': username, 'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== MANAJEMEN USER ====================

  static Future<LoginModel?> getUserById(int id) async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(
      "user",
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return LoginModel.fromMap(result.first);
    return null;
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

  // ==================== MANAJEMEN LOMBA ====================

  static Future<void> insertLomba(Map<String, dynamic> data) async {
    final dbs = await db();
    await dbs.insert(
      'lomba',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllLomba() async {
    final dbs = await db();
    return await dbs.query('lomba', orderBy: "id DESC");
  }

  static Future<int> updateLomba(int id, Map<String, dynamic> data) async {
    final dbs = await db();
    return await dbs.update('lomba', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteLomba(int id) async {
    final dbs = await db();
    return await dbs.delete('lomba', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== LOGIKA PENDAFTARAN & RIWAYAT ====================

  static Future<void> ikutiLomba(RiwayatModel riwayat) async {
    final database = await db();
    await database.transaction((txn) async {
      await txn.insert('riwayat', riwayat.toMap());
      await txn.rawUpdate('UPDATE lomba SET kuota = kuota - 1 WHERE id = ?', [
        riwayat.idLomba,
      ]);

      List<Map<String, dynamic>> res = await txn.query(
        'lomba',
        where: 'id = ?',
        whereArgs: [riwayat.idLomba],
      );
      if (res.isNotEmpty && res.first['kuota'] <= 0) {
        // Jika kuota habis, pindahkan ke riwayatEvent
        Map<String, dynamic> lombaSelesai = Map.from(res.first);
        int idAsli = lombaSelesai['id'];
        lombaSelesai.remove('id');
        lombaSelesai.remove('kuota');
        lombaSelesai['idLombaAsli'] = idAsli;

        await txn.insert(
          'riwayatEvent',
          lombaSelesai,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await txn.delete('lomba', where: 'id = ?', whereArgs: [idAsli]);
      }
    });
  }

  static Future<bool> isUserSedangIkutLomba(int userId, int lombaId) async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(
      'riwayat',
      where: 'idUser = ? AND idLomba = ?',
      whereArgs: [userId, lombaId],
    );
    return result.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getRiwayatUser(int userId) async {
    final dbs = await db();
    return await dbs.rawQuery(
      '''
      SELECT 
        COALESCE(lomba.judul, re.judul) as judul, 
        COALESCE(lomba.lokasi, re.lokasi) as lokasi, 
        COALESCE(lomba.tanggal, re.tanggal) as tanggal, 
        COALESCE(lomba.gambarPath, re.gambarPath) as gambarPath, 
        riwayat.idLomba
      FROM riwayat
      LEFT JOIN lomba ON riwayat.idLomba = lomba.id
      LEFT JOIN riwayatEvent re ON riwayat.idLomba = re.idLombaAsli
      WHERE riwayat.idUser = ?
    ''',
      [userId],
    );
  }

  static Future<List<Map<String, dynamic>>> getRiwayatEvent() async {
    final dbs = await db();
    return await dbs.rawQuery(
      'SELECT DISTINCT id, judul, lokasi, tanggal, gambarPath, deskripsi FROM riwayatEvent ORDER BY id DESC',
    );
  }

  static Future<int> deleteRiwayatEvent(int id) async {
    final dbs = await db();
    return await dbs.delete('riwayatEvent', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> konfirmasiSelesaiManual(int userId, int lombaId) async {
    final dbs = await db();
    await dbs.delete(
      'riwayat',
      where: 'idUser = ? AND idLomba = ?',
      whereArgs: [userId, lombaId],
    );
  }

  // ==================== LAPORAN ADMIN ====================

  static Future<List<Map<String, dynamic>>> getPendaftarByLomba(
    int idLomba,
  ) async {
    final dbs = await db();
    return await dbs.rawQuery(
      '''
      SELECT user.nama, user.tlpon, riwayat.tanggalDaftar
      FROM riwayat
      INNER JOIN user ON riwayat.idUser = user.id
      WHERE riwayat.idLomba = ?
    ''',
      [idLomba],
    );
  }

  static Future<List<Map<String, dynamic>>>
  getAllLombaDenganJumlahPendaftar() async {
    final dbs = await db();
    return await dbs.rawQuery('''
      SELECT lomba.*, COUNT(riwayat.id) as totalPendaftar
      FROM lomba
      LEFT JOIN riwayat ON lomba.id = riwayat.idLomba
      GROUP BY lomba.id ORDER BY lomba.id DESC
    ''');
  }

  static Future<List<Map<String, dynamic>>> getSemuaPendaftarGlobal() async {
    final dbs = await db();
    return await dbs.rawQuery('''
      SELECT lomba.judul AS judul_lomba, user.nama AS nama_user, user.tlpon AS telepon_user, riwayat.tanggalDaftar
      FROM riwayat
      INNER JOIN user ON riwayat.idUser = user.id
      INNER JOIN lomba ON riwayat.idLomba = lomba.id
      ORDER BY lomba.id DESC
    ''');
  }
}
