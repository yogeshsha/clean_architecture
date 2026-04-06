import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  int userId;
  int id;
  String title;
  String body;

  ArticleEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props {
    return [userId, id, title, body];
  }
}
