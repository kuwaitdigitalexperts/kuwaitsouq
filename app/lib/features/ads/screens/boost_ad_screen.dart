import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../shared/theme/app_theme.dart';

class BoostAdScreen extends StatefulWidget {
  final int? adId;
  const BoostAdScreen({super.key, this.adId});

  @override
  State<BoostAdScreen> createState() => _BoostAdScreenState();
}

class _BoostAdScreenState extends State<BoostAdScreen> {
  int _selectedPlanIndex = 2; // Default to Featured Plan

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Basic',
      'price': '2.000 د.ك',
      'days': '3 Days',
      'multiplier': '2x Views',
      'badge': null,
      'features': ['Standard highlight', 'Appear in search suggestions'],
    },
    {
      'title': 'Standard',
      'price': '5.000 د.ك',
      'days': '7 Days',
      'multiplier': '5x Views',
      'badge': null,
      'features': ['Top of Category listing', 'Blue badge highlight', 'Priority customer support'],
    },
    {
      'title': 'Featured',
      'price': '10.000 د.ك',
      'days': '15 Days',
      'multiplier': '10x Views',
      'badge': 'MOST POPULAR',
      'features': ['Home Page Popular carousel', 'Top of Category for 15 days', 'Featured rocket badge', 'SMS & WhatsApp alert to buyers'],
    },
    {
      'title': 'Premium VIP',
      'price': '20.000 د.ك',
      'days': '30 Days',
      'multiplier': '20x Views',
      'badge': 'MAX RESULTS',
      'features': ['VIP Gold badge on ad', 'Fixed top spot in Kuwait feed', 'Auto-refresh every 3 days', 'Urgent Deal badge included'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedPlan = _plans[_selectedPlanIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Boost Your Ad',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بيع أسرع 10 مرات في الكويت والخليج',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ميز إعلانك واجذب آلاف المشترين والاتصالات المباشرة فوراً عبر واتساب.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.rocket_launch, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Select Boost Plan',
              style: TextStyle(
                color: AppTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Plan Cards
            ...List.generate(_plans.length, (index) {
              final plan = _plans[index];
              final isSelected = _selectedPlanIndex == index;
              final isPopular = plan['badge'] != null;

              return InkWell(
                onTap: () => setState(() => _selectedPlanIndex = index),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSelected ? AppTheme.primaryGreen : AppTheme.textMuted,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            plan['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          if (plan['badge'] != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: isPopular ? AppTheme.accentOrange : AppTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                plan['badge'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            plan['price'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.tagBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${plan['days']} · ${plan['multiplier']}',
                                style: const TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (plan['features'] as List<String>).map((feat) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                children: [
                                  const Icon(Icons.check, size: 14, color: AppTheme.primaryGreen),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      feat,
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Order Summary: ${selectedPlan['title']} Plan',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Total Amount: ${selectedPlan['price']}',
                            style: const TextStyle(fontSize: 16, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'الدفع الآمن الفوري عبر بوابة كي نت (KNET) أو البطاقات الائتمانية.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () async {
                                if (widget.adId != null) {
                                  await context.read<AdsProvider>().boostAd(widget.adId!);
                                }
                                if (!ctx.mounted) return;
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xFF059669),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('تم تفعيل تمييز الإعلان وترقيته بنجاح عبر بوابة الدفع (KNET)! 🚀'),
                                  ),
                                );
                                if (context.mounted) {
                                  Navigator.of(context).maybePop();
                                }
                              },
                              child: const Text('دفع فوري عبر كي نت / البطاقة 💳', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  'المتابعة للدفع (${selectedPlan['price']})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Payment Trust Badges
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 14, color: AppTheme.textMuted),
                SizedBox(width: 4),
                Text(
                  'دفع إلكتروني آمن 100% · KNET, Apple Pay, Visa, MasterCard',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
