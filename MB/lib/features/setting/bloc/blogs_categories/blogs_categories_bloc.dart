import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';

import 'blogs_categories_event.dart';
import 'blogs_categories_state.dart';

class BlogsCategoriesBloc
    extends Bloc<BlogsCategoriesEvent, BlogsCategoriesState> {
  BlogsCategoriesBloc() : super(BlogsInitial()) {
    on<LoadBlogsCategories>(_onLoadBlogsCategories);
  }

  Future<void> _onLoadBlogsCategories(
      LoadBlogsCategories event, Emitter<BlogsCategoriesState> emit) async {
    emit(BlogsLoading());
    try {
      final blogsCategoriesResponse =
          await globalBlogCategoryService.getAllBlogCategories(1, 10);
      print('blogsCategoriesResponse: $blogsCategoriesResponse');
      final rulesResponse = await globalBlogCategoryService.getAllRules(1, 10);
      print('rulesResponse: $rulesResponse');
      final Map<int, List<Rule>> rulesByCategoryId = {};
      for (final rule in rulesResponse.rules ?? []) {
        if (!rulesByCategoryId.containsKey(rule.blogCategoryId)) {
          rulesByCategoryId[rule.blogCategoryId] = [];
        }
        rulesByCategoryId[rule.blogCategoryId]!.add(rule);
      }
      print('rulesByCategoryId: $rulesByCategoryId');
      emit(BlogsLoaded(
          blogs: blogsCategoriesResponse.blogs ?? [],
          rules: rulesByCategoryId));
    } catch (e) {
      emit(BlogsError('Failed to load blog categories'));
    }
  }
}
