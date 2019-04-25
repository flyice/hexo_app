import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:hexo_app/models/credentials.dart';

import '../models/Post.dart';

class UnauthenticatedException implements Exception {}

class NetworkException implements Exception {}

class InvalidUrlException implements Exception {}

class WebApiClient {
  static Future<String> auth(String url, String username, String password) {
    final bytes = utf8.encode(password);
    final digest = md5.convert(bytes).toString();

    final client = WebApiClient(AuthCredential(url, ''));
    return client._auth(username, digest);
  }

  Future<String> _auth(String username, String password) async {
    final res = await _dio
        .post('/auth', data: {'username': username, 'password': password});
    return res.data;
  }

  final String _url, _token;
  final _dio = Dio();

  WebApiClient(AuthCredential credential)
      : _url = credential.url,
        _token = credential.token {
    _dio.options.baseUrl = _url;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.headers['Authorization'] = 'Bearer $_token';
  }

  Future<List<Post>> getPosts() async {
    final res = await _dio.get('/posts');
    try {
      return (res.data as List).map((value) => Post.fromJson(value)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Post> getPost(String id) async {
    final res = await _dio.get('/post', queryParameters: {'id': id});
    try {
      return Post.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
