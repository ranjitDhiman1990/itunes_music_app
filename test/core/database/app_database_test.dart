import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
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
          quantity INTEGER,
          FOREIGN KEY (songId) REFERENCES songs(id) ON DELETE CASCADE
        )
      ''');
            }));
  });

  tearDown(() async {
    await db.close();
  });

  test('Database should be initialized successfully', () async {
    expect(db.isOpen, true);
  });

  test('Tables should exist in the database', () async {
    final result =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    final tableNames = result.map((row) => row['name']).toList();
    expect(tableNames, containsAll(['top_songs', 'cart']));
  });

  test('Insert a song into top_songs', () async {
    await db.insert('top_songs', {
      'id': '1',
      'title': 'Song Title',
      'artist': 'Artist Name',
      'album': 'Album Name',
      'imgURL': 'http://example.com/image.jpg',
      'previewURL': 'http://example.com/preview.mp3'
    });
    final result = await db.query('top_songs');
    expect(result.length, 1);
  });

  test('Update a song in top_songs', () async {
    await db.insert('top_songs', {
      'id': '1',
      'title': 'Song Title',
      'artist': 'Artist Name',
      'album': 'Album Name',
      'imgURL': 'http://example.com/image.jpg',
      'previewURL': 'http://example.com/preview.mp3'
    });
    await db.update('top_songs', {'title': 'Updated Title'},
        where: 'id = ?', whereArgs: ['1']);
    final result =
        await db.query('top_songs', where: 'id = ?', whereArgs: ['1']);
    expect(result.first['title'], 'Updated Title');
  });

  test('Delete a song from top_songs', () async {
    await db.insert('top_songs', {
      'id': '1',
      'title': 'Song Title',
      'artist': 'Artist Name',
      'album': 'Album Name',
      'imgURL': 'http://example.com/image.jpg',
      'previewURL': 'http://example.com/preview.mp3'
    });
    await db.delete('top_songs', where: 'id = ?', whereArgs: ['1']);
    final result = await db.query('top_songs');
    expect(result.isEmpty, true);
  });
}
