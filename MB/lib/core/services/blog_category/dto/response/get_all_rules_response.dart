import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';

class GetAllRulesResponse {
  final List<Rule>? rules;

  GetAllRulesResponse({required this.rules});

  factory GetAllRulesResponse.fromJson(Map<String, dynamic> json) {
    return GetAllRulesResponse(
      rules: json['rules'] != null
          ? (json['rules'] as List).map((i) => Rule.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rules': rules?.map((rule) => rule.toJson()).toList(),
    };
  }
}
