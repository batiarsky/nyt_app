class PostEntity {
  String title;
  String url;

  PostEntity({this.title, this.url});

  factory PostEntity.fromMap(Map<String, dynamic> map) {
    return PostEntity(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['title'] = title;
    map['url'] = url;
    return map;
  }
}
