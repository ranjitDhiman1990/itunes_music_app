import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/utils/cart_utils.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

class SongController {
  final WidgetRef ref;
  final String songId;

  SongController(this.ref, this.songId);

  bool get isPlaying {
    final playerState = ref.watch(playerProvider);
    return playerState.currentSongId == songId && playerState.isPlaying;
  }

  bool get isInCart {
    final cartState = ref.watch(cartViewModel);
    return cartState.isInCart(songId);
  }

  bool get isCurrentSong {
    final playerState = ref.watch(playerProvider);
    return playerState.currentSongId == songId;
  }

  Future<void> toggleCartStatus(SongEntity song, BuildContext context) async {
    final cartState = ref.read(cartViewModel);
    if (cartState.isInCart(songId)) {
      await CartUtils.showCartQuantityDialog(
          context: context, ref: ref, song: song);
    } else {
      await ref.read(cartViewModel.notifier).addToCart(songId);
      if (context.mounted) {
        CartUtils.showAddConfirmation(context, song);
      }
    }
  }

  void togglePlayPause(SongEntity song) {
    if (song.previewURL == null) return;
    final audioController = ref.read(audioControllerProvider);
    isPlaying
        ? audioController.pause()
        : audioController.play(songId, song.previewURL!, song.title ?? '');
  }
}
