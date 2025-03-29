import 'dart:convert';

import 'package:http/http.dart';
import 'package:itunes_music_app/core/constants/app_constants.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';

abstract class RemoteDataSource {
  Future<List<SongModel>> getTopSongs();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<List<SongModel>> getTopSongs() async {
    try {
      final response = await client.get(
          Uri.parse('${AppConstants.baseUrl}${AppConstants.songsEndpoint}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> entries = data['feed']['entry'];
        return entries.map((item) => SongModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (err) {
      throw Exception('Failed to load songs with error ${err.toString()}');
    }
  }
}
