import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/country_city_picker_modal.dart';
import '../../ads/widgets/ad_card.dart';
import '../widgets/home_header.dart';
import '../widgets/stories_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/kayishha_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  bool _firstLaunchChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunchAndLoadAds();
    });
  }

  void _checkFirstLaunchAndLoadAds() {
    if (!mounted) return;
    final countryProv = context.read<CountryProvider>();

    if (!countryProv.isCountrySaved && !_firstLaunchChecked) {
      _firstLaunchChecked = true;
      CountryCityPickerModal.showFirstLaunch(
        context,
        onSelected: (country, city) {
          countryProv.selectCountry(country, city: city);
          _loadAds();
        },
      );
    } else {
      _loadAds();
    }
  }

  void _loadAds() {
    if (!mounted) return;
    final ads = context.read<AdsProvider>();
    final countryProv = context.read<CountryProvider>();
    final country = countryProv.currentCountry;

    ads.fetchAds(
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      countryId: country['id'] as int?,
      countryCode: country['code'] as String?,
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryProv = context.watch<CountryProvider>();
    final adsProvider = context.watch<AdsProvider>();
    final ads = adsProvider.ads;

    // Check if initialization finished and country not yet saved
    if (countryProv.isInitialized && !countryProv.isCountrySaved && !_firstLaunchChecked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkFirstLaunchAndLoadAds();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadAds();
        },
        child: CustomScrollView(
          slivers: [
            // KuwaitSouq Top App Bar & Location Picker
            SliverToBoxAdapter(
              child: HomeHeader(
                currentCountry: countryProv.currentCountry,
                currentCity: countryProv.currentCity,
                onSearch: (q) {
                  setState(() => _searchQuery = q);
                  _loadAds();
                },
                onLocationChanged: (country, city) {
                  countryProv.selectCountry(country, city: city);
                  _loadAds();
                },
              ),
            ),

            // Seller Stories Carousel (Screenshot 1 & 3)
            const SliverToBoxAdapter(
              child: StoriesCarousel(),
            ),

            // Top Categories Grid (Screenshot 1)
            const SliverToBoxAdapter(
              child: CategoryGrid(),
            ),

            // Kayishha Cash Banner (Screenshot 1)
            const SliverToBoxAdapter(
              child: KayishhaBanner(),
            ),

            // Section Header: Latest Ads
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أحدث الإعلانات المميزة (${ads.length})',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const Text(
                      'الكويت والخليج',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ad Feed Cards (Screenshot 3)
            if (adsProvider.loading && ads.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  ),
                ),
              )
            else if (ads.isEmpty)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: Color(0xFF94A3B8)),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد إعلانات مطابقة حالياً',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'كن أول من يضيف إعلاناً في هذا القسم أو الدولة',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AdCard(ad: ads[index]),
                      );
                    },
                    childCount: ads.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
