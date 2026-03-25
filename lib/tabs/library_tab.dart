import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/content_service.dart';
import '../widgets/quran_tracker_card.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'nav.library'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
          tabs: [
            Tab(text: 'library.articles'.tr()),
            Tab(text: 'library.duas'.tr()),
          ],
        ),
      ),
      body: Column(
        children: [
          const QuranTrackerCard(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildArticleList(context), _buildDuaList(context)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    final articles = ContentService.getArticles();
    if (articles.isEmpty) {
      return Center(child: Text('common.noData'.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.itemCount,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              article.title.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              article.category.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showArticleDetail(context, article),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).moveX(begin: 10, end: 0);
      },
    );
  }

  Widget _buildDuaList(BuildContext context) {
    final duas = ContentService.getSupplications();
    if (duas.isEmpty) {
      return Center(child: Text('common.noData'.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.itemCount,
      itemBuilder: (context, index) {
        final dua = duas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              dua.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              dua.phonetic,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.menu_book_rounded),
            onTap: () => _showDuaDetail(context, dua),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).moveX(begin: 10, end: 0);
      },
    );
  }

  void _showArticleDetail(BuildContext context, LibraryArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                article.title.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (article.source != null)
                Text(
                  'Source: ${article.source}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              const Divider(height: 32),
              Text(
                article.content.tr(),
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDuaDetail(BuildContext context, Supplication dua) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              dua.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                dua.arabic,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Arabic',
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dua.phonetic,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  dua.translation,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on List {
  int get itemCount => length;
}
