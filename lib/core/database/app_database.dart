import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'top_songs.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE top_songs(
        id TEXT PRIMARY KEY,
        title TEXT,
        artist TEXT, 
        album TEXT, 
        imgURL TEXT, 
        previewURL TEXT 
      )
    ''');

    await db.execute('''
      CREATE TABLE cart(
        songId TEXT PRIMARY KEY,
        qty INTEGER,
        FOREIGN KEY (songId) REFERENCES songs(id) ON DELETE CASCADE
      )
    ''');
  }
}
