import 'package:itunes_music_app/core/database/app_database.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<List<SongModel>> getTopSongs();
  Future<void> saveTopSongs(List<SongModel> songs);
}

class LocalDataSourceImpl implements LocalDataSource {
  final AppDatabase appDatabase;

  LocalDataSourceImpl({required this.appDatabase});

  @override
  Future<List<SongModel>> getTopSongs() async {
    final database = await appDatabase.database;
    final List<Map<String, dynamic>> json = await database.query('top_songs');
    return List.generate(json.length, (index) {
      return SongModel(
        id: json[index]['id'],
        title: json[index]['title'],
        artist: json[index]['artist'],
        album: json[index]['album'],
        imgURL: json[index]['imgURL'],
        previewURL: json[index]['previewURL'],
      );
    });
  }

  @override
  Future<void> saveTopSongs(List<SongModel> songs) async {
    final database = await appDatabase.database;
    final batch = database.batch();
    for (final song in songs) {
      batch.insert(
        'top_songs',
        song.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}
