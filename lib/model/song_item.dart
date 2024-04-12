class SongItem{
  String title;
  String id;
  String artist;

  SongItem({
    required this.title,
    required this.artist,
    required this.id
  });

  factory SongItem.fromJson(Map<String, dynamic> json){
    return SongItem(
      title: json['title'],
      artist: json['artist'],
      id: json['songId']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'artist': artist,
      'id': id
    };
  }
}