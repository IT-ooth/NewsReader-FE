import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsreader_fe/main/domain/entity/article.dart';
import 'package:newsreader_fe/main/presentation/state/article_state.dart';

class ArticleNotifier extends Notifier<ArticleState> {
  @override
  ArticleState build() {
    // build() 메서드 내에서 초기 상태를 반환합니다.
    // 향후 로컬 저장소나 API에서 데이터를 가져올 때 유용합니다.
    return ArticleState(
      allArticles: [
        Article(
          id: 1,
          title: "양자 역학의 기초: 초보자를 위한 가이드",
          difficulty: "쉬움",
          genre: "교양",
          category: "과학",
          description: "복잡한 과학 이론을 쉬운 예시로 풀어 설명합니다.",
        ),
        Article(
          id: 2,
          title: "현대 미술의 흐름과 사회적 영향",
          difficulty: "중간",
          genre: "비평",
          category: "예술",
          description: "현대 미술이 우리 사회에 던지는 메시지를 분석합니다.",
        ),
        Article(
          id: 3,
          title: "2024 글로벌 경제 전망 보고서",
          difficulty: "어려움",
          genre: "분석",
          category: "경제",
          description: "전문적인 통계 데이터를 바탕으로 한 내년도 경제 예측.",
        ),
        Article(
          id: 4,
          title: "AI 시대의 윤리적 딜레마",
          difficulty: "중간",
          genre: "칼럼",
          category: "테크",
          description: "인공지능 발전과 함께 대두되는 윤리적 문제들.",
        ),
        Article(
          id: 5,
          title: "식물 기반 식단의 건강학적 이점",
          difficulty: "쉬움",
          genre: "정보",
          category: "건강",
          description: "채식이 신체 변화에 미치는 긍정적인 영향에 대해 알아봅니다.",
        ),
        Article(
          id: 6,
          title: "고대 로마의 정치 체계 깊이 알기",
          difficulty: "어려움",
          genre: "역사",
          category: "인문",
          description: "로마 공화정의 복잡한 구조와 멸망 원인 분석.",
        ),
      ],
    );
  }

  void setCategory(String value) =>
      state = state.copyWith(selectedCategory: value);
  void setGenre(String value) => state = state.copyWith(selectedGenre: value);
  void setDifficulty(String value) =>
      state = state.copyWith(selectedDifficulty: value);

  void clearFilters() {
    state = state.copyWith(
      selectedCategory: "전체",
      selectedGenre: "전체",
      selectedDifficulty: "전체",
    );
  }
}

// Provider 정의: StateNotifierProvider 대신 NotifierProvider 사용
final articleProvider = NotifierProvider<ArticleNotifier, ArticleState>(
  ArticleNotifier.new,
);
