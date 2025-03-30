import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';

void main() {
  group('SongModel Unit Tests', () {
    test('Create SongModel with valid Data', () {
      final song = SongModel(
        id: '100',
        title: 'Kesariya',
        artist: 'Arijit Singh',
        album: 'Brahmastra',
        imgURL: 'https://example.com/image.jpg',
        previewURL: 'https://example.com/preview.mp3',
      );

      expect(song.id, '100');
      expect(song.title, 'Kesariya');
      expect(song.artist, 'Arijit Singh');
      expect(song.album, 'Brahmastra');
      expect(song.imgURL, 'https://example.com/image.jpg');
      expect(song.previewURL, 'https://example.com/preview.mp3');
    });

    test('Check SongModel toJson method', () {
      final song = SongModel(
        id: '100',
        title: 'Kesariya',
        artist: 'Arijit Singh',
        album: 'Brahmastra',
        imgURL: 'https://example.com/image.jpg',
        previewURL: 'https://example.com/preview.mp3',
      );

      final json = song.toJson();

      expect(json, {
        'id': '100',
        'title': 'Kesariya',
        'artist': 'Arijit Singh',
        'album': 'Brahmastra',
        'imgURL': 'https://example.com/image.jpg',
        'previewURL': 'https://example.com/preview.mp3',
      });
    });

    test('Check fromJson method', () {
      final json = {
        'id': {
          'attributes': {'im:id': '100'}
        },
        'im:name': {'label': 'Kesariya'},
        'im:artist': {'label': 'Arijit Singh'},
        'im:collection': {
          'im:name': {'label': 'Brahmastra'}
        },
        'im:image': [
          {'label': 'small.jpg'},
          {'label': 'medium.jpg'},
          {'label': 'https://example.com/image.jpg'},
        ],
        'link': [
          {},
          {
            'attributes': {'href': 'https://example.com/preview.mp3'}
          }
        ],
      };

      final song = SongModel.fromJson(json);

      expect(song.id, '100');
      expect(song.title, 'Kesariya');
      expect(song.artist, 'Arijit Singh');
      expect(song.album, 'Brahmastra');
      expect(song.imgURL, 'https://example.com/image.jpg');
      expect(song.previewURL, 'https://example.com/preview.mp3');
    });

    test('should throw FormatException when id is missing', () {
      final json = {
        'im:name': {'label': 'Test Song'},
        'im:artist': {'label': 'Test Artist'},
      };

      expect(() => SongModel.fromJson(json), throwsFormatException);
    });

    test('should handle missing optional fields', () {
      final json = {
        'id': {
          'attributes': {'im:id': '123'}
        },
      };

      final song = SongModel.fromJson(json);

      expect(song.id, '123');
      expect(song.title, isNull);
      expect(song.artist, isNull);
      expect(song.album, isNull);
      expect(song.imgURL, isNull);
      expect(song.previewURL, isNull);
    });
  });
}
