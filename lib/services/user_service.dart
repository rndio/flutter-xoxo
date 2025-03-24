import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../helpers/database_helper.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Hash password menggunakan SHA-256
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // **Registrasi User dengan Password Hashing**
  Future<int> registerUser(
      String name, String username, String password) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'users',
      User(name: name, username: username, password: _hashPassword(password))
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // **Mendapatkan User berdasarkan Username**
  Future<User?> getUser(String username) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "username = ?",
      whereArgs: [username],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  // **Autentikasi User**
  Future<User?> authenticateUser(String username, String password) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, _hashPassword(password)],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }
}
