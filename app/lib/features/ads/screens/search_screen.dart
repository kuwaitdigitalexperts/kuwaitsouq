import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/ads_provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import '../widgets/ad_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ads = context.watch<AdsProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Container(
          height: 42,
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppTheme.textMuted, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  autofocus: true,
                  style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'I am looking for...',
                    hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (q) => ads.fetchAds(search: q),
                  textInputAction: TextInputAction.search,
                ),
              ),
              if (_ctrl.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _ctrl.clear();
                    ads.fetchAds();
                  },
                  child: const Icon(Icons.close, color: AppTheme.textMuted, size: 18),
                ),
            ],
          ),
        ),
      ),
      body: ads.loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
          : ads.ads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, size: 48, color: AppTheme.primaryBlue),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _ctrl.text.isEmpty
                            ? context.tr('search_title')
                            : '${context.tr('no_ads_found')}: "${_ctrl.text}"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: ads.ads.length,
                  itemBuilder: (ctx, i) => AdCard(ad: ads.ads[i]),
                ),
    );
  }
}
