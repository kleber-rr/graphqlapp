import 'comment.dart';

class Post {
  final String? id;
  final String content;
  final List<Comment>? comments;

  Post({
    this.id,
    required this.content,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      comments: json['comments'] == null ? [] : (json['comments'] as List<dynamic>)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
    );
  }
}