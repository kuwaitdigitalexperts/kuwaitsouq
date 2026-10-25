import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/auth_bottom_sheet.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../../ads/widgets/ad_card.dart';

class CategoriesScreen extends StatefulWidget {
  final String? categorySlug;

  const CategoriesScreen({super.key, this.categorySlug});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategorySlug = 'autos';
  String? _selectedMake;
  bool _saveSearchAlert = true;

  static const List<Map<String, dynamic>> _categoriesList = [
    {'id': 13, 'slug': 'commercial-ads', 'name': 'Commercial Ads', 'name_ar': 'إعلانات تجارية', 'icon': Icons.campaign, 'count': 420},
    {'id': 14, 'slug': 'shops', 'name': 'Shops', 'name_ar': 'محلات ومتاجر', 'icon': Icons.storefront, 'count': 260},
    {'id': 1, 'slug': 'autos', 'name': 'Autos', 'name_ar': 'سيارات', 'icon': Icons.directions_car, 'count': 1420},
    {'id': 15, 'slug': 'motorcycles', 'name': 'Motorcycles', 'name_ar': 'دراجات نارية', 'icon': Icons.two_wheeler, 'count': 180},
    {'id': 9, 'slug': 'property-for-sale', 'name': 'Property For Sale', 'name_ar': 'عقارات للبيع', 'icon': Icons.apartment, 'count': 850},
    {'id': 16, 'slug': 'property-for-rent', 'name': 'Property For Rent', 'name_ar': 'عقارات للإيجار', 'icon': Icons.home_work_outlined, 'count': 920},
    {'id': 11, 'slug': 'jobs', 'name': 'Jobs', 'name_ar': 'وظائف', 'icon': Icons.work_outline, 'count': 310},
    {'id': 12, 'slug': 'services', 'name': 'Services', 'name_ar': 'خدمات', 'icon': Icons.construction, 'count': 450},
    {'id': 17, 'slug': 'phones-tablets', 'name': 'Phones & Tablets', 'name_ar': 'هواتف وأجهزة', 'icon': Icons.phone_iphone, 'count': 780},
    {'id': 18, 'slug': 'computers-laptops', 'name': 'Computers & Laptops', 'name_ar': 'كمبيوتر ولابتوب', 'icon': Icons.laptop_mac, 'count': 340},
    {'id': 19, 'slug': 'gaming-toys', 'name': 'Gaming & Toys', 'name_ar': 'ألعاب فيديو', 'icon': Icons.sports_esports, 'count': 290},
    {'id': 20, 'slug': 'sports-fitness', 'name': 'Sports & Fitness', 'name_ar': 'رياضة ولياقة', 'icon': Icons.fitness_center, 'count': 210},
    {'id': 10, 'slug': 'electronics', 'name': 'Electronics', 'name_ar': 'إلكترونيات', 'icon': Icons.tv, 'count': 620},
    {'id': 21, 'slug': 'household-appliances', 'name': 'Household Appliances', 'name_ar': 'أجهزة منزلية', 'icon': Icons.kitchen, 'count': 390},
    {'id': 22, 'slug': 'home-garden', 'name': 'Home & Garden', 'name_ar': 'المنزل والحديقة', 'icon': Icons.chair_outlined, 'count': 510},
    {'id': 23, 'slug': 'fashion-kids', 'name': 'Fashion & Kids', 'name_ar': 'أزياء وأطفال', 'icon': Icons.checkroom, 'count': 670},
    {'id': 24, 'slug': 'pets-accessories', 'name': 'Pets & Accessories', 'name_ar': 'حيوانات وأليفة', 'icon': Icons.pets, 'count': 240},
    {'id': 25, 'slug': 'leisure-collectibles', 'name': 'Leisure & Collectibles', 'name_ar': 'مقتنيات وتخييم', 'icon': Icons.terrain_outlined, 'count': 190},
    {'id': 26, 'slug': 'food', 'name': 'Food', 'name_ar': 'أطعمة ومأكولات', 'icon': Icons.lunch_dining, 'count': 320},
    {'id': 27, 'slug': 'beauty-health', 'name': 'Beauty & Health', 'name_ar': 'صحة وجمال', 'icon': Icons.spa, 'count': 410},
    {'id': 28, 'slug': 'businesses-equipment', 'name': 'Businesses & Equipment', 'name_ar': 'معدات ومشاريع', 'icon': Icons.warehouse_outlined, 'count': 150},
    {'id': 29, 'slug': 'education-training', 'name': 'Education & Training', 'name_ar': 'تعليم وتدريب', 'icon': Icons.school, 'count': 130},
    {'id': 30, 'slug': 'job-seekers', 'name': 'Job Seekers', 'name_ar': 'باحثون عن عمل', 'icon': Icons.assignment_ind_outlined, 'count': 280},
    {'id': 31, 'slug': 'reviews-ratings', 'name': 'Reviews & Ratings', 'name_ar': 'تقييمات ومراجعات', 'icon': Icons.rate_review_outlined, 'count': 95},
  ];

