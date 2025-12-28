import 'package:newsreader_fe/main/domain/entity/article.dart';

class NewsState {
  final String activeLevel;
  final String activeCategory;
  final List<Article> allArticles;
  final bool isLoading;
  final bool hasMore;
  final int offset;

  // ✅ 고정 카테고리 리스트 정의
  static const List<String> fixedCategories = [
    'all',
    'Tech',
    'Economy',
    'Politics',
    'Society',
    'Culture',
    'World',
  ];

  NewsState({
    this.activeLevel = 'all',
    this.activeCategory = 'all',
    this.allArticles = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
  });

  // ✅ 기존 동적 추출 로직을 제거하고 고정 리스트 반환
  List<String> get categories => fixedCategories;

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
