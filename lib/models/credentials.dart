import 'dart:convert';

class LoginCredential {
  String url = '', username = '', password = '';

  LoginCredential({this.url, this.username, this.password});

  LoginCredential.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {'url': url, 'username': username, 'password': password};

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class AuthCredential {
  final String url, token;

  AuthCredential(this.url, this.token);

  AuthCredential.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        token = json['token'];

  Map<String, dynamic> toJson() => {'url': url, 'token': token};
}
