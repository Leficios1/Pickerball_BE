class Rules {
  final int id;
  final String title;
  final String content;
  final int ruleCategoryId;

  Rules({
    required this.id,
    required this.title,
    required this.content,
    required this.ruleCategoryId,
  });

  factory Rules.fromJson(Map<String, dynamic> json) {
    return Rules(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      ruleCategoryId: json['ruleCategoryId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'ruleCategoryId': ruleCategoryId,
    };
  }
}
