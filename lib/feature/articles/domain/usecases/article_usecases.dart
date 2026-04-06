import '../entity/article_entity.dart';
import '../repositories/article_repositories.dart';

class ArticleUseCases {
  final ArticleRepositories articleRepositories;

  ArticleUseCases({required this.articleRepositories});

  Future<List<ArticleEntity>> call() async {
    return await articleRepositories.getArticles();
  }
}
