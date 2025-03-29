import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

abstract class SongRepository {
  Future<List<SongEntity>> getTopSongs();
}
