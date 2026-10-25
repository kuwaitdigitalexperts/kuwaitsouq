import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/auth_bottom_sheet.dart';
import 'story_viewer_modal.dart';

class StoriesCarousel extends StatelessWidget {
  const StoriesCarousel({super.key});

  static const List<Map<String, dynamic>> stories = [
    {
      'name': 'الغانم للسيارات',
      'subtitle': 'Al Ghanim Automotive',
      'avatar': 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
      'image': 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=900',
      'title': 'تويوتا لاندكروزر 2024 VXR بحالة الوكالة - عداد 5,000 كم',
      'title_en': 'Toyota Land Cruiser 2024 VXR - 5,000 km Only',
      'price': '24,500 د.ك',
      'time': 'منذ ساعة',
      'time_en': '1 hour ago',
      'ad_id': 1,
      'phone': '+965 99001122',
      'color': Color(0xFF2563EB),
    },
    {
      'name': 'أبو فهد',
      'subtitle': 'Abu Fahad',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=900',
      'title': 'فيلا فاخرة للبيع في صباح الأحمد البحرية صف أول على الخور',
      'title_en': 'Luxury Seafront Villa in Sabah Al Ahmad Sea City',
      'price': '380,000 د.ك',
      'time': 'منذ ساعتين',
      'time_en': '2 hours ago',
      'ad_id': 2,
      'phone': '+965 98765432',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'كويت موتورز',
      'subtitle': 'Kuwait Motors',
      'avatar': 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=150',
      'image': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900',
      'title': 'بورش 911 GT3 موديل 2023 وكالة بهبهاني سيرفيس منتظم',
      'title_en': 'Porsche 911 GT3 2023 Behbehani Agency Kuwait',
      'price': '62,000 د.ك',
      'time': 'منذ 3 ساعات',
      'time_en': '3 hours ago',
      'ad_id': 3,
      'phone': '+965 97771122',
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'عقارات حولي',
      'subtitle': 'Hawally Estates',
      'avatar': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=150',
      'image': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900',
      'title': 'شقة ديلوكس للإيجار إطلالة بحرية 3 غرف وصالة وموقفين',
      'title_en': 'Deluxe Sea View 3-Bedroom Apartment in Hawally',
      'price': '650 د.ك / شهر',
      'time': 'منذ 5 ساعات',
      'time_en': '5 hours ago',
      'ad_id': 4,
      'phone': '+965 94443322',
      'color': Color(0xFF8B5CF6),
    },
    {
      'name': 'سكوتر شوب',
      'subtitle': 'Scooter Shop',
      'avatar': 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=150',
      'image': 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=900',
      'title': 'دراجة نارية رياضية ياماها R1 بحالة الوكالة فحص شامل',
      'title_en': 'Yamaha R1 Sport Bike Excellent Condition Inspection Ready',
      'price': '3,200 د.ك',
      'time': 'منذ 6 ساعات',
      'time_en': '6 hours ago',
      'ad_id': 5,
      'phone': '+965 92224455',
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 92,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          scrollDirection: Axis.horizontal,
          itemCount: stories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            if (index == 0) {
              // Add Story CTA with camera icon
              return InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  final auth = context.read<AuthProvider>();
                  if (!auth.isAuthenticated) {
                    final loggedIn = await AuthBottomSheet.show(context);
                    if (loggedIn != true && context.mounted && !context.read<AuthProvider>().isAuthenticated) {
                      return;
                    }
                  }
                  if (context.mounted) {
                    context.push('/post-ad');
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFEF3C7),
                            border: Border.all(
                              color: const Color(0xFFF59E0B),
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFFD97706),
                            size: 26,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.tr('your_story'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              );
            }

            final story = stories[index - 1];
            final Color ringColor = story['color'] as Color;
            final storyName = isAr
                ? (story['name'] as String)
                : (story['subtitle'] as String? ?? story['name'] as String);

            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                StoryViewerModal.show(
                  context,
                  stories: stories,
                  initialIndex: index - 1,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [ringColor, ringColor.withOpacity(0.5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(story['avatar'] as String),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    storyName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
