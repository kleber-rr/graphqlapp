class Comment {
  final String? id;
  final String content;
  final String postId;

  Comment({
    this.id,
    required this.content,
    required this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      postId: json['postId'],
    );
  }
}