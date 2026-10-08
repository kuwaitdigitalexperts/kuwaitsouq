import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/ad_model.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsProvider>().fetchMyAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final adsProvider = context.watch<AdsProvider>();
    final rawId = auth.user?['id'];
    final myId = rawId != null ? int.tryParse(rawId.toString()) : null;

    final myAds = adsProvider.myAds.isNotEmpty
        ? adsProvider.myAds
        : (myId != null ? adsProvider.ads.where((a) => a.userId == myId).toList() : <AdModel>[]);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          context.tr('my_ads'),
          style: const TextStyle(color: AppTheme.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: adsProvider.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryBlue),
            )
          : myAds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppTheme.tagBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.inventory_2_outlined, size: 48, color: AppTheme.primaryBlue),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr('no_ads_found'),
                        style: const TextStyle(color: AppTheme.textDark, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.tr('post_ad_cta'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(context.tr('post_ad_title')),
                        onPressed: () => context.push('/post-ad'),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: myAds.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ad = myAds[index];
                    final fmt = NumberFormat.currency(locale: 'ar_KW', symbol: '${ad.currency} ', decimalDigits: 0);

                    return Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderLight, width: 0.8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 85,
                              height: 85,
                              color: const Color(0xFFF2F5F3),
                              child: ad.primaryImageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: ad.primaryImageUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => const Icon(Icons.image_outlined, color: AppTheme.textMuted),
                                    )
                                  : const Icon(Icons.image_outlined, color: AppTheme.textMuted),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fmt.format(ad.price),
                                  style: const TextStyle(
                                    color: AppTheme.priceRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ad.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppTheme.textDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ad.locationName.isNotEmpty ? ad.locationName : 'مدينة الكويت (Kuwait City)',
                                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppTheme.surfaceWhite,
                                  title: Text(context.tr('delete'), style: const TextStyle(color: AppTheme.textDark)),
                                  content: Text(
                                    context.tr('delete'),
                                    style: const TextStyle(color: AppTheme.textMuted),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text(context.tr('cancel')),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text(context.tr('delete'), style: const TextStyle(color: Colors.redAccent)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true && context.mounted) {
                                await context.read<AdsProvider>().deleteAd(ad.id);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
