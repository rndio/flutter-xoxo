import 'package:sqflite/sqflite.dart';
import '../models/mahasiswa_model.dart';
import '../helpers/database_helper.dart';

class MahasiswaService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // **1. Tambah Mahasiswa**
  Future<int> insertMahasiswa(Mahasiswa mahasiswa) async {
    final db = await _dbHelper.database;
    int id = await db.insert(
      'mahasiswa',
      mahasiswa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id; // Kembalikan ID yang baru dibuat
  }

  // **2. Ambil Semua Mahasiswa**
  Future<List<Mahasiswa>> getAllMahasiswa() async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query('mahasiswa');
    return result.map((json) => Mahasiswa.fromMap(json)).toList();
  }

  // **3. Update Mahasiswa**
  Future<int> updateMahasiswa(Mahasiswa mahasiswa) async {
    final db = await _dbHelper.database;
    return await db.update(
      'mahasiswa',
      mahasiswa.toMap(),
      where: 'id = ?',
      whereArgs: [mahasiswa.id],
    );
  }

  // **4. Hapus Mahasiswa**
  Future<int> deleteMahasiswa(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'mahasiswa',
      where: 'id = ?', // Pastikan hanya menghapus 1 mahasiswa berdasarkan ID
      whereArgs: [id],
    );
  }
}
