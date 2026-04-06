import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_source/remote_data_source.dart';
import '../../data/repositories/article_repositories_impl.dart';
import '../../domain/repositories/article_repositories.dart';
import '../../domain/usecases/article_usecases.dart';

final articleRemoteDataSourceProvider = Provider<ArticleDataSource>((ref) {
  return ArticleDataSourceImpl();
});

final articleRepositoryProvider = Provider<ArticleRepositories>((ref) {
  return ArticleRepositoriesImpl(
    articleDataSource: ref.watch(articleRemoteDataSourceProvider),
  );
});

final getArticlesUseCaseProvider = Provider((ref) {
  return ArticleUseCases(
    articleRepositories: ref.watch(articleRepositoryProvider),
  );
});

final articleProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getArticlesUseCaseProvider);
  return await useCase();
});
