import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class SubcategoriesScreen extends StatefulWidget {
  final int parentId;
  final String title;

  const SubcategoriesScreen({
    super.key,
    required this.parentId,
    required this.title,
  });

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catsProvider = context.watch<CategoriesProvider>();
    final allChildren = catsProvider.childrenOf(widget.parentId);
    final filtered = _filter.isEmpty
        ? allChildren
        : allChildren.where((c) {
            final name = (c['name'] as String? ?? '').toLowerCase();
            return name.contains(_filter.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.inputBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppTheme.textMuted, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(color: AppTheme.textDark, fontSize: 13),
                  onChanged: (val) => setState(() => _filter = val),
                  decoration: InputDecoration(
                    hintText: 'Search in ${widget.title}...',
                    hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: catsProvider.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            )
          : filtered.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 54,
                        color: AppTheme.textMuted,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No subcategories found',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: AppTheme.borderLight,
                    indent: 74,
                  ),
                  itemBuilder: (context, index) {
                    final sub = filtered[index];
                    final rawName = (sub['name'] ?? '').toString().trim();
                    final parenMatch = RegExp(r'^([^(]+)\s*\(([^)]+)\)').firstMatch(rawName);
                    final extractedEn = parenMatch != null ? parenMatch.group(1)!.trim() : rawName;
                    final extractedBn = parenMatch != null ? parenMatch.group(2)!.trim() : '';

                    final String nameEn = (sub['english_name'] ?? (extractedEn.isNotEmpty ? extractedEn : rawName)).toString().trim();
                    final String nameBn = (sub['name_bn'] ?? sub['bengali_name'] ?? extractedBn).toString().trim();
                    final String displayName = (nameBn.isNotEmpty && nameBn.toLowerCase() != nameEn.toLowerCase())
                        ? '$nameEn ($nameBn)'
                        : (nameEn.isNotEmpty ? nameEn : rawName);
                    final String? imageUrl = sub['icon_url'] ?? sub['image'];
                    final int totalAds = sub['total_ads'] ?? 0;
                    final int subId = sub['id'] as int;

                    return InkWell(
                      onTap: () {
                        final nested = catsProvider.childrenOf(subId);
                        if (nested.isNotEmpty) {
                          context.push('/subcategories/$subId', extra: {
                            'title': displayName,
                            'category': sub,
                          });
                        } else {
                          context.push('/category-ads/$subId', extra: {
                            'title': displayName,
                            'parentTitle': widget.title,
                            'category': sub,
                          });
                        }
                      },
                      child: Container(
                        color: AppTheme.surfaceWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.tagBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.contain,
                                      errorWidget: (_, __, ___) => const Icon(
                                        Icons.image_outlined,
                                        color: AppTheme.primaryGreen,
                                        size: 20,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image_outlined,
                                      color: AppTheme.primaryGreen,
                                      size: 20,
                                    ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    totalAds > 0
                                        ? '$totalAds إعلان في الكويت'
                                        : '0 إعلان',
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppTheme.textMuted,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
