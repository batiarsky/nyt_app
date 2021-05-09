import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyt_app/ui/home_page/home_bloc.dart';
import 'package:nyt_app/ui/home_page/home_state.dart';
import 'package:nyt_app/ui/post_list_page/post_list_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<HomeCubit>(
        create: (context) => HomeCubit(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('NYT Posts'),
            centerTitle: true,
          ),
          body: HomeBody(),
        ),
      );
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _homeCubit = context.read<HomeCubit>();
    return BlocConsumer(
      bloc: _homeCubit,
      listener: (context, state) {
        if (state is HomeProgressIndicatorState) {
          _showMaterialDialog(context);
        } else if (state is HomeSuccessfulState) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) {
            return PostListPage();
          }), (Route<dynamic> route) => false);
        } else if (state is HomeErrorState) {
          _showErrorMaterialDialog(state.message, context);
        }
      },
      builder: (context, state) {
        if (state is HomeStartState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeSuccessfulState) {
          return Container();
        } else {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Posts from the home page of the New York Times newspaper',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: 120,
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () {
                        _homeCubit.getPosts();
                      },
                      child: Text('Show'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                      )),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _showMaterialDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
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
