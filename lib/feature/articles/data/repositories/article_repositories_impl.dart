import 'package:test_project/feature/articles/domain/entity/article_entity.dart';
import 'package:test_project/feature/articles/domain/repositories/article_repositories.dart';

import '../data_source/remote_data_source.dart';

class ArticleRepositoriesImpl extends ArticleRepositories {
  final ArticleDataSource articleDataSource;

  ArticleRepositoriesImpl({required this.articleDataSource});

  @override
  Future<List<ArticleEntity>> getArticles() async {
    final value = await articleDataSource.getArticle();
    return value.map((e)=>e.toEntity()).toList();
  }
}
