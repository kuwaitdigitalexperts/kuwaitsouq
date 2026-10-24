import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/auth_bottom_sheet.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<Map<String, dynamic>> items = [
    // Row 1
    {
      'id': 13,
      'slug': 'commercial-ads',
      'name': 'Commercial\nAds',
      'name_ar': 'إعلانات\nتجارية',
      'icon': Icons.campaign,
      'image': 'assets/images/categories/commercial_ads.png',
      'icon_color': Color(0xFF1E3A8A),
      'is_commercial': true,
      'badge': 'New',
    },
    {
      'id': 14,
      'slug': 'shops',
      'name': 'Shops',
      'name_ar': 'محلات ومتاجر',
      'icon': Icons.storefront,
      'image': 'assets/images/categories/shops.png',
      'icon_color': Color(0xFFEA580C),
    },
    {
      'id': 1,
      'slug': 'autos',
      'name': 'Autos',
      'name_ar': 'سيارات',
      'icon': Icons.directions_car,
      'image': 'assets/images/categories/autos.png',
      'icon_color': Color(0xFFDC2626),
    },
    {
      'id': 15,
      'slug': 'motorcycles',
      'name': 'Motorcycles',
      'name_ar': 'دراجات نارية',
      'icon': Icons.two_wheeler,
      'image': 'assets/images/categories/motorcycles.png',
      'icon_color': Color(0xFF2563EB),
    },

    // Row 2
    {
      'id': 9,
      'slug': 'property-for-sale',
      'name': 'Property\nFor Sale',
      'name_ar': 'عقارات\nللبيع',
      'icon': Icons.apartment,
      'image': 'assets/images/categories/property_for_sale.png',
      'icon_color': Color(0xFF0D9488),
    },
    {
      'id': 16,
      'slug': 'property-for-rent',
      'name': 'Property\nFor Rent',
      'name_ar': 'عقارات\nللإيجار',
      'icon': Icons.home_work_outlined,
      'image': 'assets/images/categories/property_for_rent.png',
      'icon_color': Color(0xFFE11D48),
    },
    {
      'id': 11,
      'slug': 'jobs',
      'name': 'Jobs',
      'name_ar': 'وظائف',
      'icon': Icons.work_outline,
      'image': 'assets/images/categories/jobs.png',
      'icon_color': Color(0xFF92400E),
    },
    {
      'id': 12,
      'slug': 'services',
      'name': 'Services',
      'name_ar': 'خدمات',
      'icon': Icons.construction,
      'image': 'assets/images/categories/services.png',
      'icon_color': Color(0xFFCA8A04),
    },

    // Row 3
    {
      'id': 17,
      'slug': 'phones-tablets',
      'name': 'Phones\n& Tablets',
      'name_ar': 'هواتف\nوأجهزة',
      'icon': Icons.phone_iphone,
      'image': 'assets/images/categories/phones_tablets.png',
      'icon_color': Color(0xFF6366F1),
    },
    {
      'id': 18,
      'slug': 'computers-laptops',
      'name': 'Computers\n& Laptops',
      'name_ar': 'كمبيوتر\nولابتوب',
      'icon': Icons.laptop_mac,
      'image': 'assets/images/categories/computers_laptops.png',
      'icon_color': Color(0xFF0284C7),
    },
    {
      'id': 19,
      'slug': 'gaming-toys',
      'name': 'Gaming & Toys',
      'name_ar': 'ألعاب فيديو',
      'icon': Icons.sports_esports,
      'image': 'assets/images/categories/gaming_toys.png',
      'icon_color': Color(0xFF7C3AED),
    },
    {
      'id': 20,
      'slug': 'sports-fitness',
      'name': 'Sports\n& Fitness',
      'name_ar': 'رياضة\nولياقة',
      'icon': Icons.fitness_center,
      'image': 'assets/images/categories/sports_fitness.png',
      'icon_color': Color(0xFF059669),
    },

    // Row 4
    {
      'id': 10,
      'slug': 'electronics',
      'name': 'Electronics',
      'name_ar': 'إلكترونيات',
      'icon': Icons.tv,
      'image': 'assets/images/categories/electronics.png',
      'icon_color': Color(0xFF3B82F6),
    },
    {
      'id': 21,
      'slug': 'household-appliances',
      'name': 'Household\nAppliances',
      'name_ar': 'أجهزة\nمنزلية',
      'icon': Icons.kitchen,
      'image': 'assets/images/categories/household_appliances.png',
      'icon_color': Color(0xFF64748B),
    },
    {
      'id': 22,
      'slug': 'home-garden',
      'name': 'Home &\nGarden',
      'name_ar': 'المنزل\nوالحديقة',
      'icon': Icons.chair_outlined,
      'image': 'assets/images/categories/home_garden.png',
      'icon_color': Color(0xFF0891B2),
    },
    {
      'id': 23,
      'slug': 'fashion-kids',
      'name': 'Fashion & Kids',
      'name_ar': 'أزياء\nوأطفال',
      'icon': Icons.checkroom,
      'image': 'assets/images/categories/fashion_kids.png',
      'icon_color': Color(0xFFDB2777),
    },

    // Row 5
    {
      'id': 24,
      'slug': 'pets-accessories',
      'name': 'Pets &\nAccessories',
      'name_ar': 'حيوانات\nوأليفة',
      'icon': Icons.pets,
      'image': 'assets/images/categories/pets_accessories.png',
      'icon_color': Color(0xFFD97706),
    },
    {
      'id': 25,
      'slug': 'leisure-collectibles',
      'name': 'Leisure &\nCollectibles',
      'name_ar': 'مقتنيات\nوتخييم',
      'icon': Icons.terrain_outlined,
      'image': 'assets/images/categories/leisure_collectibles.png',
      'icon_color': Color(0xFF2563EB),
    },
    {
      'id': 26,
      'slug': 'food',
      'name': 'Food',
      'name_ar': 'أطعمة\nومأكولات',
      'icon': Icons.lunch_dining,
      'image': 'assets/images/categories/food.png',
      'icon_color': Color(0xFFEA580C),
    },
    {
      'id': 27,
      'slug': 'beauty-health',
      'name': 'Beauty &\nHealth',
      'name_ar': 'صحة\nوجمال',
      'icon': Icons.spa,
      'image': 'assets/images/categories/beauty_health.png',
      'icon_color': Color(0xFFE11D48),
    },

    // Row 6
    {
      'id': 28,
      'slug': 'businesses-equipment',
      'name': 'Businesses\n& Equipment',
      'name_ar': 'معدات\nومشاريع',
      'icon': Icons.warehouse_outlined,
      'image': 'assets/images/categories/businesses_equipment.png',
      'icon_color': Color(0xFF475569),
    },
    {
      'id': 29,
      'slug': 'education-training',
      'name': 'Education\n& Training',
      'name_ar': 'تعليم\nوتدريب',
      'icon': Icons.school,
      'image': 'assets/images/categories/education_training.png',
      'icon_color': Color(0xFF1E293B),
    },
    {
      'id': 30,
      'slug': 'job-seekers',
      'name': 'Job Seekers',
      'name_ar': 'باحثون\nعن عمل',
      'icon': Icons.assignment_ind_outlined,
      'image': 'assets/images/categories/job_seekers.png',
      'icon_color': Color(0xFF3B82F6),
    },
    {
      'id': 31,
      'slug': 'reviews-ratings',
      'name': 'Reviews &\nRatings',
      'name_ar': 'تقييمات\nومراجعات',
      'icon': Icons.rate_review_outlined,
      'image': 'assets/images/categories/reviews_ratings.png',
      'icon_color': Color(0xFF059669),
    },

    // Row 7 (Utility Tiles)
    {
      'id': -1,
      'slug': 'all',
      'name': 'All Categories',
      'name_ar': 'جميع الأقسام',
      'icon': Icons.more_horiz,
      'image': 'assets/images/categories/all_categories.png',
      'icon_color': Color(0xFF2563EB),
      'is_special_action': 'all_categories',
    },
    {
      'id': -2,
      'slug': 'post-ad',
      'name': 'Sell Now',
      'name_ar': 'أضف إعلانك',
      'icon': Icons.camera_alt_outlined,
      'image': 'assets/images/categories/sell_now.png',
      'icon_color': Color(0xFF475569),
      'is_special_action': 'post_ad',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header matching screenshot 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAr ? 'الأقسام' : 'Categories',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                  ),
                ),
                InkWell(
                  onTap: () => context.go('/categories'),
                  child: Row(
                    children: [
                      Text(
                        isAr ? 'المزيد' : 'More',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        isAr ? Icons.arrow_back : Icons.arrow_forward,
                        size: 14,
                        color: const Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // 4-Column Grid matching screenshot 1 & 2
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final cat = items[index];
              final isCommercial = cat['is_commercial'] == true;
              final catName = isAr ? (cat['name_ar'] as String) : (cat['name'] as String);
              final iconColor = cat['icon_color'] as Color;

              return InkWell(
                onTap: () async {
                  final action = cat['is_special_action'] as String?;
                  if (action == 'all_categories') {
                    final auth = context.read<AuthProvider>();
                    if (!auth.isAuthenticated) {
                      final loggedIn = await AuthBottomSheet.show(context);
                      if (loggedIn != true && context.mounted && !context.read<AuthProvider>().isAuthenticated) return;
                    }
                    if (context.mounted) context.go('/categories');
                  } else if (action == 'post_ad') {
                    final auth = context.read<AuthProvider>();
                    if (!auth.isAuthenticated) {
                      final loggedIn = await AuthBottomSheet.show(context);
                      if (loggedIn != true && context.mounted && !context.read<AuthProvider>().isAuthenticated) return;
                    }
                    if (context.mounted) context.go('/post-ad');
                  } else {
                    final catId = cat['id'] as int;
                    context.push(
                      '/category-ads/$catId',
                      extra: {
                        'title': isAr ? (cat['name_ar'] as String).replaceAll('\n', ' ') : (cat['name'] as String).replaceAll('\n', ' '),
                      },
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isCommercial ? const Color(0xFFFDE047) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCommercial ? const Color(0xFFFACC15) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Red "New" badge for Commercial Ads (top right)
                      if (isCommercial)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'New',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),

                      // Card Content (Icon + Title centered)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: isCommercial
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    )
                                  : null,
                              clipBehavior: isCommercial ? Clip.antiAlias : Clip.none,
                              padding: isCommercial ? const EdgeInsets.all(4) : EdgeInsets.zero,
                              child: (cat['image'] != null && (cat['image'] as String).isNotEmpty)
                                  ? Image.asset(
                                      cat['image'] as String,
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isCommercial
                                              ? Colors.white.withValues(alpha: 0.4)
                                              : iconColor.withValues(alpha: 0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          cat['icon'] as IconData,
                                          color: isCommercial ? const Color(0xFF1E3A8A) : iconColor,
                                          size: 24,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isCommercial
                                            ? Colors.white.withValues(alpha: 0.4)
                                            : iconColor.withValues(alpha: 0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        cat['icon'] as IconData,
                                        color: isCommercial ? const Color(0xFF1E3A8A) : iconColor,
                                        size: 24,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 26,
                              child: Center(
                                child: Text(
                                  catName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isCommercial ? FontWeight.w900 : FontWeight.w700,
                                    color: isCommercial ? const Color(0xFF0F172A) : const Color(0xFF334155),
                                    height: 1.15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // "Find Newly Listed Items" Banner matching screenshot 2
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'اكتشف أحدث الإعلانات المضافة' : 'Find Newly Listed Items',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isAr
                            ? 'لا تفوّت أحدث الإعلانات في أقسامك المفضلة'
                            : "Don't miss fresh ads in your favorite categories",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => context.go('/listings'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isAr ? 'تصفح الآن' : 'Browse now',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isAr ? Icons.arrow_back : Icons.arrow_forward,
                              size: 14,
                              color: const Color(0xFF2563EB),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
