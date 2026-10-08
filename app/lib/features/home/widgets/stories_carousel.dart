import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_theme.dart';

class StoriesCarousel extends StatelessWidget {
  const StoriesCarousel({super.key});

  static const List<Map<String, dynamic>> stories = [
    {
      'name': 'الغانم',
      'subtitle': 'Al Ghanim',
      'avatar': 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
      'color': Color(0xFF2563EB),
    },
    {
      'name': 'أبو فهد',
      'subtitle': 'سيارات',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'كويت موتورز',
      'subtitle': 'Kuwait Motors',
      'avatar': 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=150',
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'عقارات حولي',
      'subtitle': 'Real Estate',
      'avatar': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=150',
      'color': Color(0xFF8B5CF6),
    },
    {
      'name': 'سكوتر شوب',
      'subtitle': 'Scooters',
      'avatar': 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=150',
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              // Add Story CTA with camera icon (Screenshot 1)
              return InkWell(
                onTap: () => context.push('/post-ad'),
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
                    const Text(
                      'قصتك',
                      style: TextStyle(
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

            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('عرض قصة ${story['name']}')),
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
                    story['name'] as String,
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
