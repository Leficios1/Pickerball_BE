import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/blog.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';

abstract class BlogsCategoriesState extends Equatable {
  const BlogsCategoriesState();

  @override
  List<Object> get props => [];
}

class BlogsInitial extends BlogsCategoriesState {}

class BlogsLoading extends BlogsCategoriesState {}

class BlogsLoaded extends BlogsCategoriesState {
  final List<Blog> blogs;
  final Map<int, List<Rule>> rules;

  const BlogsLoaded({required this.blogs, required this.rules});

  @override
  List<Object> get props => [blogs];
}

class BlogsError extends BlogsCategoriesState {
  final String message;

  const BlogsError(this.message);

  @override
  List<Object> get props => [message];
}
