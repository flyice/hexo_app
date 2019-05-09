import 'package:dio/dio.dart';
import 'package:hexo_app/models/post.dart';
import 'package:meta/meta.dart';

class WebApi {
  static Future<String> auth(String url, String username, String password) {
    final client = WebApi(url, '');
    return client._auth(username, password);
  }

  Future<String> _auth(String username, String password) async {
    final res = await _dio
        .post('/auth', data: {'username': username, 'password': password});
    return res.data;
  }

  final String _url, _token;
  final _dio = Dio();

  WebApi(String url, String token)
      : _url = url,
        _token = token {
    _dio.options.baseUrl = _url;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.headers['Authorization'] = 'Bearer $_token';
  }

  Future<List<Post>> getPosts(
      {bool published, int limit, int skip, String orderBy}) async {
    final res = await _dio.get('/posts', queryParameters: {
      'published': published,
      'limit': limit,
      'skip': skip,
      'orderby': orderBy
    });
    return (res.data as List).map((value) => Post.fromJson(value)).toList();
  }

  Future<Post> getPost(String slug, bool published) async {
    final type = published ? 'post' : 'draft';
    final res = await _dio.get('/posts/$type/$slug');
    return Post.fromJson(res.data);
  }

  Future<Map<String, dynamic>> createPost(
      {@required String title,
      String slug,
      String layout,
      String path,
      DateTime date,
      String content}) async {
    final res = await _dio.post('/posts', data: {
      'title': title,
      'slug': slug,
      'layout': layout,
      'path': path,
      'date': date,
      'content': content
    });

    return res.data;
  }

  Future<void> deletePost(String slug, bool published) async {
    final type = published ? 'post' : 'draft';
    await _dio.delete('/posts/$type/$slug');
  }

  Future<Map<String, dynamic>> publishDraft(String slug) async {
    final res = await _dio.patch('/posts/publish/$slug');
    return res.data;
  }
}
