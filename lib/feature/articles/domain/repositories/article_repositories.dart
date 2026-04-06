import 'package:test_project/feature/articles/domain/entity/article_entity.dart';

abstract class ArticleRepositories {
  Future<List<ArticleEntity>> getArticles();
}
