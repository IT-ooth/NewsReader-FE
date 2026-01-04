import 'package:flutter/material.dart';

// 1. 난이도 (Level) Enum
enum NewsLevel {
  all(
    key: 'all',
    label: '전체 난이도',
    apiValue: 'all', // 서버 전송 값
    // 'all' 상태일 때의 기본 색상 (필터 버튼용)
    textColor: Colors.white,
    bgColor: Color(0xFF111827),
    borderColor: Colors.transparent,
    badgeBgColor: Colors.transparent,
    icon: '',
  ),
  low(
    key: 'low',
    label: '입문',
    apiValue: 'Low',
    textColor: Color(0xFF047857),
    bgColor: Color(0xFFECFDF5),
    borderColor: Color(0xFF10B981),
    badgeBgColor: Color(0xFFD1FAE5),
    icon: '🐣',
  ),
  medium(
    key: 'medium',
    label: '실무',
    apiValue: 'Medium',
    textColor: Color(0xFF1D4ED8),
    bgColor: Color(0xFFEFF6FF),
    borderColor: Color(0xFF3B82F6),
    badgeBgColor: Color(0xFFDBEAFE),
    icon: '💻',
  ),
  high(
    key: 'high',
    label: '심화',
    apiValue: 'High',
    textColor: Color(0xFF7E22CE),
    bgColor: Color(0xFFFAF5FF),
    borderColor: Color(0xFFA855F7),
    badgeBgColor: Color(0xFFF3E8FF),
    icon: '🧠',
  );

  final String key; // 내부 식별 및 Prefs 저장용
  final String label; // UI 표시용
  final String apiValue; // 서버 요청용
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final Color badgeBgColor;
  final String icon;

  const NewsLevel({
    required this.key,
    required this.label,
    required this.apiValue,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
    required this.badgeBgColor,
    required this.icon,
  });

  // String 키로 Enum 찾기
  static NewsLevel fromKey(String? key) => NewsLevel.values.firstWhere(
    (e) => e.key == key?.toLowerCase(),
    orElse: () => NewsLevel.all,
  );
}

// 2. 카테고리 (Category) Enum
enum NewsCategory {
  all('all', '전체 주제'),
  tech('Tech', 'IT/기술'),
  economy('Economy', '경제'),
  politics('Politics', '정치'),
  society('Society', '사회'),
  culture('Culture', '문화'),
  world('World', '세계');

  final String key; // API 값 겸 Prefs 저장 키
  final String displayName; // UI 표시 이름

  const NewsCategory(this.key, this.displayName);

  static NewsCategory fromKey(String? key) => NewsCategory.values.firstWhere(
    (e) => e.key == key,
    orElse: () => NewsCategory.all,
  );
}
