import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_controller.dart';

class SongItemWidget extends ConsumerStatefulWidget {
  final SongEntity song;
  final VoidCallback onTap;

  const SongItemWidget({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  ConsumerState<SongItemWidget> createState() => _SongItemWidgetState();
}

class _SongItemWidgetState extends ConsumerState<SongItemWidget> {
  late SongController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SongController(ref, widget.song.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: _SongTileWidget(widget: widget, controller: _controller),
    );
  }
}

class _SongTileWidget extends ConsumerWidget {
  const _SongTileWidget({
    required this.widget,
    required SongController controller,
  }) : _controller = controller;

  final SongItemWidget widget;
  final SongController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CommonImageViewWidget(
          imageUrl: widget.song.imgURL ?? '',
          height: 50,
          width: 50,
        ),
      ),
      title: Text(widget.song.title ?? ''),
      subtitle: Text(widget.song.artist ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _controller.togglePlayPause(widget.song),
            icon: Icon(_controller.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
          IconButton(
            onPressed: () => _controller.toggleCartStatus(widget.song, context),
            icon: Icon(_controller.isInCart
                ? Icons.remove_shopping_cart
                : Icons.add_shopping_cart),
          )
        ],
      ),
      onTap: widget.onTap,
    );
  }
}
