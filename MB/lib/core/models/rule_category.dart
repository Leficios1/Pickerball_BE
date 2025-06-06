class RuleCategories {
  final int id;
  final String name;

  RuleCategories({
    required this.id,
    required this.name,
  });

  factory RuleCategories.fromJson(Map<String, dynamic> json) {
    return RuleCategories(
      id: json['id'] as int,
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
