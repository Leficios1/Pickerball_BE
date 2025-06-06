import 'package:pickleball_app/core/services/blog_category/dto/models/blog.dart';

class GetAllBlogsCategoriesResponse {
  final List<Blog>? blogs;

  GetAllBlogsCategoriesResponse({this.blogs});

  factory GetAllBlogsCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return GetAllBlogsCategoriesResponse(
      blogs: json['data']['results'] != null
          ? (json['data']['results'] as List)
              .map((i) => Blog.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blogs': blogs?.map((blog) => blog.toJson()).toList(),
    };
  }
}
