import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyt_app/db/database.dart';
import 'package:nyt_app/services/posts_service.dart';
import 'package:nyt_app/ui/home_page/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _postsService = PostsService();
  final DBProvider _dbProvider = DBProvider();

  HomeCubit() : super(HomeStartState()) {
    checkIfPostsEmpty();
  }

  checkIfPostsEmpty() async {
    try {
      final postList = await _dbProvider.getPosts();
      if (postList.isNotEmpty) {
        emit(HomeSuccessfulState());
      } else if (postList.isEmpty) {
        emit(HomeStartedState());
      } else {
        emit(HomeErrorState('Something went wrong!'));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  getPosts() async {
    emit(HomeProgressIndicatorState());
    try {
      final postList = await _postsService.getPosts();
      if (postList.isNotEmpty) {
        await _dbProvider.insertPosts(postList);
        emit(HomeSuccessfulState());
        return;
      } else {
        emit(HomeErrorState('Something went wrong!'));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
