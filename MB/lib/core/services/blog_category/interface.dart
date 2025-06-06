import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';
import 'package:pickleball_app/core/services/blog_category/dto/response/get_all_blogs_categories_response.dart';
import 'package:pickleball_app/core/services/blog_category/dto/response/get_all_rules_response.dart';

abstract class IBlogCategoryServiceInterface {
  Future<GetAllBlogsCategoriesResponse> getAllBlogCategories(
      int currentPage, int pageSize);

  Future<GetAllRulesResponse> getAllRules(int currentPage, int pageSize);

  Future<Rule> getRuleById(int ruleId);
}
