import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';
import 'package:pickleball_app/core/services/blog_category/dto/response/get_all_blogs_categories_response.dart';
import 'package:pickleball_app/core/services/blog_category/dto/response/get_all_rules_response.dart';
import 'package:pickleball_app/core/services/blog_category/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/blog_category/interface.dart';

class BlogCategoryService implements IBlogCategoryServiceInterface {
  BlogCategoryService();

  @override
  Future<GetAllBlogsCategoriesResponse> getAllBlogCategories(
      int currentPage, int pageSize) async {
    final response = await globalApiService.get(
      '${Endpoints.getAllBlogCategories}?currentPage=$currentPage&pageSize=$pageSize',
    );
    return GetAllBlogsCategoriesResponse.fromJson(response);
  }

  @override
  Future<GetAllRulesResponse> getAllRules(int currentPage, int pageSize) async {
    final response = await globalApiService.get(
      '${Endpoints.getAllRules}?currentPage=$currentPage&pageSize=$pageSize',
    );

    return GetAllRulesResponse.fromJson({'rules': response['data']['results']});
  }

  @override
  Future<Rule> getRuleById(int ruleId) async {
    final response = await globalApiService.get(
      '${Endpoints.getRuleById}$ruleId',
    );
    final rule = Rule.fromJson(response['data']);
    return rule;
  }
}
