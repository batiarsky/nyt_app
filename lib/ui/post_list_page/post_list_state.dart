import 'package:nyt_app/model/post_entity.dart';

abstract class PostListState {}

class PostListStartState extends PostListState {}

class PostListProgressIndicatorState extends PostListState {}

class PostListFetchedState extends PostListState {
  List<PostEntity> postList;

  PostListFetchedState(this.postList);
}

class PostListErrorState extends PostListState {
  final String message;

  PostListErrorState(this.message);
}
