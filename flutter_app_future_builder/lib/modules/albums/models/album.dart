class Album {
  Album({this.title, this.artist, this.url, this.image, this.thumbnailImage});

  String title;
  String artist;
  String url;
  String image;
  String thumbnailImage;
  int    id = DateTime.now().millisecondsSinceEpoch;

  Album.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    artist = json['artist'];
    url = json['url'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['artist'] = this.artist;
    data['url'] = this.url;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    return data;
  }
}
