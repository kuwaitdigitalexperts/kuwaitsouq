import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';

class BoostAdScreen extends StatefulWidget {
  final int? adId;
  const BoostAdScreen({super.key, this.adId});

  @override
  State<BoostAdScreen> createState() => _BoostAdScreenState();
}

class _BoostAdScreenState extends State<BoostAdScreen> {
  int _selectedPlanIndex = 2; // Default to Featured Plan

  List<Map<String, dynamic>> _getPlans(bool isAr) => [
    {
      'title': isAr ? 'الباقة الأساسية' : 'Basic',
      'price': isAr ? '2.000 د.ك' : '2.000 KD',
      'days': isAr ? '3 أيام' : '3 Days',
      'multiplier': isAr ? 'مشاهدات 2x' : '2x Views',
      'badge': null,
      'features': isAr
          ? ['تمييز قياسي بلون بارز', 'الظهور في اقتراحات البحث']
          : ['Standard highlight', 'Appear in search suggestions'],
    },
    {
      'title': isAr ? 'الباقة المتقدمة' : 'Standard',
      'price': isAr ? '5.000 د.ك' : '5.000 KD',
      'days': isAr ? '7 أيام' : '7 Days',
      'multiplier': isAr ? 'مشاهدات 5x' : '5x Views',
      'badge': null,
      'features': isAr
          ? ['أعلى قائمة القسم', 'شارة تمييز زرقاء', 'أولوية دعم العملاء']
          : ['Top of Category listing', 'Blue badge highlight', 'Priority customer support'],
    },
    {
      'title': isAr ? 'الباقة المميزة' : 'Featured',
      'price': isAr ? '10.000 د.ك' : '10.000 KD',
      'days': isAr ? '15 يوماً' : '15 Days',
      'multiplier': isAr ? 'مشاهدات 10x' : '10x Views',
      'badge': isAr ? 'الأكثر طلباً' : 'MOST POPULAR',
      'features': isAr
          ? ['شريط الإعلانات الشائعة بالصفحة الرئيسية', 'أعلى القسم لمدة 15 يوماً', 'شارة الصاروخ المميز', 'تنبيهات للمشترين عبر الرسائل والواتساب']
          : ['Home Page Popular carousel', 'Top of Category for 15 days', 'Featured rocket badge', 'SMS & WhatsApp alert to buyers'],
    },
    {
      'title': isAr ? 'باقة VIP الذهبية' : 'Premium VIP',
      'price': isAr ? '20.000 د.ك' : '20.000 KD',
      'days': isAr ? '30 يوماً' : '30 Days',
      'multiplier': isAr ? 'مشاهدات 20x' : '20x Views',
      'badge': isAr ? 'أعلى نتائج' : 'MAX RESULTS',
      'features': isAr
          ? ['شارة VIP الذهبية على الإعلان', 'موقع ثابت في صدارة موجز الكويت', 'تحديث تلقائي كل 3 أيام', 'شارة عرض عاجل مشمولة مجاناً']
          : ['VIP Gold badge on ad', 'Fixed top spot in Kuwait feed', 'Auto-refresh every 3 days', 'Urgent Deal badge included'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final plans = _getPlans(isArabic);
    final selectedPlan = plans[_selectedPlanIndex];

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
          isArabic ? 'ترقية وتمييز الإعلان' : 'Boost Your Ad',
          style: const TextStyle(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'بيع أسرع 10 مرات في جميع مناطق الكويت' : 'Sell 10x Faster Across All Kuwait',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic
                              ? 'ميز إعلانك واجذب آلاف المشترين والاتصالات المباشرة فوراً عبر واتساب.'
                              : 'Highlight your listing and get thousands of direct inquiries via WhatsApp.',
                          style: const TextStyle(
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

            Text(
              isArabic ? 'اختر باقة التمييز' : 'Select Boost Plan',
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Plan Cards
            ...List.generate(plans.length, (index) {
              final plan = plans[index];
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
                        padding: const EdgeInsetsDirectional.only(start: 32),
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
                        padding: const EdgeInsetsDirectional.only(start: 32),
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
                            isArabic ? 'ملخص الطلب: باقة ${selectedPlan['title']}' : 'Order Summary: ${selectedPlan['title']} Plan',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic ? 'المبلغ الإجمالي: ${selectedPlan['price']}' : 'Total Amount: ${selectedPlan['price']}',
                            style: const TextStyle(fontSize: 16, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isArabic
                                ? 'الدفع الآمن الفوري عبر بوابة كي نت (KNET) أو البطاقات الائتمانية.'
                                : 'Instant secure payment via KNET or Credit/Debit Cards.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
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
                                  SnackBar(
                                    backgroundColor: const Color(0xFF059669),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      isArabic
                                          ? 'تم تفعيل تمييز الإعلان وترقيته بنجاح عبر بوابة الدفع (KNET)! 🚀'
                                          : 'Ad boosted successfully via KNET payment gateway! 🚀',
                                    ),
                                  ),
                                );
                                if (context.mounted) {
                                  Navigator.of(context).maybePop();
                                }
                              },
                              child: Text(
                                isArabic ? 'دفع فوري عبر كي نت / البطاقة 💳' : 'Pay with KNET / Card 💳',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  isArabic ? 'المتابعة للدفع (${selectedPlan['price']})' : 'Proceed to Payment (${selectedPlan['price']})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Payment Trust Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  isArabic
                      ? 'دفع إلكتروني آمن 100% · KNET, Apple Pay, Visa, MasterCard'
                      : '100% Secure Payment · KNET, Apple Pay, Visa, MasterCard',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
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
