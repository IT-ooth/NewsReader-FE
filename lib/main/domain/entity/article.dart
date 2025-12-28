class Article {
  final String title;
  final String summary;
  final String source;
  final String level;
  final String category;
  final String genre;
  final String? url;

  Article({
    required this.title,
    required this.summary,
    required this.source,
    required this.level,
    required this.category,
    required this.genre,
    this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      source: json['source'] ?? '',
      level: (json['level'] as String).toLowerCase(),
      category: json['category'] ?? 'Tech',
      genre: json['themes'] ?? '',
      url: json['url'],
    );
  }
}
