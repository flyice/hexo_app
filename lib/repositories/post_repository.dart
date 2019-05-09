import 'package:hexo_app/data/web_api.dart';
import 'package:hexo_app/models/post.dart';

class PostRepository {
  final WebApi api;
  PostRepository(this.api);

  Future<List<Post>> getPosts() {
    return api.getPosts();
  }

  Future<Post> getPost(String slug, bool published) {
    return api.getPost(slug, published);
  }
}
