import 'package:flutter/material.dart';
import '../../domain/entity/article_entity.dart';

class ArticleCard extends StatelessWidget {
  final ArticleEntity article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(article.body),
          ],
        ),
      ),
    );
  }
}