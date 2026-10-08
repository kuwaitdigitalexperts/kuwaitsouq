import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../ads/widgets/ad_card.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsProvider>().fetchMyAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final myListings = adsProvider.myAds.isNotEmpty ? adsProvider.myAds : adsProvider.ads;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'إعلاناتي (Listings)',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        actions: [
          // Support Phone (+965)
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Color(0xFF2563EB)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الاتصال بالدعم الفني: ${AppConstants.supportPhone}')),
              );
            },
          ),
          // Notification Bell
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 4-Card Summary Grid (Screenshot 12)
            Row(
              children: [
                // Card 1: My Listings
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.article_outlined, color: Color(0xFF2563EB), size: 24),
                        const SizedBox(height: 10),
                        Text(
                          '${myListings.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'إعلاناتي',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Card 2: Views
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.visibility_outlined, color: Color(0xFF0D9488), size: 24),
                        SizedBox(height: 10),
                        Text(
                          '1,280',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'المشاهدات',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                // Card 3: Add New Listing (+ Camera CTA)
                Expanded(
                  child: InkWell(
                    onTap: () => context.push('/post-ad'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.add_a_photo, color: Color(0xFFF59E0B), size: 24),
                              Icon(Icons.add, color: Color(0xFFF59E0B), size: 20),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '+',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'أضف إعلان جديد',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Card 4: Rating
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.star, color: Color(0xFFF59E0B), size: 24),
                        SizedBox(height: 10),
                        Text(
                          '5.0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'التقييم العام',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Menu List matching Screenshot 12
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.article_outlined,
                    iconColor: const Color(0xFF2563EB),
                    title: 'إعلاناتي النشطة',
                    trailing: '${myListings.length}',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.favorite_border,
                    iconColor: const Color(0xFFE11D48),
                    title: 'الإعلانات المفضلة',
                    trailing: '12',
                    onTap: () => context.push('/saved'),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.drafts_outlined,
                    iconColor: const Color(0xFF64748B),
                    title: 'المسودات المحفوظة',
                    trailing: '0',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.notifications_active_outlined,
                    iconColor: const Color(0xFF0D9488),
                    title: 'تنبيهات البحث المحفوظة',
                    trailing: '3',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.rocket_launch_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'الإعلانات المميزة والترويج',
                    trailing: '🚀',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Active Listings Feed
            const Text(
              'الإعلانات المسجلة',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myListings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return AdCard(ad: myListings[index]);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.bold,
          color: AppTheme.textDark,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
        ],
      ),
      onTap: onTap,
    );
  }
}
