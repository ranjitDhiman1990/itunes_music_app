import 'package:itunes_music_app/features/songs/data/models/song_model.dart';

class SongEntity {
  final String id;
  final String? title;
  final String? artist;
  final String? album;
  final String? imgURL;
  final String? previewURL;

  SongEntity({
    required this.id,
    this.title,
    this.artist,
    this.album,
    this.imgURL,
    this.previewURL,
  });
}

extension SongModelExtensions on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      id: id,
      title: title,
      artist: artist,
      album: album,
      imgURL: imgURL,
      previewURL: previewURL,
    );
  }
}
