import 'package:flutter_riverpod/legacy.dart';
import 'package:newsreader_fe/main/core/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsreader_fe/main/core/api/service.dart';
import 'package:newsreader_fe/main/domain/entity/article.dart';
import 'package:newsreader_fe/main/presentation/state/article_state.dart';

class NewsViewModel extends StateNotifier<NewsState> {
  final NewsService _newsService = NewsService();
  final int _limit = 10;

  // 저장소 키
  static const String _prefLevelKey = 'pref_level';
  static const String _prefCategoryKey = 'pref_category';

  NewsViewModel() : super(NewsState()) {
    // 생성자에서 저장된 설정을 먼저 로드하고 API를 호출합니다.
    _loadFiltersAndFetch();
  }

  // 1. 초기화: 저장된 필터 불러오기
  Future<void> _loadFiltersAndFetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLevel = prefs.getString(_prefLevelKey);
      final savedCategory = prefs.getString(_prefCategoryKey);

      state = state.copyWith(
        activeLevel: NewsLevel.fromKey(savedLevel),
        activeCategory: NewsCategory.fromKey(savedCategory),
      );
    } catch (e) {
      // 로드 실패시 기본값 유지
    }
    // 설정 로드 후 데이터 가져오기
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
        // Enum의 속성(key, apiValue)을 직접 사용 -> 변환 로직 제거됨
        category: state.activeCategory.key,
        level: state.activeLevel.apiValue,
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

  // 2. 레벨 변경 & 저장
  Future<void> setLevel(NewsLevel level) async {
    state = state.copyWith(activeLevel: level, offset: 0, hasMore: true);
    _saveString(_prefLevelKey, level.key);
    fetchArticles();
  }

  // 3. 카테고리 변경 & 저장
  Future<void> setCategory(NewsCategory category) async {
    state = state.copyWith(activeCategory: category, offset: 0, hasMore: true);
    _saveString(_prefCategoryKey, category.key);
    fetchArticles();
  }

  // 4. 초기화 & 저장소 삭제
  Future<void> resetFilters() async {
    state = state.copyWith(
      activeLevel: NewsLevel.all,
      activeCategory: NewsCategory.all,
      offset: 0,
      hasMore: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefLevelKey);
    await prefs.remove(_prefCategoryKey);

    fetchArticles();
  }

  // 내부 헬퍼
  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

final newsProvider = StateNotifierProvider<NewsViewModel, NewsState>(
  (ref) => NewsViewModel(),
);
