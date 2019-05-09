import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends Equatable {
  final String title;
  final DateTime date;
  @JsonKey(name: '_content')
  final String rawContent;
  final String source;
  final String raw;
  final String slug;
  final bool published;
  final DateTime updated;
  final bool comments;
  final String layout;
  final List<String> photos;
  final String link;
  @JsonKey(name: '_id')
  final String id;
  final String content;
  final Map<String, dynamic> site;
  final String excerpt;
  final String more;
  final String path;
  final String permalink;
  @JsonKey(name: 'full_source')
  final String fullSource;
  @JsonKey(name: 'asset_dir')
  final String assetDir;
  final List<Map<String, dynamic>> tags;
  final List<Map<String, dynamic>> categories;

  Post(
      {this.title,
      this.date,
      this.rawContent,
      this.source,
      this.raw,
      this.slug,
      this.published,
      this.updated,
      this.comments,
      this.layout,
      this.photos,
      this.link,
      this.id,
      this.content,
      this.site,
      this.excerpt,
      this.more,
      this.path,
      this.permalink,
      this.fullSource,
      this.assetDir,
      this.tags,
      this.categories})
      : super([slug, published]);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