  static const List<Map<String, dynamic>> _subcategories = [
    {'name': 'سيارات للبيع', 'name_en': 'Cars for Sale', 'icon': Icons.directions_car, 'count': 1050},
    {'name': 'إكسسوارات وقطع غيار', 'name_en': 'Auto Parts', 'icon': Icons.settings_outlined, 'count': 320},
    {'name': 'سيارات للإيجار', 'name_en': 'Cars for Rent', 'icon': Icons.key_outlined, 'count': 95},
    {'name': 'آليات ومعدات ثقيلة', 'name_en': 'Heavy Machinery', 'icon': Icons.precision_manufacturing_outlined, 'count': 42},
    {'name': 'لوحات مميزة', 'name_en': 'Special Plates', 'icon': Icons.credit_card_outlined, 'count': 78},
    {'name': 'دبابات وسكوترات', 'name_en': 'Bikes & ATV', 'icon': Icons.two_wheeler, 'count': 65},
  ];

  static const List<Map<String, dynamic>> _carBrands = [
    {'key': 'toyota', 'name': 'تويوتا', 'name_en': 'Toyota', 'icon': Icons.directions_car, 'color': Colors.red},
    {'key': 'nissan', 'name': 'نيسان', 'name_en': 'Nissan', 'icon': Icons.directions_car, 'color': Colors.blueGrey},
    {'key': 'lexus', 'name': 'لكزس', 'name_en': 'Lexus', 'icon': Icons.directions_car, 'color': Colors.black87},
    {'key': 'ford', 'name': 'فورد', 'name_en': 'Ford', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'key': 'mercedes', 'name': 'مرسيدس', 'name_en': 'Mercedes', 'icon': Icons.directions_car, 'color': Colors.blueGrey},
    {'key': 'bmw', 'name': 'بي إم دبليو', 'name_en': 'BMW', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'key': 'chevrolet', 'name': 'شفروليه', 'name_en': 'Chevrolet', 'icon': Icons.directions_car, 'color': Colors.amber},
    {'key': 'hyundai', 'name': 'هيونداي', 'name_en': 'Hyundai', 'icon': Icons.directions_car, 'color': Colors.indigo},
    {'key': 'landrover', 'name': 'لاند روفر', 'name_en': 'Land Rover', 'icon': Icons.directions_car, 'color': Colors.green},
    {'key': 'porsche', 'name': 'بورش', 'name_en': 'Porsche', 'icon': Icons.directions_car, 'color': Colors.deepOrange},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.categorySlug != null && widget.categorySlug!.isNotEmpty) {
      _selectedCategorySlug = widget.categorySlug!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (!auth.isAuthenticated) {
        AuthBottomSheet.show(context);
      }
      context.read<AdsProvider>().fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final ads = adsProvider.ads;
    final isAr = context.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        leading: const AppBackButton(color: Colors.white, fallbackRoute: '/'),
        title: Text(context.tr('categories_title')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Horizontal Category Tabs
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoriesList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categoriesList[index];
                    final isSelected = cat['slug'] == _selectedCategorySlug;
                    final catName = isAr ? (cat['name_ar'] as String) : (cat['name'] as String);

                    final slugImg = (cat['slug'] as String? ?? '').replaceAll('-', '_');

                    return ChoiceChip(
                      avatar: Image.asset(
                        'assets/images/categories/$slugImg.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          cat['icon'] as IconData? ?? Icons.category_outlined,
                          size: 16,
                          color: isSelected ? Colors.white : const Color(0xFF2563EB),
                        ),
                      ),
                      label: Text(
                        catName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppTheme.textDark,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2563EB),
                      backgroundColor: const Color(0xFFF1F5F9),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategorySlug = cat['slug'] as String;
                          _selectedMake = null;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // Subcategories Grid
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('subcategories_title'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subcategories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.4,
                    ),
                    itemBuilder: (context, index) {
                      final sub = _subcategories[index];
                      final subName = isAr ? (sub['name'] as String) : (sub['name_en'] as String);

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(sub['icon'] as IconData, size: 16, color: const Color(0xFF2563EB)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    subName,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${sub['count']} ${context.tr('ads_count_suffix')}',
                                    style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Save Search Toggle Card (Screenshot 2)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark_border, color: Color(0xFFE11D48), size: 24),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('save_search'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            context.tr('save_search_desc'),
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _saveSearchAlert,
                    activeColor: const Color(0xFF2563EB),
                    onChanged: (val) {
                      setState(() => _saveSearchAlert = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(val ? (isAr ? 'تم تفعيل تنبيهات البحث' : 'Search alerts enabled') : (isAr ? 'تم إيقاف تنبيهات البحث' : 'Search alerts disabled'))),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Visual Brand / Car Make Logo Grid (Screenshot 2)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('filter_car_make'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        context.tr('global_brands'),
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 82,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _carBrands.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final b = _carBrands[index];
                        final isSelected = _selectedMake == b['key'];
                        final brandName = isAr ? (b['name'] as String) : (b['name_en'] as String);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMake = isSelected ? null : b['key'] as String;
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: 74,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  b['icon'] as IconData,
                                  color: b['color'] as Color,
                                  size: 24,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  brandName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                                    color: isSelected ? const Color(0xFF2563EB) : AppTheme.textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Listings in Category
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Text(
                '${context.tr('category_results')} (${ads.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdCard(ad: ads[index]),
                  );
                },
                childCount: ads.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
