import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class AdDetailScreen extends StatefulWidget {
  final int id;
  const AdDetailScreen({super.key, required this.id});

  @override
  State<AdDetailScreen> createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  int _currentImageIndex = 0;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsProvider>().fetchAd(widget.id);
    });
  }

  void _showCarFaxModal(BuildContext context, String? adTitle) {
    final vinCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          bool isSubmitting = false;

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.car_crash, color: Color(0xFFD97706), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'تقرير كارفكس لهذه المركبة 🚗',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              adTitle != null ? 'فحص: $adTitle' : 'فحص السجل التاريخي والحوادث السابقة',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: vinCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'رقم الشاصي / الهيكل (VIN)',
                      hintText: 'إذا لم يتوفر، اترك فارغاً وسنتحقق من المعلن',
                      prefixIcon: const Icon(Icons.pin, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'رقم هاتفك لاستلام تقرير كارفكس',
                      prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final phone = phoneCtrl.text.trim();
                            if (phone.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('يرجى إدخال رقم هاتفك لاستلام التقرير')),
                              );
                              return;
                            }
                            setModalState(() => isSubmitting = true);
                            final res = await context.read<AdsProvider>().requestCarFax(
                              vinCtrl.text.trim(),
                              phone: phone,
                              adId: widget.id,
                            );
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xFF0F172A),
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  res['message'] ?? 'تم تسجيل طلب فحص كارفكس! سيصلك التقرير عبر الواتساب فور اكتماله.',
                                ),
                              ),
                            );
                          },
                    child: const Text('طلب تقرير كارفكس الشامل 📄', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdsProvider>();
    final ad = provider.currentAd;

    if (ad == null && provider.loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
      );
    }

    final currency = ad?.currency.isNotEmpty == true ? ad!.currency : 'د.ك';
    final priceStr = ad != null
        ? '${ad.price.toStringAsFixed(ad.price.truncateToDouble() == ad.price ? 0 : 2)} $currency'
        : '0 د.ك';
    final images = ad?.images ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top Media Slider
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Carousel View
                      if (images.isNotEmpty)
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _currentImageIndex = i),
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Center(
                                child: Icon(Icons.image, size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        )
                      else
                        Container(
                          color: const Color(0xFF0F172A),
                          child: const Center(
                            child: Icon(Icons.image_outlined, size: 60, color: Colors.white54),
                          ),
                        ),

                      // Gradient overlay for back button readability
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Top Navigation Bar Icons (Back, Favorite, Share)
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.85),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                                    child: IconButton(
                                      icon: Icon(
                                        provider.isFavorite(widget.id) ? Icons.favorite : Icons.favorite_border,
                                        color: provider.isFavorite(widget.id) ? const Color(0xFFE11D48) : AppTheme.textDark,
                                      ),
                                      onPressed: () async {
                                        final nowFav = await provider.toggleFavorite(widget.id);
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: const Color(0xFF1E293B),
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(nowFav ? 'تمت إضافة الإعلان إلى المفضلة ❤️' : 'تمت إزالة الإعلان من المفضلة'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Colors.white.withOpacity(0.85),
                                    child: IconButton(
                                      icon: const Icon(Icons.share_outlined, color: AppTheme.textDark),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('تم نسخ رابط الإعلان')),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Media Count Badges [📷 17] [📹 1] (Screenshot 4)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${images.length > 0 ? images.length : 1}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            if (ad?.hasVideo == true) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.videocam, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Dots Indicator
                      if (images.length > 1)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1} / ${images.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Ad Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Price Drop Alert Chip (Screenshot 4)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_down, color: Color(0xFF2563EB), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'تنبيه بانخفاض السعر: وفر مع هذا العرض',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Price (Bold RED)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            priceStr,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE11D48),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'قابل للتفاوض',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Title
                      Text(
                        ad?.title ?? 'إعلان في سوق الكويت',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Location & Date
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Color(0xFFE11D48)),
                          const SizedBox(width: 4),
                          Text(
                            ad?.locationName.isNotEmpty == true ? ad!.locationName : 'الكويت',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          const Text('•', style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time, size: 14, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          const Text('منذ ساعتين', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Key Specifications Table (Screenshot 4)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'المواصفات والتفاصيل',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 12),
                            _buildSpecRow('الحالة', ad?.condition == 'new' ? 'جديد بالكرتون' : 'مستعمل بحالة ممتازة'),
                            _buildSpecRow('القسم', ad?.categoryName.isNotEmpty == true ? ad!.categoryName : 'سيارات ودبابات'),
                            _buildSpecRow('سنة الصنع', '2023'),
                            _buildSpecRow('المدينة', ad?.locationName ?? 'الكويت'),
                            _buildSpecRow('طريقة الدفع', 'كاش أو تحويل بنكي'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // CarFax Vehicle Check Banner
                      InkWell(
                        onTap: () => _showCarFaxModal(context, ad?.title),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFCD34D)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.car_crash, color: Color(0xFFD97706), size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'فحص كارفكس للمركبة (CarFax Vehicle Report)',
                                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                                    ),
                                    Text(
                                      'تحقق من تاريخ الصيانة والحوادث السابقة لهذه المركبة',
                                      style: TextStyle(fontSize: 10.5, color: Color(0xFF92400E)),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF78350F)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // "Ask the Lister" Prompt Chips (Screenshot 5)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.chat_outlined, color: Color(0xFF2563EB), size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'اسأل المعلن بنقرة واحدة (Quick Questions)',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildChip('هل السلعة متوفرة؟', ad?.userId),
                                _buildChip('ما هو السعر النهائي؟', ad?.userId),
                                _buildChip('هل تقبل البدل؟', ad?.userId),
                                _buildChip('أين موقع المعاينة؟', ad?.userId),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الوصف',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ad?.description.isNotEmpty == true
                                  ? ad!.description
                                  : 'حالة ممتازة جداً، استعمال خفيف، جاهز للمعاينة والتسليم الفوري في الكويت. تواصل عبر الواتساب أو الاتصال للمزيد من التفاصيل.',
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF334155),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Seller Rating Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBEF264),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Text('الغانم', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'شركة الغانم العالمية',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.verified, color: Color(0xFF2563EB), size: 16),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'عضو موثق • تقييم 4.9 من 5',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Safety Tips
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 22),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'نصيحة أمان: عاين السلعة وتأكد منها بنفسك قبل تحويل أي مبالغ مالية.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 90), // Bottom bar spacer
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar: Call + WhatsApp (Screenshot 4 & 5)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Call Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text('اتصال بالمعلن', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final phone = ad?.phone?.isNotEmpty == true
                            ? ad!.phone!
                            : (ad?.whatsapp?.isNotEmpty == true ? ad!.whatsapp! : '+965 99001122');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF1E293B),
                            behavior: SnackBarBehavior.floating,
                            content: Text('الاتصال برقم المعلن: $phone'),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // WhatsApp Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('محادثة واتساب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final phone = ad?.whatsapp?.isNotEmpty == true
                            ? ad!.whatsapp!
                            : (ad?.phone?.isNotEmpty == true ? ad!.phone! : '+965 99001122');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF065F46),
                            behavior: SnackBarBehavior.floating,
                            content: Text('فتح محادثة واتساب مع المعلن: $phone'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildChip(String text, int? sellerId) {
    return InkWell(
      onTap: () {
        if (sellerId != null) {
          context.push('/chat/$sellerId', extra: {'initialMessage': text, 'adId': widget.id});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1E293B),
              behavior: SnackBarBehavior.floating,
              content: Text('تم إرسال السؤال: "$text"'),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
