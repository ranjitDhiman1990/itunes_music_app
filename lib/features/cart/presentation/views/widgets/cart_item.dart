import 'package:flutter/material.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';

import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

class CartItem extends StatelessWidget {
  final SongEntity song;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItem({
    super.key,
    required this.song,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CommonImageViewWidget(
            imageUrl: song.imgURL ?? '',
            height: 50,
            width: 50,
          ),
        ),
        title: Text(song.title ?? ''),
        subtitle: Text('Quantity: $quantity'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle),
            ),
            Text(quantity.toString()),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
      ),
    );
  }
}
