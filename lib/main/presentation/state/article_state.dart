import 'package:newsreader_fe/main/domain/entity/article.dart';

class NewsState {
  final String activeLevel;
  final String activeCategory;
  final List<Article> allArticles;
  final bool isLoading;
  final bool hasMore;
  final int offset;

  NewsState({
    this.activeLevel = 'all',
    this.activeCategory = 'all',
    this.allArticles = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
  });

  // 동적 카테고리 추출 게터
  List<String> get categories {
    final cats = allArticles.map((a) => a.category).toSet().toList();
    return ['all', ...cats];
  }

  NewsState copyWith({
    String? activeLevel,
    String? activeCategory,
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
