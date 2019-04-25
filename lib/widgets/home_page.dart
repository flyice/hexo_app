import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexo_app/blocs/posts_bloc.dart';
import 'package:hexo_app/data/web_api_client.dart';
import 'package:hexo_app/repositories/post_repository.dart';
import '../blocs/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/credentials.dart';

class HomePage extends StatefulWidget {
  final AuthCredential credential;
  HomePage(this.credential);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostsBloc _postsBloc;
  Completer<void> _completer;
  AuthBloc _authBloc;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    final client = WebApiClient(widget.credential);
    final postRepository = PostRepository(client);
    _postsBloc = PostsBloc(postRepository);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _postsBloc.dispatch(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _handlePressAddButton(),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Text('H'),
                ),
                accountEmail: Text('username'),
                accountName: Text('data'),
              ),
              ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings),
              ),
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  _authBloc.dispatch(LoggedOut());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder(
          bloc: _postsBloc,
          builder: (_, PostsState state) {
            if (state is PostsUninitialized) {
              _postsBloc.dispatch(FetchPosts());
              return Center(
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: RefreshProgressIndicator(),
                ),
              );
            }

            if (state is PostsError) {
              return _buildRetry("can't fetch posts");
            }

            if (state is PostsLoaded) {
              if (state.posts.isEmpty) {
                return _buildRetry('no posts');
              }
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (_, index) {
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text('updated at: ${post.updated}'),
                      onTap: () {},
                    );
                  },
                ),
              );
            }
          },
        ));
  }

  Future<void> _handleRefresh() {
    _completer = Completer<void>();
    _postsBloc.dispatch(FetchPosts(() {
      _completer?.complete();
    }));
    return _completer.future;
  }

  _handlePressAddButton() {}

  Widget _buildRetry(String text) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(text),
            FlatButton(
              child: Text(
                'try again',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postsBloc.dispose();
    super.dispose();
  }
}
