class SongModel {
  final String id;
  final String? title;
  final String? artist;
  final String? album;
  final String? imgURL;
  final String? previewURL;

  SongModel({
    required this.id,
    this.title,
    this.artist,
    this.album,
    this.imgURL,
    this.previewURL,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?['attributes']?['im:id']?.toString();
    final title = json['im:name']?['label']?.toString();
    final artist = json['im:artist']?['label']?.toString();
    final album = json['im:collection']?['im:name']?['label']?.toString();

    final images = json['im:image'] as List?;
    final imgURL = images != null && images.length > 2
        ? images[2]['label']?.toString()
        : null;

    final links = json['link'] as List?;
    final previewURL = links != null && links.length > 1
        ? (links[1] as Map<String, dynamic>?)?['attributes']?['href']
            ?.toString()
        : null;

    if (id == null) {
      throw const FormatException('Missing required field: id');
    }

    return SongModel(
      id: id,
      title: title,
      artist: artist,
      album: album,
      imgURL: imgURL,
      previewURL: previewURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'imageUrl': imgURL,
      'previewUrl': previewURL,
    };
  }
}
