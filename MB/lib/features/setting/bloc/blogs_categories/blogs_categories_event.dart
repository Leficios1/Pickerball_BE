import 'package:equatable/equatable.dart';

abstract class BlogsCategoriesEvent extends Equatable {
  const BlogsCategoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadBlogsCategories extends BlogsCategoriesEvent {
  const LoadBlogsCategories();

  @override
  List<Object> get props => [];
}
