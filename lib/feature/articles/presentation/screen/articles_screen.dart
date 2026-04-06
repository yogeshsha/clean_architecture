import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_project/feature/articles/presentation/provider/article_provider.dart';
import 'package:test_project/feature/articles/presentation/widgets/article_card.dart';

import '../widgets/theme_change_component.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articleProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          ThemeChangeComponent()
        ],
      ),
      body: articlesAsync.when(
        data: (articles) => ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ArticleCard(article: articles[index]);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
