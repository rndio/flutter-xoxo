import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:form_login/models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 2, // Ubah versi database
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, username TEXT UNIQUE, password TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE users ADD COLUMN name TEXT");
        }
      },
    );
  }

  Future<int> registerUser(
      String name, String username, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      User(name: name, username: username, password: password).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String username) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "username = ?",
      whereArgs: [username],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }
}
