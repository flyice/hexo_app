import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import '../repositories/post_repository.dart';
import '../models/post.dart';

class PostEvent extends Equatable {
  PostEvent([List props = const []]) : super(props);
  @override
  String toString() => runtimeType.toString();
}

class FetchPost extends PostEvent {
  final String slug;
  final bool published;
  FetchPost(this.slug, this.published) : super([slug, published]);
}

class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
  @override
  String toString() => runtimeType.toString();
}

class PostUninitialized extends PostState {}

class PostLoaded extends PostState {
  final Post post;
  PostLoaded(this.post) : super([post]);
}

class PostError extends PostState {
  final String error;
  PostError(this.error) : super([error]);
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  PostBloc(this.postRepository);
  @override
  PostState get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchPost) {
      try {
        final post = await postRepository.getPost(event.slug, event.published);
        yield PostLoaded(post);
      } catch (e) {
        yield PostError(e.toString());
      }
    }
  }
}
