import 'package:flutter/material.dart';
import 'package:newsreader_fe/main/domain/entity/article.dart';

@immutable
class ArticleState {
  final String selectedCategory;
  final String selectedGenre;
  final String selectedDifficulty;
  final List<Article> allArticles;

  const ArticleState({
    this.selectedCategory = "전체",
    this.selectedGenre = "전체",
    this.selectedDifficulty = "전체",
    this.allArticles = const [],
  });

  // 필터링된 기사 목록을 계산하는 getter
  List<Article> get filteredArticles {
    return allArticles.where((article) {
      final matchCategory =
          selectedCategory == "전체" || article.category == selectedCategory;
      final matchGenre =
          selectedGenre == "전체" || article.genre == selectedGenre;
      final matchDifficulty =
          selectedDifficulty == "전체" ||
          article.difficulty == selectedDifficulty;
      return matchCategory && matchGenre && matchDifficulty;
    }).toList();
  }

  int get activeFilterCount {
    int count = 0;
    if (selectedCategory != "전체") count++;
    if (selectedGenre != "전체") count++;
    if (selectedDifficulty != "전체") count++;
    return count;
  }

  ArticleState copyWith({
    String? selectedCategory,
    String? selectedGenre,
    String? selectedDifficulty,
    List<Article>? allArticles,
  }) {
    return ArticleState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      allArticles: allArticles ?? this.allArticles,
    );
  }
}
