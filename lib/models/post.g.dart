// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      title: json['title'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      rawContent: json['_content'] as String,
      source: json['source'] as String,
      raw: json['raw'] as String,
      slug: json['slug'] as String,
      published: json['published'] as bool,
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
      comments: json['comments'] as bool,
      layout: json['layout'] as String,
      photos: (json['photos'] as List)?.map((e) => e as String)?.toList(),
      link: json['link'] as String,
      id: json['_id'] as String,
      content: json['content'] as String,
      site: json['site'] as Map<String, dynamic>,
      excerpt: json['excerpt'] as String,
      more: json['more'] as String,
      path: json['path'] as String,
      permalink: json['permalink'] as String,
      fullSource: json['full_source'] as String,
      assetDir: json['asset_dir'] as String,
      tags: (json['tags'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList(),
      categories: (json['categories'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList());
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      '_content': instance.rawContent,
      'source': instance.source,
      'raw': instance.raw,
      'slug': instance.slug,
      'published': instance.published,
      'updated': instance.updated?.toIso8601String(),
      'comments': instance.comments,
      'layout': instance.layout,
      'photos': instance.photos,
      'link': instance.link,
      '_id': instance.id,
      'content': instance.content,
      'site': instance.site,
      'excerpt': instance.excerpt,
      'more': instance.more,
      'path': instance.path,
      'permalink': instance.permalink,
      'full_source': instance.fullSource,
      'asset_dir': instance.assetDir,
      'tags': instance.tags,
      'categories': instance.categories
    };
