import 'dart:convert';

import 'package:test_project/feature/articles/data/model/article_model.dart';
import 'package:http/http.dart' as http;

abstract class ArticleDataSource {
  Future<List<ArticleModel>> getArticle();
}

class ArticleDataSourceImpl extends ArticleDataSource {
  @override
  Future<List<ArticleModel>> getArticle() async {
    final url = "https://jsonplaceholder.typicode.com/posts";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;

      final value = json.map((e) {
        final article = ArticleModel.fromJson(e);
        return article;
      }).toList();

      return value;
    } else {
      throw Exception("Failed to load articles");
    }
  }
}
