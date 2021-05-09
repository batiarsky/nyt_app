import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyt_app/db/database.dart';
import 'package:nyt_app/services/posts_service.dart';
import 'package:nyt_app/ui/post_list_page/post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  final _postsService = PostsService();
  final DBProvider _dbProvider = DBProvider();

  PostListCubit() : super(PostListStartState()) {
    getList();
  }

  getList() async {
    try {
      final postList = await _dbProvider.getPosts();
      if (postList != null) {
        emit(PostListFetchedState(postList));
      } else {
        emit(PostListErrorState('Something went wrong'));
      }
    } catch (e) {
      Exception(e.toString());
    }
  }

  Future<Null> refreshList() async {
    try {
      final postList = await _postsService.getPosts();
      if (postList.isNotEmpty) {
        await _dbProvider.clearPosts();
        _dbProvider.insertPosts(postList);
        emit(PostListFetchedState(postList));
      } else {
        emit(PostListErrorState('Something went wrong'));
      }
    } catch (e) {
      Exception(e.toString());
    }
    return null;
  }
}
