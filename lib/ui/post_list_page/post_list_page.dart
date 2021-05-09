import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyt_app/ui/post_list_page/post_list_bloc.dart';
import 'package:nyt_app/ui/post_list_page/post_list_state.dart';
import 'package:nyt_app/ui/post_page/post_page.dart';

class PostListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostListCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post list'),
          centerTitle: true,
        ),
        body: PostListBody(),
      ),
    );
  }
}

class PostListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _refreshKey = GlobalKey<RefreshIndicatorState>();
    final PostListCubit _postListCubit = context.read<PostListCubit>();
    return BlocConsumer(
      bloc: _postListCubit,
      listener: (context, state) {
        if (state is PostListErrorState) {
          _showErrorMaterialDialog(state.message, context);
        }
      },
      builder: (context, state) {
        if (state is PostListFetchedState) {
          return RefreshIndicator(
            onRefresh: () => _postListCubit.refreshList(),
            key: _refreshKey,
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: state.postList.length,
              itemBuilder: (context, index) => Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: Text(
                      index < 9
                          ? '0' + (index + 1).toString()
                          : (index + 1).toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade300),
                    ),
                    title: Text(
                      '${state.postList[index].title}',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.grey.shade300,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PostPage('${state.postList[index].url}')));
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _showErrorMaterialDialog(final String message, final BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error!"),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
