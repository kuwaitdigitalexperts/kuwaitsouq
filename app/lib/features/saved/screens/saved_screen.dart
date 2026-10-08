import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../ads/widgets/ad_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsProvider>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final favorites = adsProvider.favorites;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.bgLight,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceWhite,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            context.tr('saved_ads_title'),
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 3,
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: AppTheme.textMuted,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: '${context.tr('saved_ads')} (${favorites.length})'),
              Tab(text: context.tr('nav_search')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Favorites List
            favorites.isEmpty
                ? _buildEmptyState(
                    icon: Icons.favorite_border,
                    title: context.tr('no_saved_ads'),
                    message: 'يمكنك حفظ الإعلانات بالضغط على أيقونة القلب في أي إعلان لمتابعتها لاحقاً',
                  )
                : RefreshIndicator(
                    onRefresh: () => adsProvider.fetchFavorites(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(14),
                      itemCount: favorites.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) => AdCard(
                        ad: favorites[i],
                        isGrid: false,
                      ),
                    ),
                  ),

            // Tab 2: Saved Searches
            _buildEmptyState(
              icon: Icons.search,
              title: 'عمليات البحث المحفوظة',
              message: 'احفظ شروط البحث لتحصل على تنبيهات فورية عند إضافة إعلانات جديدة تناسبك',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF2563EB), size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
