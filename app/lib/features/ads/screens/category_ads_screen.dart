import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../core/models/ad_model.dart';
import '../../../../shared/theme/app_theme.dart';

class CategoryAdsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String? parentTitle;

  const CategoryAdsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.parentTitle,
  });

  @override
  State<CategoryAdsScreen> createState() => _CategoryAdsScreenState();
}

class _CategoryAdsScreenState extends State<CategoryAdsScreen> {
  final _api = ApiClient();
  bool _isGrid = true;
  int? _selectedSubFilterId;

  // Database-driven filters & quick cards
  List<dynamic> _quickCards = [];
  List<dynamic> _filters = [];
  final Map<String, String> _activeFilters = {}; // filter_key -> value_slug
  final Map<String, String> _activeFilterLabels = {}; // filter_key -> human label

  // Location filter
  int? _selectedLocationId;
  String? _selectedLocationName;
  List<dynamic> _locations = [];

  // Price & Condition filters
  double? _minPrice;
  double? _maxPrice;
  String? _priceLabel;
  String? _selectedCondition;

  // Sorting
  String _sortBy = 'newest';
  String _sortLabel = 'Newest';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryFilters();
      _loadLocations();
      _applyFilters();
    });
  }

  Future<void> _loadCategoryFilters() async {
    try {
      final targetCatId = _selectedSubFilterId ?? widget.categoryId;
      final data = await _api.getCategoryFilters(targetCatId);
      if (mounted) {
        setState(() {
          _quickCards = (data['quick_cards'] as List?) ?? [];
          _filters = (data['filters'] as List?) ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error loading category filters: $e');
    }
  }

  Future<void> _loadLocations() async {
    try {
      final locs = await _api.getLocations();
      if (mounted) {
        setState(() => _locations = locs);
      }
    } catch (e) {
      debugPrint('Error loading locations: $e');
    }
  }

  void _applyFilters() {
    final targetCatId = _selectedSubFilterId ?? widget.categoryId;
    final country = context.read<CountryProvider>().currentCountry;
    context.read<AdsProvider>().fetchAds(
      categoryId: targetCatId,
      locationId: _selectedLocationId,
      countryId: country['id'] as int?,
      countryCode: country['code'] as String?,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      condition: _selectedCondition,
      sortBy: _sortBy,
      filterAttributes: _activeFilters,
    );
  }

  void _resetAllFilters() {
    setState(() {
      _activeFilters.clear();
      _activeFilterLabels.clear();
      _selectedLocationId = null;
      _selectedLocationName = null;
      _minPrice = null;
      _maxPrice = null;
      _priceLabel = null;
      _selectedCondition = null;
      _sortBy = 'newest';
      _sortLabel = 'Newest';
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final catsProvider = context.watch<CategoriesProvider>();
    final countryProv = context.watch<CountryProvider>();
    final subcategories = catsProvider.childrenOf(widget.categoryId);
    final ads = adsProvider.ads;

    final hasActiveFilters = _activeFilters.isNotEmpty ||
        _selectedLocationId != null ||
        _priceLabel != null ||
        _selectedCondition != null;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textDark),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: AppTheme.textDark),
            onPressed: () => context.push('/saved'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Subcategories horizontal chips (if any exist for parent)
          if (subcategories.isNotEmpty)
            Container(
              color: AppTheme.surfaceWhite,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    _buildPillChip(
                      label: 'All',
                      isSelected: _selectedSubFilterId == null,
                      onTap: () {
                        setState(() {
                          _selectedSubFilterId = null;
                          _activeFilters.clear();
                          _activeFilterLabels.clear();
                        });
                        _loadCategoryFilters();
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 8),
                    ...subcategories.map((sub) {
                      final isSelected = _selectedSubFilterId == sub['id'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildPillChip(
                          label: sub['name'] ?? '',
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedSubFilterId = null;
                              } else {
                                _selectedSubFilterId = sub['id'] as int;
                              }
                              _activeFilters.clear();
                              _activeFilterLabels.clear();
                            });
                            _loadCategoryFilters();
                            _applyFilters();
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

          // 2. Circular Quick Cards Carousel (Screenshot 1, 2, 4)
          if (_quickCards.isNotEmpty) _buildQuickCardsCarousel(),

          // 3. Dynamic Filter Dropdown Pills Row
          _buildFilterPillsRow(),

          // 4. Active Filters Badges (removable chips)
          if (hasActiveFilters) _buildActiveFilterChips(),

          // 5. Count & View Controls Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${ads.length} إعلان في ${countryProv.countryNameAr}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Sort Dropdown Button
                InkWell(
                  onTap: _showSortBottomSheet,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort, color: AppTheme.textDark, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          '$_sortLabel ▾',
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Grid / List toggle
                InkWell(
                  onTap: () => setState(() => _isGrid = !_isGrid),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Icon(
                      _isGrid ? Icons.view_list : Icons.grid_view,
                      color: AppTheme.textDark,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Ads List / Grid View or Empty State
          Expanded(
            child: adsProvider.loading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
                : ads.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        color: AppTheme.primaryGreen,
                        backgroundColor: AppTheme.surfaceWhite,
                        onRefresh: () async {
                          await _loadCategoryFilters();
                          _applyFilters();
                        },
                        child: _isGrid
                            ? GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.64,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: ads.length,
                                itemBuilder: (context, index) => _buildGridCard(ads[index]),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                itemCount: ads.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) => _buildListCard(ads[index]),
                              ),
                      ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Quick Cards Carousel (Exact match to reference screenshots)
  // ─────────────────────────────────────────────
  Widget _buildQuickCardsCarousel() {
    return Container(
      color: AppTheme.surfaceWhite,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: SizedBox(
        height: 98,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: _quickCards.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final card = _quickCards[index];
            final filterKey = card['filter_key'] as String? ?? 'brand';
            final cardValue = card['value'] as String? ?? '';
            final isSelected = filterKey == 'subcategory'
                ? _selectedSubFilterId == int.tryParse(cardValue)
                : _activeFilters[filterKey] == cardValue;

            // Compute full absolute image URL safely
            String? iconUrl = card['icon'] as String?;
            if (iconUrl != null && iconUrl.isNotEmpty) {
              if (!iconUrl.startsWith('http://') && !iconUrl.startsWith('https://')) {
                final base = ApiClient.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
                iconUrl = '$base/${iconUrl.startsWith('/') ? iconUrl.substring(1) : iconUrl}';
              }
            }

            return InkWell(
              onTap: () {
                if (filterKey == 'subcategory') {
                  final subId = int.tryParse(cardValue);
                  setState(() {
                    if (_selectedSubFilterId == subId) {
                      _selectedSubFilterId = null;
                    } else {
                      _selectedSubFilterId = subId;
                    }
                    _activeFilters.clear();
                    _activeFilterLabels.clear();
                  });
                  _loadCategoryFilters();
                  _applyFilters();
                  return;
                }
                setState(() {
                  if (isSelected) {
                    _activeFilters.remove(filterKey);
                    _activeFilterLabels.remove(filterKey);
                  } else {
                    _activeFilters[filterKey] = cardValue;
                    _activeFilterLabels[filterKey] = card['label'] ?? cardValue;
                  }
                });
                _applyFilters();
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular Badge
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppTheme.primaryGreen.withOpacity(0.12)
                          : const Color(0xFFF7F8F9),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: iconUrl != null && iconUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: iconUrl,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Icon(
                              Icons.category_outlined,
                              size: 24,
                              color: isSelected ? AppTheme.primaryGreen : AppTheme.textMuted,
                            ),
                          )
                        : Icon(
                            Icons.category_outlined,
                            size: 24,
                            color: isSelected ? AppTheme.primaryGreen : AppTheme.textMuted,
                          ),
                  ),
                  const SizedBox(height: 5),
                  // Label underneath
                  SizedBox(
                    width: 68,
                    child: Text(
                      card['label'] ?? '',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.textDark,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Dynamic Filter Pills Row (Location, Price, Condition, Dynamic DB Pills, More)
  // ─────────────────────────────────────────────
  Widget _buildFilterPillsRow() {
    final pinnedFilters = _filters.where((f) => f['is_pinned'] == true || f['is_pinned'] == 1).toList();

    return Container(
      color: AppTheme.surfaceWhite,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            // 1. Location Pill
            _buildDropdownPill(
              label: _selectedLocationName != null ? '$_selectedLocationName' : 'Location',
              isActive: _selectedLocationId != null,
              onTap: _showLocationBottomSheet,
            ),
            const SizedBox(width: 8),

            // 2. Price Pill
            _buildDropdownPill(
              label: _priceLabel ?? 'السعر (KD)',
              isActive: _priceLabel != null,
              onTap: _showPriceBottomSheet,
            ),
            const SizedBox(width: 8),

            // 3. Dynamic Pinned Category Filters (e.g. Boat Type, Make, Year, Property Type, Condition)
            ...pinnedFilters.map((filter) {
              final filterKey = filter['filter_key'] as String;
              final filterName = filter['name'] as String;
              final selectedValue = _activeFilters[filterKey];
              final hasSelection = selectedValue != null;
              final displayLabel = hasSelection
                  ? (_activeFilterLabels[filterKey] ?? filterName)
                  : filterName;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildDropdownPill(
                  label: displayLabel,
                  isActive: hasSelection,
                  onTap: () => _showFilterOptionsBottomSheet(filter),
                ),
              );
            }),

            // 4. "More" Pill (opens remaining non-pinned filters or all filters)
            _buildMorePill(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownPill({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryGreen.withOpacity(0.08) : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.primaryGreen : AppTheme.borderLight,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primaryGreen : AppTheme.textDark,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isActive ? AppTheme.primaryGreen : AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMorePill() {
    final nonPinnedCount = _filters.where((f) => f['is_pinned'] != true && f['is_pinned'] != 1).length;
    return InkWell(
      onTap: _showMoreFiltersBottomSheet,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune_rounded, size: 14, color: AppTheme.textDark),
            const SizedBox(width: 4),
            Text(
              nonPinnedCount > 0 ? 'More ($nonPinnedCount)' : 'More',
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Active Filter Chips
  // ─────────────────────────────────────────────
  Widget _buildActiveFilterChips() {
    return Container(
      color: AppTheme.surfaceWhite,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Reset All button
            InkWell(
              onTap: _resetAllFilters,
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppTheme.accentOrange,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (_selectedLocationName != null)
              _buildFilterBadgeChip(
                label: 'Location: $_selectedLocationName',
                onRemove: () {
                  setState(() {
                    _selectedLocationId = null;
                    _selectedLocationName = null;
                  });
                  _applyFilters();
                },
              ),

            if (_priceLabel != null)
              _buildFilterBadgeChip(
                label: 'Price: $_priceLabel',
                onRemove: () {
                  setState(() {
                    _minPrice = null;
                    _maxPrice = null;
                    _priceLabel = null;
                  });
                  _applyFilters();
                },
              ),

            if (_selectedCondition != null)
              _buildFilterBadgeChip(
                label: 'Condition: ${_selectedCondition!.toUpperCase()}',
                onRemove: () {
                  setState(() => _selectedCondition = null);
                  _applyFilters();
                },
              ),

            ..._activeFilters.entries.map((entry) {
              final key = entry.key;
              final humanLabel = _activeFilterLabels[key] ?? entry.value;
              return _buildFilterBadgeChip(
                label: humanLabel,
                onRemove: () {
                  setState(() {
                    _activeFilters.remove(key);
                    _activeFilterLabels.remove(key);
                  });
                  _applyFilters();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBadgeChip({required String label, required VoidCallback onRemove}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primaryGreen,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 13, color: AppTheme.primaryGreen),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Modal Bottom Sheets for Filters
  // ─────────────────────────────────────────────

  // 1. Dynamic DB Filter Options Sheet
  void _showFilterOptionsBottomSheet(Map<String, dynamic> filter) {
    final filterKey = filter['filter_key'] as String;
    final filterName = filter['name'] as String;
    final options = (filter['options'] as List?) ?? [];
    final currentSelection = _activeFilters[filterKey];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    Text(
                      filterName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    if (currentSelection != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _activeFilters.remove(filterKey);
                            _activeFilterLabels.remove(filterKey);
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        child: const Text('Reset', style: TextStyle(color: AppTheme.accentOrange, fontSize: 13)),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Options list
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isAll = currentSelection == null;
                      return ListTile(
                        title: const Text('All', style: TextStyle(fontSize: 14)),
                        trailing: isAll ? const Icon(Icons.check, color: AppTheme.primaryGreen) : null,
                        onTap: () {
                          setState(() {
                            _activeFilters.remove(filterKey);
                            _activeFilterLabels.remove(filterKey);
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                      );
                    }

                    final opt = options[index - 1];
                    final optValue = opt['value'] as String;
                    final optLabel = opt['label'] as String;
                    final isSelected = currentSelection == optValue;

                    return ListTile(
                      leading: opt['icon'] != null && (opt['icon'] as String).isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: opt['icon'],
                                width: 28,
                                height: 28,
                                fit: BoxFit.contain,
                                errorWidget: (_, __, ___) => const Icon(Icons.circle, size: 8, color: AppTheme.textMuted),
                              ),
                            )
                          : null,
                      title: Text(
                        optLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textDark,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryGreen) : null,
                      onTap: () {
                        setState(() {
                          _activeFilters[filterKey] = optValue;
                          _activeFilterLabels[filterKey] = optLabel;
                        });
                        Navigator.pop(context);
                        _applyFilters();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. Location Bottom Sheet
  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    const Text(
                      'مناطق ومحافظات الكويت (Kuwait Locations)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    const Spacer(),
                    if (_selectedLocationId != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedLocationId = null;
                            _selectedLocationName = null;
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        child: const Text('كل الكويت', style: TextStyle(color: Color(0xFF2563EB), fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _locations.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = _selectedLocationId == null;
                      return ListTile(
                        leading: const Icon(Icons.map_outlined, color: Color(0xFF2563EB)),
                        title: const Text('كل الكويت (All Kuwait)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null,
                        onTap: () {
                          setState(() {
                            _selectedLocationId = null;
                            _selectedLocationName = null;
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                      );
                    }
                    final loc = _locations[index - 1];
                    final isSelected = _selectedLocationId == loc['id'];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: AppTheme.textMuted, size: 20),
                      title: Text(loc['name'] ?? '', style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                      trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryGreen) : null,
                      onTap: () {
                        setState(() {
                          _selectedLocationId = loc['id'] as int;
                          _selectedLocationName = loc['name'] as String;
                        });
                        Navigator.pop(context);
                        _applyFilters();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Price Bottom Sheet
  void _showPriceBottomSheet() {
    final priceRanges = [
      {'label': 'أقل من 100 د.ك (Under 100 KD)', 'min': 0.0, 'max': 100.0},
      {'label': '100 - 500 د.ك', 'min': 100.0, 'max': 500.0},
      {'label': '500 - 1,500 د.ك', 'min': 500.0, 'max': 1500.0},
      {'label': '1,500 - 5,000 د.ك', 'min': 1500.0, 'max': 5000.0},
      {'label': '5,000 - 15,000 د.ك', 'min': 5000.0, 'max': 15000.0},
      {'label': 'أكثر من 15,000 د.ك (+15,000 KD)', 'min': 15000.0, 'max': 1000000.0},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    const Text('نطاق السعر (Price Range - KD)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (_priceLabel != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _minPrice = null;
                            _maxPrice = null;
                            _priceLabel = null;
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        child: const Text('Reset', style: TextStyle(color: AppTheme.accentOrange, fontSize: 13)),
                      ),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...priceRanges.map((range) {
                final isSelected = _priceLabel == range['label'];
                return ListTile(
                  title: Text(range['label'] as String, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryGreen) : null,
                  onTap: () {
                    setState(() {
                      _minPrice = range['min'] as double;
                      _maxPrice = range['max'] as double;
                      _priceLabel = range['label'] as String;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // 4. More Filters Bottom Sheet
  void _showMoreFiltersBottomSheet() {
    final nonPinnedFilters = _filters.where((f) => f['is_pinned'] != true && f['is_pinned'] != 1).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    const Text('All Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _resetAllFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset All', style: TextStyle(color: AppTheme.accentOrange, fontSize: 13)),
                    ),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // Location
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: Color(0xFF2563EB)),
                      title: const Text('المنطقة (Location)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(_selectedLocationName ?? 'كل الكويت (All Kuwait)', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        _showLocationBottomSheet();
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),

                    // Price
                    ListTile(
                      leading: const Icon(Icons.payments_outlined, color: Color(0xFF2563EB)),
                      title: const Text('السعر (Price Range - KD)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(_priceLabel ?? 'الكل (Any price)', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        _showPriceBottomSheet();
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),

                    // Condition
                    ListTile(
                      leading: const Icon(Icons.verified_outlined, color: AppTheme.primaryGreen),
                      title: const Text('Condition', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(_selectedCondition?.toUpperCase() ?? 'All', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        _showConditionBottomSheet();
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),

                    // Dynamic filters from backend
                    ..._filters.map((filter) {
                      final filterKey = filter['filter_key'] as String;
                      final filterName = filter['name'] as String;
                      final selectedVal = _activeFilterLabels[filterKey] ?? 'Any';

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.filter_list, color: AppTheme.primaryGreen),
                            title: Text(filterName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: Text(selectedVal, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(context);
                              _showFilterOptionsBottomSheet(filter);
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. Condition Bottom Sheet
  void _showConditionBottomSheet() {
    final conditions = [
      {'label': 'All Conditions', 'val': null},
      {'label': 'Brand New', 'val': 'new'},
      {'label': 'Used', 'val': 'used'},
      {'label': 'Reconditioned', 'val': 'reconditioned'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    const Text('Item Condition', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...conditions.map((c) {
                final isSelected = _selectedCondition == c['val'];
                return ListTile(
                  title: Text(c['label'] as String, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryGreen) : null,
                  onTap: () {
                    setState(() => _selectedCondition = c['val'] as String?);
                    Navigator.pop(context);
                    _applyFilters();
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // 6. Sort Bottom Sheet
  void _showSortBottomSheet() {
    final sortOptions = [
      {'label': 'Newest First', 'key': 'newest'},
      {'label': 'Price: Low to High', 'key': 'price_asc'},
      {'label': 'Price: High to Low', 'key': 'price_desc'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: Row(
                  children: [
                    const Text('Sort Ads By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...sortOptions.map((opt) {
                final isSelected = _sortBy == opt['key'];
                return ListTile(
                  title: Text(opt['label'] as String, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryGreen) : null,
                  onTap: () {
                    setState(() {
                      _sortBy = opt['key'] as String;
                      _sortLabel = (opt['label'] as String).split(' ').first;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Empty State & Grid / List Cards
  // ─────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.tagBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No ads found in ${widget.categoryName}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'حاول تعديل خيارات البحث أو كن أول من يضيف إعلاناً في الكويت والخليج!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _resetAllFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textDark,
                    side: const BorderSide(color: AppTheme.borderLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Clear Filters'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => context.push('/post-ad'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Post Your Ad'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textDark,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(AdModel ad) {
    final fmt = NumberFormat.currency(locale: 'ar_KW', symbol: '${ad.currency} ', decimalDigits: 0);
    final locationText = ad.locationName.isNotEmpty ? ad.locationName : 'مدينة الكويت (Kuwait)';

    return InkWell(
      onTap: () => context.push('/ads/${ad.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderLight, width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                Container(
                  height: 135,
                  width: double.infinity,
                  color: const Color(0xFFF2F5F3),
                  child: ad.primaryImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: ad.primaryImageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(Icons.image_outlined, color: AppTheme.textMuted, size: 36),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.image_outlined, color: AppTheme.textMuted, size: 36),
                        ),
                ),
                if (ad.isFeatured)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentOrange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, color: AppTheme.textDark, size: 16),
                  ),
                ),
              ],
            ),

            // Card Text Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fmt.format(ad.price),
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ad.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: AppTheme.primaryGreen),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(AdModel ad) {
    final fmt = NumberFormat.currency(locale: 'ar_KW', symbol: '${ad.currency} ', decimalDigits: 0);
    final locationText = ad.locationName.isNotEmpty ? ad.locationName : 'مدينة الكويت (Kuwait)';

    return InkWell(
      onTap: () => context.push('/ads/${ad.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight, width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 95,
                height: 95,
                color: const Color(0xFFF2F5F3),
                child: ad.primaryImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: ad.primaryImageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.image_outlined, color: AppTheme.textMuted),
                      )
                    : const Icon(Icons.image_outlined, color: AppTheme.textMuted, size: 32),
              ),
            ),
            const SizedBox(width: 12),

            // Right Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          ad.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.favorite_border, color: AppTheme.textMuted, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fmt.format(ad.price),
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppTheme.textMuted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                        ),
                      ),
                    ],
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
