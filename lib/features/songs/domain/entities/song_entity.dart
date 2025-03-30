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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          artist == other.artist &&
          album == other.album &&
          imgURL == other.imgURL &&
          previewURL == other.previewURL;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      artist.hashCode ^
      album.hashCode ^
      imgURL.hashCode ^
      previewURL.hashCode;
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
