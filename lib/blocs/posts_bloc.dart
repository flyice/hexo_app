import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hexo_app/blocs/auth_bloc.dart';
import 'package:hexo_app/models/post.dart';
import 'package:hexo_app/repositories/post_repository.dart';

abstract class PostsEvent extends Equatable {
  PostsEvent([List props = const []]) : super(props);

  @override
  String toString() => runtimeType.toString();
}

class FetchPosts extends PostsEvent {
  final void Function() callback;
  FetchPosts([this.callback]) : super([callback]);
}

abstract class PostsState extends Equatable {
  PostsState([List props = const []]) : super(props);
  @override
  String toString() => runtimeType.toString();
}

class PostsUninitialized extends PostsState {}

class PostsError extends PostsState {
  final String error;
  PostsError(this.error) : super([error]);
}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  PostsLoaded(this.posts) : super([posts]);
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository postRepository;
  final AuthBloc authBloc;
  PostsBloc(this.postRepository, this.authBloc);
  @override
  PostsState get initialState => PostsUninitialized();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is FetchPosts) {
      try {
        final posts = await postRepository.getPosts();
        yield PostsLoaded(posts);
      } catch (e) {
        if (e is DioError) {
          if (e.response != null) {
            if (e.response.statusCode == 401) {
              authBloc.dispatch(LoggedOut());
            }
          }
        }
        yield PostsError(e.toString());
      } finally {
        event.callback ?? event.callback();
      }
    }
  }
}
