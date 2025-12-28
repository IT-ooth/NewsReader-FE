import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:newsreader_fe/main/domain/entity/article.dart';
import 'package:newsreader_fe/main/presentation/provider/article_provider.dart';
import 'package:newsreader_fe/main/presentation/state/article_state.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(newsProvider.notifier).fetchArticles(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);
    final viewModel = ref.read(newsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 필터 섹션을 상단에 고정시키는 SliverPersistentHeader 추가
          SliverPersistentHeader(
            pinned: true, // 스크롤 시 상단에 고정됨
            delegate: _StickyFilterDelegate(
              child: _buildFilterSection(state, viewModel),
            ),
          ),
          _buildArticleList(state, viewModel),
          if (state.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "IT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "TechFeed",
            style: TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            LucideIcons.search,
            color: Color(0xFF4B5563),
            size: 20,
          ),
        ),
      ],
    );
  }

  // 필터 섹션 위젯
  Widget _buildFilterSection(NewsState state, NewsViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterRow(
            icon: LucideIcons.filter,
            label: "LEVEL",
            items: ['all', 'low', 'medium', 'high'],
            activeItem: state.activeLevel,
            onTap: viewModel.setLevel,
            labelMapper: (lvl) =>
                lvl == 'all' ? '전체 난이도' : _levelConfig[lvl]!['label'],
          ),
          const SizedBox(height: 12),
          _buildFilterRow(
            icon: LucideIcons.tag,
            label: "TOPIC",
            items: state.categories,
            activeItem: state.activeCategory,
            onTap: viewModel.setCategory,
            labelMapper: (cat) => cat == 'all' ? '전체 주제' : cat,
            isCategory: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow({
    required IconData icon,
    required String label,
    required List<String> items,
    required String activeItem,
    required Function(String) onTap,
    required String Function(String) labelMapper,
    bool isCategory = false,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF9CA3AF),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 12),
          ...items.map((item) {
            final isActive = activeItem == item;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onTap(item),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCategory ? 12 : 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? (isCategory
                              ? const Color(0xFFEEF2FF)
                              : const Color(0xFF111827))
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(isCategory ? 6 : 20),
                    border: isCategory
                        ? Border.all(
                            color: isActive
                                ? const Color(0xFF4F46E5)
                                : Colors.transparent,
                          )
                        : null,
                  ),
                  child: Text(
                    labelMapper(item),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isActive
                          ? (isCategory
                                ? const Color(0xFF4F46E5)
                                : Colors.white)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildArticleList(NewsState state, NewsViewModel viewModel) {
    final articles = state.allArticles;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${state.activeCategory == 'all' ? '추천' : state.activeCategory} 뉴스",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    "총 ${articles.length}개의 아티클 발견",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              if (state.activeLevel != 'all' || state.activeCategory != 'all')
                TextButton(
                  onPressed: viewModel.resetFilters,
                  child: const Text(
                    "필터 초기화",
                    style: TextStyle(
                      color: Color(0xFF4F46E5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (articles.isEmpty && !state.isLoading)
            _buildEmptyState()
          else
            ...articles.map((art) => _buildArticleCard(art)),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "END OF FEED",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFD1D5DB),
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildArticleCard(Article art) {
    final config = _levelConfig[art.level] ?? _levelConfig['low']!;
    return GestureDetector(
      onTap: () async {
        if (art.url != null && await canLaunchUrlString(art.url!)) {
          await launchUrlString(art.url!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: config['border'], width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: config['bg'],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          art.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: config['text'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "/",
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        LucideIcons.hash,
                        size: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        art.genre,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.clock,
                        size: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "5분",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                art.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                art.summary,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                  height: 1.6,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: const Color(0xFFF9FAFB)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFFF3F4F6),
                        child: Text(
                          art.source.isNotEmpty ? art.source[0] : "?",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        art.source,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "•",
                        style: TextStyle(color: Color(0xFFD1D5DB)),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "방금 전",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: config['badgeBg'],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              config['icon'],
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              config['label'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: config['text'],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        LucideIcons.bookmark,
                        size: 18,
                        color: Color(0xFFD1D5DB),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        LucideIcons.share2,
                        size: 18,
                        color: Color(0xFFD1D5DB),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(LucideIcons.search, size: 48, color: Color(0xFFD1D5DB)),
          SizedBox(height: 16),
          Text(
            "선택한 조건에 맞는 기사가 없습니다.",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "다른 난이도나 카테고리를 선택해 보세요.",
            style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  static const Map<String, Map<String, dynamic>> _levelConfig = {
    'low': {
      'label': '입문',
      'bg': Color(0xFFECFDF5),
      'text': Color(0xFF047857),
      'border': Color(0xFF10B981),
      'badgeBg': Color(0xFFD1FAE5),
      'icon': '🐣',
    },
    'medium': {
      'label': '실무',
      'bg': Color(0xFFEFF6FF),
      'text': Color(0xFF1D4ED8),
      'border': Color(0xFF3B82F6),
      'badgeBg': Color(0xFFDBEAFE),
      'icon': '💻',
    },
    'high': {
      'label': '심화',
      'bg': Color(0xFFFAF5FF),
      'text': Color(0xFF7E22CE),
      'border': Color(0xFFA855F7),
      'badgeBg': Color(0xFFF3E8FF),
      'icon': '🧠',
    },
  };
}

class _StickyFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterDelegate({required this.child});

  // 98.0에서 105.0 정도로 여유 있게 늘려줍니다.
  @override
  double get minExtent => 105.0;
  @override
  double get maxExtent => 105.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 내부에서 Overflow가 발생하지 않도록 SizedBox로 감싸줍니다.
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyFilterDelegate oldDelegate) => true;
}
