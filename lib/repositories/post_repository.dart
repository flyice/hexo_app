import 'package:hexo_app/data/web_api_client.dart';
import 'package:hexo_app/models/Post.dart';

class PostRepository {
  final WebApiClient client;
  PostRepository(this.client);

  Future<List<Post>> getPosts() {
    return client.getPosts();
  }

  Future<Post> getPost(String id) {
    return client.getPost(id);
  }
}
