class Rule {
  final int id;
  final String title;
  final String content;
  final String image1;
  final String? image2;
  final int blogCategoryId;

  Rule({
    required this.id,
    required this.title,
    required this.content,
    required this.image1,
    this.image2,
    required this.blogCategoryId,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image1: json['image1'],
      image2: json['image2'], // <- Thêm dòng này để lấy luôn image2
      blogCategoryId: json['blogCategoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image1': image1,
      'image2': image2,
      'blogCategoryId': blogCategoryId,
    };
  }

  @override
  String toString() {
    return 'Rule{blogCategoryId: $blogCategoryId, title: $title, image1: $image1, image2: $image2}';
  }
}
