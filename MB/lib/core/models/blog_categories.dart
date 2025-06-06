class BlogCategories {
  String id;
  String name;

  BlogCategories({
    required this.id,
    required this.name,
  });

  factory BlogCategories.fromJson(Map<String, dynamic> json) {
    return BlogCategories(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
