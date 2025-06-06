import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/blog.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/blogs_categories_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/blogs_categories_event.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/blogs_categories_state.dart';
import 'package:pickleball_app/features/setting/widgets/rules_widget.dart';

@RoutePage()
class BlogCategoriesPage extends StatefulWidget {
  const BlogCategoriesPage({super.key});

  @override
  _BlogCategoriesPageState createState() => _BlogCategoriesPageState();
}

class _BlogCategoriesPageState extends State<BlogCategoriesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Blog> blogs;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlogsCategoriesBloc>(context)
        .add(const LoadBlogsCategories());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: blogs.map((blog) => Tab(text: blog.name)).toList(),
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Blog Categories',
      ),
      body: BlocBuilder<BlogsCategoriesBloc, BlogsCategoriesState>(
        builder: (context, state) {
          if (state is BlogsLoaded) {
            blogs = state.blogs;
            _tabController = TabController(length: blogs.length, vsync: this);
            return Column(
              children: [
                buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: blogs.map((blog) {
                      final blogRules = state.rules[blog.id];
                      if (blogRules != null) {
                        return RulesWidget(rules: blogRules);
                      } else {
                        return const Center(child: Text('No rules available'));
                      }
                    }).toList(),
                  ),
                ),
              ],
            );
          } else if (state is BlogsLoading) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primaryColor,
                size: 30,
              ),
            );
          } else {
            return const Center(child: Text('No blogs available'));
          }
        },
      ),
    );
  }
}
