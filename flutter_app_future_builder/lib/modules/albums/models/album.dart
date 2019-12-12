class Album {
  Album({this.title, this.artist, this.url, this.image, this.thumbnailImage});

  Album.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    artist = json['artist'];
    url = json['url'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
  }

  String title;
  String artist;
  String url;
  String image;
  String thumbnailImage;
  //int    id = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['artist'] = artist;
    data['url'] = url;
    data['image'] = image;
    data['thumbnail_image'] = thumbnailImage;
    //data['id'] = this.id;
    return data;
  }
}
