import 'package:nyt_app/model/post_entity.dart';

class PostsList {
  List<PostEntity> postsList;

  PostsList({this.postsList});

  factory PostsList.fromJson(Map<String, dynamic> json) {
    var postsJson = json['results'] as List;
    List<PostEntity> postsList =
        postsJson.map((e) => PostEntity.fromMap(e)).toList();
    return PostsList(postsList: postsList);
  }
}
