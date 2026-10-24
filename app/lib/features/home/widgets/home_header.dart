import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/country_city_picker_modal.dart';

class HomeHeader extends StatelessWidget {
  final Map<String, dynamic> currentCountry;
  final String? currentCity;
  final ValueChanged<String> onSearch;
  final Function(Map<String, dynamic> country, String? city) onLocationChanged;

  const HomeHeader({
    super.key,
    required this.currentCountry,
    this.currentCity,
    required this.onSearch,
    required this.onLocationChanged,
  });

  String _formatCity(String? city, bool isAr) {
    if (city == null) return isAr ? 'الكل' : 'All';
    final match = RegExp(r'^(.*?)\s*\((.*?)\)$').firstMatch(city);
    if (match != null) {
      return isAr ? match.group(1)!.trim() : match.group(2)!.trim();
    }
    return city;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;
    final countryName = isAr
        ? (currentCountry['name_ar'] as String? ?? 'الكويت')
        : (currentCountry['name'] as String? ?? 'Kuwait');
    final flag = currentCountry['flag'] as String? ?? '🇰🇼';
    final displayCity = _formatCity(currentCity, isAr);
    final citySuffix = currentCity != null ? " • $displayCity" : "";

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB), // Vibrant Royal Blue Top Bar
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Row 1: Search Bar + Share + Notification Bell
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  // Search Input
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onSubmitted: onSearch,
                        textInputAction: TextInputAction.search,
                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: context.tr('search_in_kuwaitsouq'),
                          hintStyle: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12.5,
                          ),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Share Icon
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.tr('share_copied'))),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  // Notification Bell with Badge "1"
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Row 2: White Ribbon for Country & City Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title: All Listings in Country
                  Expanded(
                    child: Text(
                      '${context.tr('all_ads_in')} $countryName$citySuffix',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Actions: City / Country Switcher Button
                  InkWell(
                    onTap: () {
                      CountryCityPickerModal.show(
                        context,
                        initialCountry: currentCountry,
                        initialCity: currentCity,
                        onSelected: onLocationChanged,
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            displayCity,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
