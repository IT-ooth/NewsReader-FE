import 'package:newsreader_fe/main/core/model/model.dart';
import 'package:newsreader_fe/main/domain/entity/article.dart';

class NewsState {
  final NewsLevel activeLevel; // String -> Enum 변경
  final NewsCategory activeCategory; // String -> Enum 변경
  final List<Article> allArticles;
  final bool isLoading;
  final bool hasMore;
  final int offset;

  NewsState({
    this.activeLevel = NewsLevel.all, // 기본값 Enum
    this.activeCategory = NewsCategory.all, // 기본값 Enum
    this.allArticles = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
  });

  NewsState copyWith({
    NewsLevel? activeLevel,
    NewsCategory? activeCategory,
    List<Article>? allArticles,
    bool? isLoading,
    bool? hasMore,
    int? offset,
  }) {
    return NewsState(
      activeLevel: activeLevel ?? this.activeLevel,
      activeCategory: activeCategory ?? this.activeCategory,
      allArticles: allArticles ?? this.allArticles,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}
