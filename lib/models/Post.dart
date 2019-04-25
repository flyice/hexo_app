import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String title, id;
  final bool published;
  final DateTime updated;
  Post(this.title, this.id, this.published, this.updated)
      : super([title, id, published, updated]);

  static Post fromJson(Map<String, dynamic> json) {
    return Post(json['title'], json['id'], json['published'],
        DateTime.parse(json['updated']));
  }
}
