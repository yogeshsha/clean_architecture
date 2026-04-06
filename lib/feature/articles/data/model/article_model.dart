import '../../domain/entity/article_entity.dart';

class ArticleModel extends ArticleEntity{
  ArticleModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      body: json['body'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
  ArticleEntity toEntity() =>
      ArticleEntity(userId: userId, id: id, title: title, body: body);
}