import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_controller.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';

class SongDetailsScreen extends ConsumerStatefulWidget {
  final String songId;
  const SongDetailsScreen({
    super.key,
    required this.songId,
  });

  @override
  ConsumerState<SongDetailsScreen> createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends ConsumerState<SongDetailsScreen> {
  late SongController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SongController(ref, widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(songViewModel);
    final song =
        songState.songs.firstWhere((element) => element.id == widget.songId);

    return Scaffold(
      appBar: AppBar(
        title: Text(song.title ?? ''),
      ),
      body: _SongDetailsView(
        song: song,
        controller: _controller,
      ),
    );
  }
}

class _SongDetailsView extends StatelessWidget {
  const _SongDetailsView({
    required this.song,
    required this.controller,
  });

  final SongEntity song;
  final SongController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CommonImageViewWidget(
                imageUrl: song.imgURL ?? '',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              song.title ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              song.artist ?? '',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Album: ${song.album}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.toggleCartStatus(song, context),
              child: Text(
                controller.isInCart ? 'Remove from Cart' : 'Add to Cart',
              ),
            ),
            if (song.previewURL != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(
                  controller.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                label: Text(
                  controller.isPlaying ? 'Pause Song' : 'Play Song',
                ),
                onPressed: () => controller.togglePlayPause(song),
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
