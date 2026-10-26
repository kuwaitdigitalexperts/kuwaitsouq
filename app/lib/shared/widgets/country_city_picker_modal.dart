import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/country_provider.dart';

class CountryCityPickerModal extends StatefulWidget {
  final Map<String, dynamic>? initialCountry;
  final String? initialCity;
  final bool isFirstLaunch;
  final bool isDismissible;
  final Function(Map<String, dynamic> country, String? city) onSelected;

  const CountryCityPickerModal({
    super.key,
    this.initialCountry,
    this.initialCity,
    this.isFirstLaunch = false,
    this.isDismissible = true,
    required this.onSelected,
  });

  static Future<void> show(
    BuildContext context, {
    Map<String, dynamic>? initialCountry,
    String? initialCity,
    bool isDismissible = true,
    required Function(Map<String, dynamic> country, String? city) onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CountryCityPickerModal(
        initialCountry: initialCountry,
        initialCity: initialCity,
        isDismissible: isDismissible,
        onSelected: onSelected,
      ),
    );
  }

  static Future<void> showFirstLaunch(
    BuildContext context, {
    required Function(Map<String, dynamic> country, String? city) onSelected,
  }) {
    // In Kuwait-only mode, first launch doesn't block with foreign countries
    onSelected(AppConstants.kuwaitCountry, null);
    return Future.value();
  }

  @override
  State<CountryCityPickerModal> createState() => _CountryCityPickerModalState();
}

class _CountryCityPickerModalState extends State<CountryCityPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Fallback Kuwait areas if offline or API delay
  static const List<Map<String, dynamic>> _fallbackKuwaitAreas = [
    {'id': 1, 'name': 'Kuwait City', 'name_ar': 'مدينة الكويت', 'pos': 1},
    {'id': 2, 'name': 'Hawally', 'name_ar': 'حولي', 'pos': 2},
    {'id': 3, 'name': 'Salmiya', 'name_ar': 'السالمية', 'pos': 3},
    {'id': 4, 'name': 'Al Farwaniyah', 'name_ar': 'الفروانية', 'pos': 4},
    {'id': 5, 'name': 'Al Ahmadi', 'name_ar': 'الأحمدي', 'pos': 5},
    {'id': 6, 'name': 'Al Jahra', 'name_ar': 'الجهراء', 'pos': 6},
    {'id': 7, 'name': 'Mubarak Al-Kabeer', 'name_ar': 'مبارك الكبير', 'pos': 7},
    {'id': 8, 'name': 'Shuwaikh', 'name_ar': 'الشويخ', 'pos': 8},
    {'id': 9, 'name': 'Khaitan', 'name_ar': 'خيطان', 'pos': 9},
    {'id': 10, 'name': 'Fahaheel', 'name_ar': 'الفحيحيل', 'pos': 10},
    {'id': 11, 'name': 'Sabah Al-Salem', 'name_ar': 'صباح السالم', 'pos': 11},
    {'id': 12, 'name': 'Khiran', 'name_ar': 'الخيران', 'pos': 12},
  ];

  @override
  void initState() {
    super.initState();
    // Ensure locations are fetched from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final countryProv = context.read<CountryProvider>();
      if (countryProv.locations.isEmpty) {
        countryProv.fetchLocations();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;
    final countryProv = context.watch<CountryProvider>();
    final activeCityId = countryProv.selectedCityId;

    // Use dynamic locations if available, otherwise fallback
    final rawLocations = countryProv.locations.isNotEmpty
        ? countryProv.locations
        : _fallbackKuwaitAreas;

    // Filter by search query
    final filteredLocations = rawLocations.where((loc) {
      if (_searchQuery.isEmpty) return true;
      final nameEn = (loc['name'] ?? '').toString().toLowerCase();
      final nameAr = (loc['name_ar'] ?? '').toString().toLowerCase();
      final q = _searchQuery.toLowerCase();
      return nameEn.contains(q) || nameAr.contains(q);
    }).toList();

    final isAllSelected = activeCityId == null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🇰🇼', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'مناطق ومحافظات الكويت' : 'Kuwait Areas & Governorates',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          isAr ? 'اختر المنطقة لتصفية الإعلانات' : 'Filter listings by Kuwait area',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.isDismissible)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),

          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: isAr
                      ? 'ابحث عن منطقة (مثال: حولي، السالمية، الشويخ)...'
                      : 'Search area (e.g. Hawally, Salmiya, Shuwaikh)...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16, color: Color(0xFF64748B)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Locations List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // "All Kuwait" Option
                InkWell(
                  onTap: () {
                    countryProv.selectArea(id: null, name: null, nameAr: null);
                    widget.onSelected(AppConstants.kuwaitCountry, null);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isAllSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isAllSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                        width: isAllSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isAllSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '🇰🇼',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAr ? 'كل مناطق الكويت' : 'All Kuwait',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isAllSelected ? FontWeight.w900 : FontWeight.w700,
                                    color: isAllSelected ? const Color(0xFF1D4ED8) : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  isAr ? 'عرض الإعلانات من جميع المحافظات' : 'Show ads from all areas',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (isAllSelected)
                          const Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 20)
                        else
                          Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400, size: 20),
                      ],
                    ),
                  ),
                ),

                // Section Title: Specific Areas
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    isAr ? 'المناطق والمحافظات:' : 'Areas & Governorates:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                // Dynamic Kuwait Areas
                if (countryProv.locationsLoading && countryProv.locations.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else if (filteredLocations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        isAr ? 'لم يتم العثور على منطقة مطابقة' : 'No matching areas found',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ),
                  )
                else
                  ...filteredLocations.map((loc) {
                    final id = loc['id'] as int?;
                    final nameEn = loc['name'] as String? ?? '';
                    final nameAr = loc['name_ar'] as String? ?? nameEn;
                    final isSelected = activeCityId == id;

                    return InkWell(
                      key: ValueKey('area_$id'),
                      onTap: () {
                        countryProv.selectArea(id: id, name: nameEn, nameAr: nameAr);
                        widget.onSelected(AppConstants.kuwaitCountry, nameEn);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAr ? nameAr : nameEn,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    if (nameEn != nameAr)
                                      Text(
                                        isAr ? nameEn : nameAr,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 18)
                            else
                              Icon(Icons.radio_button_unchecked, color: Colors.grey.shade300, size: 18),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
