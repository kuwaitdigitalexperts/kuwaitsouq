import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_theme.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'slug': 'autos',
      'name': 'Autos',
      'name_ar': 'سيارات ومركبات',
      'icon': Icons.directions_car,
      'color': Color(0xFF2563EB),
      'count': '1,420',
    },
    {
      'id': 9,
      'slug': 'real-estate',
      'name': 'Real Estate',
      'name_ar': 'عقارات',
      'icon': Icons.apartment,
      'color': Color(0xFF0D9488),
      'count': '850',
    },
    {
      'id': 10,
      'slug': 'electronics',
      'name': 'Electronics',
      'name_ar': 'إلكترونيات',
      'icon': Icons.smartphone,
      'color': Color(0xFF8B5CF6),
      'count': '620',
    },
    {
      'id': 11,
      'slug': 'jobs',
      'name': 'Jobs',
      'name_ar': 'وظائف',
      'icon': Icons.work_outline,
      'color': Color(0xFFF59E0B),
      'count': '310',
    },
    {
      'id': 12,
      'slug': 'services',
      'name': 'Services',
      'name_ar': 'خدمات',
      'icon': Icons.handyman_outlined,
      'color': Color(0xFFEF4444),
      'count': '450',
    },
    {
      'id': 8,
      'slug': 'quad-bikes-buggies-atv',
      'name': 'Bikes & ATV',
      'name_ar': 'دبابات وسكوترات',
      'icon': Icons.two_wheeler,
      'color': Color(0xFF06B6D4),
      'count': '190',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تصفح الأقسام الرئيسية',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              InkWell(
                onTap: () => context.go('/categories'),
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2-Column Grid (matching Screenshot 1)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.3,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final Color catColor = cat['color'] as Color;

              return InkWell(
                onTap: () => context.push('/categories/${cat['slug']}'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(cat['icon'] as IconData, color: catColor, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cat['name_ar'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${cat['count']} إعلان',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF94A3B8),
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
        ],
      ),
    );
  }
}
