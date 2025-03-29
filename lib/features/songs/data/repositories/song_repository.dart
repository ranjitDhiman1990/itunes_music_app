import 'package:itunes_music_app/features/songs/data/datasources/local_data_source.dart';
import 'package:itunes_music_app/features/songs/data/datasources/remote_data_source.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  SongRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<SongEntity>> getTopSongs() async {
    /// Try to fetch from local DB first, if songs founf in local DB, the get it from there , otherwise get it from remote datasource(API Call)
    try {
      final localSongs = await localDataSource.getTopSongs();
      if (localSongs.isNotEmpty) {
        return localSongs.map((song) => song.toEntity()).toList();
      }

      final remoteSongs = await remoteDataSource.getTopSongs();
      await localDataSource.saveTopSongs(remoteSongs);
      return localSongs.map((song) => song.toEntity()).toList();
    } catch (err) {
      throw err.toString();
    }
  }
}
