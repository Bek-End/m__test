import 'dart:convert';

class ResultDto {
    ResultDto({
        required this.status,
        required this.totalResults,
        required this.articles,
    });

    final String status;
    final int totalResults;
    final List<ArticleDto> articles;

    factory ResultDto.fromRawJson(String str) => ResultDto.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResultDto.fromJson(Map<String, dynamic> json) => ResultDto(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<ArticleDto>.from(json["articles"].map((x) => ArticleDto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    };
}

class ArticleDto {
    ArticleDto({
        required this.source,
        this.author,
        required this.title,
        required this.description,
        required this.url,
        this.urlToImage,
        required this.publishedAt,
        required this.content,
    });

    final SourceDto source;
    final String? author;
    final String title;
    final String description;
    final String url;
    final String? urlToImage;
    final DateTime publishedAt;
    final String content;

    factory ArticleDto.fromRawJson(String str) => ArticleDto.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ArticleDto.fromJson(Map<String, dynamic> json) => ArticleDto(
        source: SourceDto.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
    };
}

class SourceDto {
    SourceDto({
        this.id,
        required this.name,
    });

    final String? id;
    final String name;

    factory SourceDto.fromRawJson(String str) => SourceDto.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SourceDto.fromJson(Map<String, dynamic> json) => SourceDto(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}