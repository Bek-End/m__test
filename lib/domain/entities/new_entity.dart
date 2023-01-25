import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'new_entity.g.dart';

class ResultEntity {
  ResultEntity({
    required this.totalResults,
    required this.newEntity,
  });

  final int totalResults;
  final List<NewEntity> newEntity;

  ResultEntity copyWith({
    int? totalResults,
    List<NewEntity>? newEntity,
  }) =>
      ResultEntity(
        totalResults: totalResults ?? this.totalResults,
        newEntity: newEntity ?? this.newEntity,
      );
}

@HiveType(typeId: 1)
class SourceEntity extends HiveObject {
  SourceEntity({
    this.id,
    required this.name,
  });

  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String name;
}

@HiveType(typeId: 0)
class NewEntity extends HiveObject with EquatableMixin {
  @HiveField(0)
  final SourceEntity source;
  @HiveField(1)
  final String? author;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final String? urlToImage;
  @HiveField(6)
  final DateTime publishedAt;
  @HiveField(7)
  final String content;
  @HiveField(8)
  bool isFavorite;
  NewEntity({
    required this.source,
    required this.title,
    required this.description,
    required this.url,
    required this.publishedAt,
    required this.content,
    this.isFavorite = false,
    this.author,
    this.urlToImage,
  });

  NewEntity copyWith({
    bool? isFavorite,
  }) =>
      NewEntity(
        source: source,
        title: title,
        description: description,
        url: url,
        publishedAt: publishedAt,
        content: content,
        isFavorite: isFavorite ?? this.isFavorite,
        author: author,
        urlToImage: urlToImage,
      );

  @override
  List<Object?> get props => [isFavorite];
}
