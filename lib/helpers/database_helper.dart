import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      version: 3, // Versi diperbarui jika ada perubahan
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            username TEXT UNIQUE, 
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE mahasiswa(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nama TEXT, 
            nim TEXT UNIQUE, 
            jurusan TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE users ADD COLUMN name TEXT");
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE mahasiswa(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              nama TEXT, 
              nim TEXT UNIQUE, 
              jurusan TEXT
            )
          ''');
        }
      },
    );
  }
}
