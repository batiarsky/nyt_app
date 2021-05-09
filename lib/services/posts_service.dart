import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nyt_app/model/post_entity.dart';
import 'package:nyt_app/model/posts_list.dart';

class PostsService {
  static const _timesBaseUrl = 'api.nytimes.com';
  static const _timesPathUrl = 'svc/topstories/v2/home.json';
  static const _apiKeyValue = 'I4YUnaPImmBKrc9CcsyaTsDqgiY7BsYw';

  PostsService._();

  static final PostsService _dbProvider = PostsService._();

  factory PostsService() => _dbProvider;

  Future<List<PostEntity>> getPosts() async {
    try {
      final query = {'api-key': _apiKeyValue};
      final response =
          await http.get(Uri.https(_timesBaseUrl, _timesPathUrl, query));

      if (response.statusCode == 200) {
        return PostsList.fromJson(json.decode(response.body)).postsList;
      } else {
        throw Exception('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
