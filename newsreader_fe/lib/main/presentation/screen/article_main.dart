import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsreader_fe/main/presentation/provider/article_provider.dart';
import 'package:newsreader_fe/main/presentation/state/article_state.dart';

class ArticleHomeScreen extends ConsumerWidget {
  const ArticleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(articleProvider);
    final notifier = ref.read(articleProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              "INSIGHT ARTICLES",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: isMobile
                ? _buildMobileQuickFilter(context, ref, state, notifier)
                : _buildWebFilterBar(state, notifier),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "최신 기사",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "총 ${state.filteredArticles.length}개의 결과",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildArticleGrid(state, notifier, isMobile),
              ],
            ),
          ),
        );
      },
    );
  }

  // Web Filter Bar
  PreferredSizeWidget _buildWebFilterBar(
    ArticleState state,
    ArticleNotifier notifier,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            _buildDropdownFilter(
              "카테고리",
              ["전체", "과학", "예술", "경제", "테크", "건강", "인문"],
              state.selectedCategory,
              notifier.setCategory,
            ),
            const SizedBox(width: 20),
            _buildDropdownFilter(
              "장르",
              ["전체", "교양", "비평", "분석", "칼럼", "정보", "역사"],
              state.selectedGenre,
              notifier.setGenre,
            ),
            const SizedBox(width: 20),
            _buildDropdownFilter(
              "난이도",
              ["전체", "쉬움", "중간", "어려움"],
              state.selectedDifficulty,
              notifier.setDifficulty,
            ),
            if (state.activeFilterCount > 0) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: notifier.clearFilters,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text("초기화"),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Mobile Quick Filter (Category Tabs)
  PreferredSizeWidget _buildMobileQuickFilter(
    BuildContext context,
    WidgetRef ref,
    ArticleState state,
    ArticleNotifier notifier,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () => _showMobileFilterSheet(context, ref),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: state.activeFilterCount > 0
                      ? Colors.blue[50]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state.activeFilterCount > 0
                        ? Colors.blue
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune,
                      size: 18,
                      color: state.activeFilterCount > 0
                          ? Colors.blue
                          : Colors.black,
                    ),
                    if (state.activeFilterCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          "${state.activeFilterCount}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 20),
            ...["전체", "과학", "예술", "경제", "테크"].map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: state.selectedCategory == cat,
                  onSelected: (val) => notifier.setCategory(cat),
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: state.selectedCategory == cat
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(
    String label,
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelect,
      child: Row(
        children: [
          Text(
            current == "전체" ? label : current,
            style: TextStyle(
              color: current == "전체" ? Colors.black : Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      itemBuilder: (context) => options
          .map((opt) => PopupMenuItem(value: opt, child: Text(opt)))
          .toList(),
    );
  }

  void _showMobileFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(articleProvider);
            final notifier = ref.read(articleProvider.notifier);

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "상세 필터",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _mobileFilterSection(
                    "장르",
                    ["전체", "교양", "비평", "분석", "칼럼"],
                    state.selectedGenre,
                    notifier.setGenre,
                  ),
                  const SizedBox(height: 20),
                  _mobileFilterSection(
                    "난이도",
                    ["전체", "쉬움", "중간", "어려움"],
                    state.selectedDifficulty,
                    notifier.setDifficulty,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => notifier.clearFilters(),
                          child: const Text("초기화"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            "${state.filteredArticles.length}개 결과 보기",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _mobileFilterSection(
    String title,
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: options
              .map(
                (opt) => ChoiceChip(
                  label: Text(opt),
                  selected: current == opt,
                  onSelected: (_) => onSelect(opt),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildArticleGrid(
    ArticleState state,
    ArticleNotifier notifier,
    bool isMobile,
  ) {
    final articles = state.filteredArticles;
    if (articles.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "검색 결과가 없습니다.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            TextButton(
              onPressed: notifier.clearFilters,
              child: const Text("필터 초기화"),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 220,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      article.genre,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "난이도: ${article.difficulty}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: article.difficulty == "어려움"
                            ? Colors.red
                            : article.difficulty == "중간"
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                    const Text(
                      "읽어보기 →",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
