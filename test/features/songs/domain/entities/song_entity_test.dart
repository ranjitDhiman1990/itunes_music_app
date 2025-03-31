import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

void main() {
  group('SongEntity', () {
    test('should create entity with required fields only', () {
      final entity = SongEntity(id: '123');
      expect(entity.id, '123');
      expect(entity.title, isNull);
      expect(entity.artist, isNull);
      expect(entity.album, isNull);
      expect(entity.imgURL, isNull);
      expect(entity.previewURL, isNull);
    });

    test('should create entity with all fields', () {
      final entity = SongEntity(
        id: '456',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        imgURL: 'https://test.com/image.jpg',
        previewURL: 'https://test.com/preview.mp3',
      );

      
      expect(entity.id, '456');
      expect(entity.title, 'Test Song');
      expect(entity.artist, 'Test Artist');
      expect(entity.album, 'Test Album');
      expect(entity.imgURL, 'https://test.com/image.jpg');
      expect(entity.previewURL, 'https://test.com/preview.mp3');
    });

    test('should be equal when properties are same', () {
      final entity1 = SongEntity(
        id: '789',
        title: 'Same Song',
        artist: 'Same Artist',
      );
      final entity2 = SongEntity(
        id: '789',
        title: 'Same Song',
        artist: 'Same Artist',
      );

      expect(entity1, equals(entity2));
    });

    test('should not be equal when properties differ', () {
      final entity1 = SongEntity(id: '111');
      final entity2 = SongEntity(id: '222');

      expect(entity1, isNot(equals(entity2)));
    });
  });

  group('SongModelExtensions', () {
    test('should convert SongModel to SongEntity with all fields', () {
      final model = SongModel(
        id: 'model1',
        title: 'Model Song',
        artist: 'Model Artist',
        album: 'Model Album',
        imgURL: 'https://model.com/image.jpg',
        previewURL: 'https://model.com/preview.mp3',
      );

      final entity = model.toEntity();

      expect(entity.id, 'model1');
      expect(entity.title, 'Model Song');
      expect(entity.artist, 'Model Artist');
      expect(entity.album, 'Model Album');
      expect(entity.imgURL, 'https://model.com/image.jpg');
      expect(entity.previewURL, 'https://model.com/preview.mp3');
    });

    test('should convert SongModel with null fields to SongEntity', () {
      final model = SongModel(
        id: 'model2',
        title: null,
        artist: null,
        album: null,
        imgURL: null,
        previewURL: null,
      );

      final entity = model.toEntity();

      expect(entity.id, 'model2');
      expect(entity.title, isNull);
      expect(entity.artist, isNull);
      expect(entity.album, isNull);
      expect(entity.imgURL, isNull);
      expect(entity.previewURL, isNull);
    });

    test('should maintain equality when converting identical models', () {
      final model1 = SongModel(
        id: 'same',
        title: 'Same Title',
        artist: 'Same Artist',
      );
      final model2 = SongModel(
        id: 'same',
        title: 'Same Title',
        artist: 'Same Artist',
      );

      final entity1 = model1.toEntity();
      final entity2 = model2.toEntity();
      expect(entity1, equals(entity2));
    });
  });
}
