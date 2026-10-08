import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/models/ad_model.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final liveAds = adsProvider.ads;

    if (!adsProvider.loading && liveAds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('recent_ads'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E2923),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
              ),
              child: Column(
                children: [
                  const Icon(Icons.storefront_outlined, size: 38, color: AppTheme.textMuted),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('no_ads_found'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'كن أول من يضيف إعلاناً في سوق الكويت (KuwaitSouq)!',
                    style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/post-ad'),
                    icon: const Icon(Icons.add_circle_outline, size: 16),
                    label: Text(context.tr('post_ad')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header: "সাম্প্রতিক বিজ্ঞাপন" + "সব দেখুন >"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2923),
                  letterSpacing: -0.3,
                ),
              ),
              InkWell(
                onTap: () => context.push('/search'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    children: [
                      Text(
                        context.tr('see_all'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Horizontal list of REAL live ad cards from database
          SizedBox(
            height: 186,
            child: adsProvider.loading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: liveAds.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final ad = liveAds[index];
                      return _buildLiveAdCard(context, ad);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAdCard(BuildContext context, dynamic ad) {
    final currency = context.tr('currency_symbol');
    final formattedPrice = '$currency ${ad.price?.toStringAsFixed(0) ?? '0'}';
    final String? imageUrl = (ad is AdModel)
        ? ad.primaryImageUrl
        : (ad.images != null && (ad.images as List).isNotEmpty ? (ad.images as List).first as String? : null);
    final String locationText = (ad is AdModel)
        ? (ad.locationName.isNotEmpty ? ad.locationName : context.tr('all_districts'))
        : (ad.location is String ? ad.location as String : context.tr('all_districts'));

    return InkWell(
      onTap: () => context.push('/ads/${ad.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 136,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E7E4), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              child: SizedBox(
                height: 85,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: Colors.grey.shade100),
                        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 28),
                      )
                    else
                      Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined, color: Colors.grey),
                      ),

                    // Badge
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF24E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.tr('badge_new'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Heart Icon
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title ?? 'Ad',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2923),
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formattedPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryBlue,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 11,
                        color: Color(0xFF74827B),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF74827B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
