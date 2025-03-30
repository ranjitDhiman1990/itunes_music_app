import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:itunes_music_app/core/database/app_database.dart';
import 'package:itunes_music_app/core/services/audio_player_controller.dart';
import 'package:itunes_music_app/core/services/audio_player_service.dart';
import 'package:itunes_music_app/core/services/player_notifier.dart';
import 'package:itunes_music_app/core/services/player_state.dart';
import 'package:itunes_music_app/features/cart/data/datasources/local_data_source.dart'
    as cart_provider;
import 'package:itunes_music_app/features/cart/data/repositories/cart_repository.dart';
import 'package:itunes_music_app/features/songs/data/datasources/local_data_source.dart'
    as song_local_provider;
import 'package:itunes_music_app/features/songs/data/datasources/remote_data_source.dart'
    as song_remote_provider;
import 'package:itunes_music_app/features/songs/data/repositories/song_repository.dart';

final httpClientProvider = Provider<Client>((ref) => Client());

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final songLocalDSProvider =
    Provider<song_local_provider.LocalDataSource>((ref) {
  final appDatabase = ref.read(appDatabaseProvider);
  return song_local_provider.LocalDataSourceImpl(appDatabase: appDatabase);
});

final songRemoteDSProvider =
    Provider<song_remote_provider.RemoteDataSource>((ref) {
  final client = ref.read(httpClientProvider);
  return song_remote_provider.RemoteDataSourceImpl(client: client);
});

final songRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.read(songRemoteDSProvider);
  final localDataSource = ref.read(songLocalDSProvider);

  return SongRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final cartLocalDSProvider = Provider<cart_provider.LocalDataSource>((ref) {
  final appDatabase = ref.read(appDatabaseProvider);
  return cart_provider.LocalDataSourceImpl(appDatabase: appDatabase);
});

final cartRepositoryProvider = Provider((ref) {
  final localDataSource = ref.read(cartLocalDSProvider);
  return CartRepositoryImpl(localDataSource: localDataSource);
});

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final audioControllerProvider = Provider<AudioPlayerController>((ref) {
  final controller = AudioPlayerController(ref);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier();
});
