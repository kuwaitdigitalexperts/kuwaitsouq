import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../theme/app_theme.dart';

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
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PopScope(
        canPop: false,
        child: CountryCityPickerModal(
          isFirstLaunch: true,
          isDismissible: false,
          onSelected: onSelected,
        ),
      ),
    );
  }

  @override
  State<CountryCityPickerModal> createState() => _CountryCityPickerModalState();
}

class _CountryCityPickerModalState extends State<CountryCityPickerModal> {
  late Map<String, dynamic> _selectedCountry;
  String? _selectedCity;

  // City lists for Gulf Countries
  static const Map<String, List<String>> _citiesByCountry = {
    'KW': [
      'كل المدن (All Kuwait)',
      'مدينة الكويت (Kuwait City)',
      'حولي (Hawally)',
      'السالمية (Salmiya)',
      'الفروانية (Farwaniya)',
      'خيطان (Khaitan)',
      'الأحمدي (Ahmadi)',
      'الفحيحيل (Fahaheel)',
      'المنقف (Mangaf)',
      'الجهراء (Jahra)',
      'مبارك الكبير (Mubarak Al-Kabeer)',
      'صباح السالم (Sabah Al-Salem)',
      'الشويخ (Shuwaikh)',
    ],
    'SA': [
      'كل المدن (All Saudi)',
      'الرياض (Riyadh)',
      'جدة (Jeddah)',
      'الدمام (Dammam)',
      'مكة المكرمة (Mecca)',
      'المدينة المنورة (Medina)',
      'الخبر (Khobar)',
    ],
    'AE': [
      'كل المدن (All UAE)',
      'دبي (Dubai)',
      'أبوظبي (Abu Dhabi)',
      'الشارقة (Sharjah)',
      'عجمان (Ajman)',
      'رأس الخيمة (Ras Al Khaimah)',
    ],
    'QA': [
      'كل المدن (All Qatar)',
      'الدوحة (Doha)',
      'الريان (Al Rayyan)',
      'الوكرة (Al Wakrah)',
      'الخور (Al Khor)',
    ],
    'BH': [
      'كل المدن (All Bahrain)',
      'المنامة (Manama)',
      'المحرق (Muharraq)',
      'الرفاع (Riffa)',
    ],
    'OM': [
      'كل المدن (All Oman)',
      'مسقط (Muscat)',
      'صلالة (Salalah)',
      'صحار (Sohar)',
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry ?? AppConstants.gccCountries.first;
    _selectedCity = widget.initialCity;
  }

  @override
  Widget build(BuildContext context) {
    final code = _selectedCountry['code'] as String? ?? 'KW';
    final cities = _citiesByCountry[code] ?? _citiesByCountry['KW']!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isFirstLaunch
                            ? 'مرحباً بك! اختر دولتك (Choose Country)'
                            : 'اختر الدولة والمدينة (Select Location)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      if (widget.isFirstLaunch) ...[
                        const SizedBox(height: 2),
                        const Text(
                          'حدد دولتك لتصفح الإعلانات والأسعار والخدمات الخاصة بها',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.isDismissible)
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Country horizontal selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFFF8FAFC),
            child: SizedBox(
              height: 78,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.gccCountries.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final c = AppConstants.gccCountries[index];
                  final isSelected = c['code'] == _selectedCountry['code'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCountry = c;
                        _selectedCity = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 82,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c['flag'] as String? ?? '🇰🇼',
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c['name_ar'] as String? ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Text(
              'مدن ومناطق ${_selectedCountry['name_ar']} (${_selectedCountry['name']})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMuted,
              ),
            ),
          ),

          // Cities List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = _selectedCity == city ||
                    (_selectedCity == null && index == 0);

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected ? const Color(0xFFEFF6FF) : null,
                  leading: Icon(
                    Icons.location_on,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                    size: 20,
                  ),
                  title: Text(
                    city,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF2563EB) : AppTheme.textDark,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 20)
                      : null,
                  onTap: () {
                    widget.onSelected(_selectedCountry, index == 0 ? null : city);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          // Confirm Bottom CTA
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    widget.onSelected(_selectedCountry, _selectedCity);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'تأكيد ومتابعة (${_selectedCountry['name_ar']})',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
