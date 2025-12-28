import 'package:flutter_riverpod/legacy.dart';
import 'package:newsreader_fe/main/core/api/service.dart';
import 'package:newsreader_fe/main/domain/entity/article.dart';
import 'package:newsreader_fe/main/presentation/state/article_state.dart';

class NewsViewModel extends StateNotifier<NewsState> {
  final NewsService _newsService = NewsService();
  final int _limit = 10;

  NewsViewModel() : super(NewsState()) {
    fetchArticles();
  }

  Future<void> fetchArticles({bool isLoadMore = false}) async {
    if (state.isLoading || (isLoadMore && !state.hasMore)) return;

    state = state.copyWith(isLoading: true);

    try {
      final currentOffset = isLoadMore ? state.offset : 0;

      final response = await _newsService.getCardNews(
        offset: currentOffset,
        limit: _limit,
        category: state.activeCategory,
        level: _formatLevel(state.activeLevel), // 서버 규격에 맞게 변환
      );

      final List<dynamic> data = response.data;
      final newArticles = data.map((json) => Article.fromJson(json)).toList();

      state = state.copyWith(
        allArticles: isLoadMore
            ? [...state.allArticles, ...newArticles]
            : newArticles,
        isLoading: false,
        hasMore: newArticles.length >= _limit,
        offset: currentOffset + newArticles.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // 서버가 요구하는 'Low', 'Medium', 'High' 형식으로 변환
  String? _formatLevel(String level) {
    if (level == 'all') return 'all';
    if (level == 'low') return 'Low';
    if (level == 'medium') return 'Medium';
    if (level == 'high') return 'High';
    return null;
  }

  void setLevel(String level) {
    state = state.copyWith(activeLevel: level, offset: 0, hasMore: true);
    fetchArticles();
  }

  void setCategory(String category) {
    state = state.copyWith(activeCategory: category, offset: 0, hasMore: true);
    fetchArticles();
  }

  void resetFilters() {
    state = state.copyWith(
      activeLevel: 'all',
      activeCategory: 'all',
      offset: 0,
      hasMore: true,
    );
    fetchArticles();
  }
}

final newsProvider = StateNotifierProvider<NewsViewModel, NewsState>(
  (ref) => NewsViewModel(),
);
