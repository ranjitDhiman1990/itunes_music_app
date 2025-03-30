class PlayerState {
  final String? currentSongId;
  final bool isPlaying;

  const PlayerState({
    this.currentSongId,
    this.isPlaying = false,
  });

  PlayerState copyWith({
    String? currentSongId,
    bool? isPlaying,
  }) {
    return PlayerState(
      currentSongId: currentSongId ?? this.currentSongId,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
