import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../shared/theme/app_theme.dart';
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
    {'slug': 'autos', 'name_ar': 'سيارات ومركبات', 'icon': Icons.directions_car, 'count': 1420},
    {'slug': 'real-estate', 'name_ar': 'عقارات', 'icon': Icons.apartment, 'count': 850},
    {'slug': 'electronics', 'name_ar': 'إلكترونيات', 'icon': Icons.smartphone, 'count': 620},
    {'slug': 'jobs', 'name_ar': 'وظائف', 'icon': Icons.work_outline, 'count': 310},
    {'slug': 'services', 'name_ar': 'خدمات', 'icon': Icons.handyman_outlined, 'count': 450},
  ];

  static const List<Map<String, dynamic>> _subcategories = [
    {'name': 'سيارات للبيع', 'icon': Icons.directions_car, 'count': 1050},
    {'name': 'إكسسوارات وقطع غيار', 'icon': Icons.settings_outlined, 'count': 320},
    {'name': 'سيارات للإيجار', 'icon': Icons.key_outlined, 'count': 95},
    {'name': 'آليات ومعدات ثقيلة', 'icon': Icons.precision_manufacturing_outlined, 'count': 42},
    {'name': 'لوحات مميزة', 'icon': Icons.credit_card_outlined, 'count': 78},
    {'name': 'دبابات وسكوترات', 'icon': Icons.two_wheeler, 'count': 65},
  ];

  static const List<Map<String, dynamic>> _carBrands = [
    {'key': 'toyota', 'name': 'تويوتا', 'icon': Icons.directions_car, 'color': Colors.red},
    {'key': 'nissan', 'name': 'نيسان', 'icon': Icons.directions_car, 'color': Colors.blueGrey},
    {'key': 'lexus', 'name': 'لكزس', 'icon': Icons.directions_car, 'color': Colors.black87},
    {'key': 'ford', 'name': 'فورد', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'key': 'mercedes', 'name': 'مرسيدس', 'icon': Icons.directions_car, 'color': Colors.blueGrey},
    {'key': 'bmw', 'name': 'بي إم دبليو', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'key': 'chevrolet', 'name': 'شفروليه', 'icon': Icons.directions_car, 'color': Colors.amber},
    {'key': 'hyundai', 'name': 'هيونداي', 'icon': Icons.directions_car, 'color': Colors.indigo},
    {'key': 'landrover', 'name': 'لاند روفر', 'icon': Icons.directions_car, 'color': Colors.green},
    {'key': 'porsche', 'name': 'بورش', 'icon': Icons.directions_car, 'color': Colors.deepOrange},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.categorySlug != null && widget.categorySlug!.isNotEmpty) {
      _selectedCategorySlug = widget.categorySlug!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsProvider>().fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final ads = adsProvider.ads;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        title: const Text('الأقسام والتصنيفات'),
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

                    return ChoiceChip(
                      label: Text(
                        cat['name_ar'] as String,
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
                  const Text(
                    'التصنيفات الفرعية',
                    style: TextStyle(
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
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Icon(sub['icon'] as IconData, size: 20, color: const Color(0xFF2563EB)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    sub['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${sub['count']} إعلان',
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
                  const Row(
                    children: [
                      Icon(Icons.bookmark_border, color: Color(0xFFE11D48), size: 24),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حفظ البحث (Save Search)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            'تنبيهي عند إضافة إعلانات جديدة في هذا القسم',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                        SnackBar(content: Text(val ? 'تم تفعيل تنبيهات البحث' : 'تم إيقاف تنبيهات البحث')),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تصفية سريعة بالماركة (Car Make)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        'الشركات العالمية',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                                  b['name'] as String,
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
                'نتائج البحث في الأقسام (${ads.length})',
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
