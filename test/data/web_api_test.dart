import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexo_app/data/web_api.dart';
import 'package:hexo_app/models/post.dart';

void main() {
  const url = 'http://localhost:4000/api';
  group('WebApi', () {
    group('auth', () {
      test('return token if auth success', () async {
        final token = await WebApi.auth(url, 'hexo', 'hexo');
        expect(token, isA<String>());
      });
      test('raise DioError if auth failed', () async {
        expect(WebApi.auth(url, 'fakeusername', 'fakepassword'),
            throwsA(isA<DioError>()));
      });
    });
    group('posts', () {
      String token;
      WebApi api;

      setUp(() async {
        token = await WebApi.auth(url, 'hexo', 'hexo');
        api = WebApi(url, token);
      });

      test('getPosts() return post list', () async {
        final posts = await api.getPosts();
        print(posts);
        expect(posts, isA<List>());
      });

      test('getPost() return a post', () async {
        final post = await api.getPost('hello', true);
        print(post);
        expect(post, isA<Post>());
      });

      test('create()', () async {
        final result = await api.createPost(
          title: 'hello world',
          slug: 'hello-world',
        );
        expect(result, isA<Map>());
        expect(result, contains('path'));
        expect(result, contains('content'));
        addTearDown(() async {
          await Future.delayed(Duration(seconds: 2));
          api.deletePost('hello-world', true);
        });
      });
    });
  });
}
