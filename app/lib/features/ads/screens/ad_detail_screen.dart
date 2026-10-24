import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
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
      builder: (ctx) {
        bool isSubmitting = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) {

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
                            Text(
                              context.tr('carfax_title'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              adTitle != null 
                                  ? '${context.isArabic ? "فحص: " : "Inspect: "}$adTitle'
                                  : context.tr('carfax_sub'),
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
                      labelText: context.isArabic ? 'رقم الشاصي / الهيكل (VIN)' : 'VIN / Chassis Number',
                      hintText: context.isArabic ? 'إذا لم يتوفر، اترك فارغاً وسنتحقق من المعلن' : 'Optional: leave blank to request from seller',
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
                      labelText: context.isArabic ? 'رقم هاتفك لاستلام تقرير كارفكس' : 'Phone Number for WhatsApp Report',
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
                                SnackBar(content: Text(context.isArabic ? 'يرجى إدخال رقم هاتفك لاستلام التقرير' : 'Please enter your phone number')),
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
                                  res['message'] ?? (context.isArabic 
                                      ? 'تم تسجيل طلب فحص كارفكس! سيصلك التقرير عبر الواتساب فور اكتماله.' 
                                      : 'CarFax request submitted! You will receive the report via WhatsApp.'),
                                ),
                              ),
                            );
                          },
                    child: Text(context.isArabic ? 'طلب تقرير كارفكس الشامل 📄' : 'Request Full Inspection Report 📄', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdsProvider>();
    final isAr = context.isArabic;
    final ad = provider.currentAd;

    if (ad == null && provider.loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
      );
    }

    final currency = ad != null ? ad.localizedCurrency(isAr) : (isAr ? 'د.ك' : 'KD');
    final priceStr = ad != null
        ? '${ad.price.toStringAsFixed(ad.price.truncateToDouble() == ad.price ? 0 : 2)} $currency'
        : (isAr ? '0 د.ك' : '0 KD');
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
                                            content: Text(nowFav ? context.tr('added_to_favorites') : context.tr('removed_from_favorites')),
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
                                          SnackBar(content: Text(context.tr('ad_link_copied'))),
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
                        child: Row(
                          children: [
                            const Icon(Icons.trending_down, color: Color(0xFF2563EB), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              context.tr('price_drop_alert'),
                              style: const TextStyle(
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
                            child: Text(
                              isAr ? 'قابل للتفاوض' : 'Negotiable',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Title
                      Text(
                        ad != null ? ad.localizedTitle(isAr) : (isAr ? 'إعلان في سوق الكويت' : 'KuwaitSouq Listing'),
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
                            ad != null ? ad.localizedLocation(isAr) : (isAr ? 'الكويت' : 'Kuwait'),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          const Text('•', style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time, size: 14, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(isAr ? 'منذ ساعتين' : '2 hours ago', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
                            Text(
                              context.tr('specifications'),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 12),
                            _buildSpecRow(
                              isAr ? 'الحالة' : 'Condition',
                              ad?.condition == 'new' 
                                  ? (isAr ? 'جديد بالكرتون' : 'Brand New') 
                                  : (isAr ? 'مستعمل بحالة ممتازة' : 'Used - Excellent Condition'),
                            ),
                            _buildSpecRow(
                              isAr ? 'القسم' : 'Category',
                              ad != null ? ad.localizedCategory(isAr) : (isAr ? 'سيارات ودبابات' : 'Vehicles'),
                            ),
                            _buildSpecRow(isAr ? 'سنة الصنع' : 'Year', '2023'),
                            _buildSpecRow(
                              isAr ? 'المدينة' : 'City',
                              ad != null ? ad.localizedLocation(isAr) : (isAr ? 'الكويت' : 'Kuwait'),
                            ),
                            _buildSpecRow(
                              isAr ? 'طريقة الدفع' : 'Payment',
                              isAr ? 'كاش أو تحويل بنكي' : 'Cash or Bank Transfer',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // CarFax Vehicle Check Banner
                      InkWell(
                        onTap: () => _showCarFaxModal(context, ad?.localizedTitle(isAr)),
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
                          child: Row(
                            children: [
                              const Icon(Icons.car_crash, color: Color(0xFFD97706), size: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr('carfax_title'),
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                                    ),
                                    Text(
                                      context.tr('carfax_sub'),
                                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF92400E)),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF78350F)),
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
                            Row(
                              children: [
                                const Icon(Icons.chat_outlined, color: Color(0xFF2563EB), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  context.tr('ask_lister'),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildChip(isAr ? 'هل السلعة متوفرة؟' : 'Is this item available?', ad?.userId),
                                _buildChip(isAr ? 'ما هو السعر النهائي؟' : 'What is the final price?', ad?.userId),
                                _buildChip(isAr ? 'هل تقبل البدل؟' : 'Are you open to trade-in?', ad?.userId),
                                _buildChip(isAr ? 'أين موقع المعاينة؟' : 'Where can I inspect the item?', ad?.userId),
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
                            Text(
                              context.tr('ad_description_title'),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ad != null && ad.localizedDescription(isAr).isNotEmpty
                                  ? ad.localizedDescription(isAr)
                                  : (isAr
                                      ? 'حالة ممتازة جداً، استعمال خفيف، جاهز للمعاينة والتسليم الفوري في الكويت. تواصل عبر الواتساب أو الاتصال للمزيد من التفاصيل.'
                                      : 'Excellent condition, light use, ready for inspection and delivery in Kuwait. Contact via WhatsApp or phone for details.'),
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
                              child: Center(
                                child: Text(isAr ? 'الغانم' : 'Ghanim', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        isAr ? 'شركة الغانم العالمية' : 'Al Ghanim International Co.',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified, color: Color(0xFF2563EB), size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isAr ? 'عضو موثق • تقييم 4.9 من 5' : 'Verified Member • Rating 4.9 of 5',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                        child: Row(
                          children: [
                            const Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                context.tr('safety_tip_notice'),
                                style: const TextStyle(fontSize: 11, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
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
                      label: Text(context.tr('call_action'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final phone = ad?.phone?.isNotEmpty == true
                            ? ad!.phone!
                            : (ad?.whatsapp?.isNotEmpty == true ? ad!.whatsapp! : '+965 99001122');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF1E293B),
                            behavior: SnackBarBehavior.floating,
                            content: Text('${isAr ? "الاتصال برقم المعلن: " : "Calling seller: "}$phone'),
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
                      label: Text(context.tr('whatsapp_action'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final phone = ad?.whatsapp?.isNotEmpty == true
                            ? ad!.whatsapp!
                            : (ad?.phone?.isNotEmpty == true ? ad!.phone! : '+965 99001122');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF065F46),
                            behavior: SnackBarBehavior.floating,
                            content: Text('${isAr ? "فتح محادثة واتساب مع المعلن: " : "Opening WhatsApp: "}$phone'),
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
              content: Text(context.isArabic ? 'تم إرسال السؤال: "$text"' : 'Question sent: "$text"'),
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
