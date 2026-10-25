import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/auth_bottom_sheet.dart';
import '../../../../shared/widgets/app_video_player.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../../../../core/localization/app_localizations.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({super.key});

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String _condition = 'used';
  String _currency = 'KWD';
  int? _parentCategoryId;
  int? _subCategoryId;
  int? _locationId;
  bool _isFeatured = false;
  bool _isUrgent = false;
  final List<File> _images = [];
  File? _video;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (!auth.isAuthenticated) {
        AuthBottomSheet.show(context).then((loggedIn) {
          if (loggedIn != true && mounted && !context.read<AuthProvider>().isAuthenticated) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          }
        });
      }
      context.read<CategoriesProvider>().fetchCategories();
      context.read<CategoriesProvider>().fetchLocations();
    });
  }

  Future<void> _pickImages() async {
    final isArabic = context.isArabic;
    final remainingSlots = 4 - _images.length;
    if (remainingSlots <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'الحد الأقصى 4 صور فقط.' : 'Maximum 4 photos allowed.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppTheme.primaryBlue),
                title: Text(
                  isArabic ? 'اختيار صور من المعرض' : 'Choose Photos from Gallery',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(isArabic ? 'اختر حتى $remainingSlots صور' : 'Select up to $remainingSlots photos'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final pickedList = await _picker.pickMultiImage(imageQuality: 85);
                    if (pickedList.isNotEmpty) {
                      setState(() {
                        for (final x in pickedList.take(remainingSlots)) {
                          _images.add(File(x.path));
                        }
                      });
                    }
                  } catch (e) {
                    debugPrint('Error picking images: $e');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppTheme.primaryGreen),
                title: Text(
                  isArabic ? 'التقاط صورة بالكاميرا' : 'Take a Photo with Camera',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                    if (picked != null) {
                      setState(() {
                        if (_images.length < 4) {
                          _images.add(File(picked.path));
                        }
                      });
                    }
                  } catch (e) {
                    debugPrint('Error taking photo: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickVideo() async {
    final isArabic = context.isArabic;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_library_outlined, color: AppTheme.accentOrange),
                title: Text(
                  isArabic ? 'اختيار فيديو من المعرض' : 'Choose Video from Gallery',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(isArabic ? 'فيديو واحد كحد أقصى، حتى 50 ميجابايت' : 'Max 1 video, up to 50MB'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final picked = await _picker.pickVideo(
                      source: ImageSource.gallery,
                      maxDuration: const Duration(minutes: 2),
                    );
                    if (picked != null) {
                      final file = File(picked.path);
                      final sizeBytes = await file.length();
                      if (sizeBytes > 52428800) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                isArabic
                                    ? 'حجم ملف الفيديو يتجاوز 50 ميجابايت. الرجاء اختيار مقطع أصغر.'
                                    : 'Video file exceeds 50MB. Please choose a smaller clip.',
                              ),
                            ),
                          );
                        }
                        return;
                      }
                      setState(() => _video = file);
                    }
                  } catch (e) {
                    debugPrint('Error picking video: $e');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: AppTheme.primaryBlue),
                title: Text(
                  isArabic ? 'تسجيل فيديو بالكاميرا' : 'Record a Video with Camera',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final picked = await _picker.pickVideo(
                      source: ImageSource.camera,
                      maxDuration: const Duration(minutes: 1),
                    );
                    if (picked != null) {
                      final file = File(picked.path);
                      final sizeBytes = await file.length();
                      if (sizeBytes > 52428800) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                isArabic ? 'حجم ملف الفيديو يتجاوز 50 ميجابايت.' : 'Video file exceeds 50MB.',
                              ),
                            ),
                          );
                        }
                        return;
                      }
                      setState(() => _video = file);
                    }
                  } catch (e) {
                    debugPrint('Error recording video: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final isArabic = context.isArabic;
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) {
      final ok = await AuthBottomSheet.show(context);
      if (ok != true || !mounted) return;
    }

    if (!_formKey.currentState!.validate()) return;

    final targetCatId = _subCategoryId ?? _parentCategoryId;
    if (targetCatId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'الرجاء اختيار القسم' : 'Please select a category')),
      );
      return;
    }

    if (_locationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'الرجاء اختيار موقع الإعلان' : 'Please select your location')),
      );
      return;
    }

    final country = context.read<CountryProvider>().currentCountry;
    final ok = await context.read<AdsProvider>().postAd(
      {
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'price': double.tryParse(_priceCtrl.text.trim()) ?? 0,
        'currency': country['currency'] ?? _currency,
        'condition': _condition,
        'category_id': targetCatId,
        'location_id': _locationId,
        'country_id': country['id'],
        'country_code': country['code'],
        'is_featured': _isFeatured,
        'is_urgent': _isUrgent,
      },
      imagePaths: _images.map((f) => f.path).toList(),
      videoPath: _video?.path,
    );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryGreen,
          content: Text(isArabic ? 'تم نشر الإعلان بنجاح!' : 'Ad posted successfully!'),
        ),
      );
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(context.read<AdsProvider>().error ?? (isArabic ? 'فشل نشر الإعلان' : 'Failed to post ad')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final cats = context.watch<CategoriesProvider>();
    final ads = context.watch<AdsProvider>();
    final subcategories = _parentCategoryId != null
        ? cats.childrenOf(_parentCategoryId!)
        : [];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: const AppBackButton(fallbackRoute: '/'),
        title: Text(
          isArabic ? 'أضف إعلانك' : context.tr('post_ad_title'),
          style: const TextStyle(color: AppTheme.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos Section (Up to 4 images)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${isArabic ? "إضافة الصور" : context.tr('add_photos')} (${_images.length}/4)',
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (_images.length < 4)
                    InkWell(
                      onTap: _pickImages,
                      child: Row(
                        children: [
                          const Icon(Icons.add_photo_alternate, size: 16, color: AppTheme.primaryBlue),
                          const SizedBox(width: 4),
                          Text(isArabic ? 'إضافة صورة' : 'Add Photo', style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Photos Grid / Row
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Render selected images
                    for (int i = 0; i < _images.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.borderLight),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_images[i], fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => setState(() => _images.removeAt(i)),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                            if (i == 0)
                              Positioned(
                                bottom: 4,
                                left: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.65),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isArabic ? 'الرئيسية' : 'Main',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                    // Add Button (if less than 4 photos)
                    if (_images.length < 4)
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.borderLight, width: 1.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_a_photo_outlined, color: AppTheme.primaryBlue, size: 24),
                              const SizedBox(height: 6),
                              Text(isArabic ? 'إضافة صورة' : 'Add Photo', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Video Section (1 optional video)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'فيديو السلعة' : 'Product Video',
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _video != null
                        ? (isArabic ? 'تمت إضافة 1/1' : '1/1 Added')
                        : (isArabic ? 'اختياري (فيديو واحد)' : 'Optional (max 1)'),
                    style: TextStyle(
                      color: _video != null ? AppTheme.primaryGreen : AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_video == null)
                GestureDetector(
                  onTap: _pickVideo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderLight, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.videocam_outlined, color: AppTheme.accentOrange, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'إضافة فيديو للمنتج' : 'Add a Product Video',
                                style: const TextStyle(color: AppTheme.textDark, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isArabic
                                    ? 'اعرض سلعتك بمقطع فيديو سريع (حتى 50 ميجابايت)'
                                    : 'Showcase your item with a quick video clip (up to 50MB)',
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.add_circle_outline, color: AppTheme.primaryBlue, size: 22),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.5), width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _video!.path.split('/').last,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppTheme.textDark, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isArabic ? 'الفيديو جاهز • معاينة بالأسفل' : 'Video ready • preview below',
                                  style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 11, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                            onPressed: () => setState(() => _video = null),
                            tooltip: isArabic ? 'حذف الفيديو' : 'Remove video',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppVideoPlayer(
                      videoFile: _video,
                      height: 180,
                    ),
                  ],
                ),
              const SizedBox(height: 22),

              // Title Field
              _buildFieldLabel('${isArabic ? "عنوان الإعلان" : context.tr('ad_title')} *'),
              TextFormField(
                controller: _titleCtrl,
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                decoration: _buildInputDecoration(hintText: isArabic ? 'مثال: آيفون 14 برو ماكس 128 جيجابايت جديد' : 'e.g. Brand new iPhone 14 Pro Max 128GB'),
                validator: (v) => v == null || v.trim().isEmpty ? (isArabic ? 'عنوان الإعلان مطلوب' : 'Title is required') : null,
              ),
              const SizedBox(height: 16),

              // Category Picker
              _buildFieldLabel('${isArabic ? "اختر القسم" : context.tr('select_category')} *'),
              DropdownButtonFormField<int>(
                dropdownColor: AppTheme.surfaceWhite,
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                value: _parentCategoryId,
                decoration: _buildInputDecoration(hintText: isArabic ? 'اختر القسم' : context.tr('select_category')),
                items: cats.topLevel.map((c) {
                  final nameAr = c['name_ar'] as String?;
                  final nameEn = c['name'] as String?;
                  final catName = isArabic ? (nameAr ?? nameEn ?? '') : (nameEn ?? nameAr ?? '');
                  final slug = (c['slug'] as String? ?? '').replaceAll('-', '_');
                  return DropdownMenuItem<int>(
                    value: c['id'] as int,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/categories/$slug.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.category_outlined,
                            size: 18,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(catName, style: const TextStyle(color: AppTheme.textDark)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _parentCategoryId = val;
                    _subCategoryId = null; // reset subcategory on parent change
                  });
                },
                validator: (v) => v == null ? (isArabic ? 'الرجاء اختيار القسم' : 'Please choose a category') : null,
              ),
              const SizedBox(height: 16),

              // Subcategory Picker (if available)
              if (subcategories.isNotEmpty) ...[
                _buildFieldLabel(isArabic ? 'القسم الفرعي *' : 'Subcategory *'),
                DropdownButtonFormField<int>(
                  dropdownColor: AppTheme.surfaceWhite,
                  style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                  value: _subCategoryId,
                  decoration: _buildInputDecoration(hintText: isArabic ? 'اختر القسم الفرعي' : context.tr('select_category')),
                  items: subcategories.map((c) {
                    final nameAr = c['name_ar'] as String?;
                    final nameEn = c['name'] as String?;
                    final subName = isArabic ? (nameAr ?? nameEn ?? '') : (nameEn ?? nameAr ?? '');
                    return DropdownMenuItem<int>(
                      value: c['id'] as int,
                      child: Text(subName, style: const TextStyle(color: AppTheme.textDark)),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _subCategoryId = val),
                  validator: (v) => v == null ? (isArabic ? 'الرجاء اختيار القسم الفرعي' : 'Please choose a subcategory') : null,
                ),
                const SizedBox(height: 16),
              ],

              // Location Picker
              _buildFieldLabel('${isArabic ? "موقع الإعلان" : context.tr('ad_location')} *'),
              DropdownButtonFormField<int>(
                dropdownColor: AppTheme.surfaceWhite,
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                value: _locationId,
                decoration: _buildInputDecoration(hintText: isArabic ? 'اختر المنطقة' : context.tr('all_districts')),
                items: cats.locations.map((l) {
                  final nameAr = l['name_ar'] as String?;
                  final nameEn = (l['display_name'] ?? l['name'] ?? '').toString();
                  final locName = isArabic ? (nameAr ?? nameEn) : nameEn;
                  return DropdownMenuItem<int>(
                    value: l['id'] as int,
                    child: Text(locName, style: const TextStyle(color: AppTheme.textDark)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _locationId = val),
                validator: (v) => v == null ? (isArabic ? 'الرجاء اختيار الموقع' : 'Please choose a location') : null,
              ),
              const SizedBox(height: 16),

              // Price & Currency Row
              _buildFieldLabel('${isArabic ? "السعر" : context.tr('ad_price')} *'),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                      decoration: _buildInputDecoration(hintText: '0.000'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return isArabic ? 'أدخل السعر' : 'Enter price';
                        if (double.tryParse(v.trim()) == null) return isArabic ? 'رقم غير صحيح' : 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: AppTheme.surfaceWhite,
                      style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                      value: _currency,
                      decoration: _buildInputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'KWD', child: Text('KWD (د.ك)', style: TextStyle(color: AppTheme.textDark))),
                        DropdownMenuItem(value: 'SAR', child: Text('SAR (ر.س)', style: TextStyle(color: AppTheme.textDark))),
                        DropdownMenuItem(value: 'AED', child: Text('AED (د.إ)', style: TextStyle(color: AppTheme.textDark))),
                        DropdownMenuItem(value: 'QAR', child: Text('QAR (ر.ق)', style: TextStyle(color: AppTheme.textDark))),
                        DropdownMenuItem(value: 'BHD', child: Text('BHD (د.ب)', style: TextStyle(color: AppTheme.textDark))),
                        DropdownMenuItem(value: 'OMR', child: Text('OMR (ر.ع)', style: TextStyle(color: AppTheme.textDark))),
                        DropdownMenuItem(value: 'USD', child: Text('USD (\$)', style: TextStyle(color: AppTheme.textDark))),
                      ],
                      onChanged: (v) => setState(() => _currency = v ?? 'KWD'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Condition
              _buildFieldLabel('${isArabic ? "حالة السلعة" : context.tr('condition')} *'),
              DropdownButtonFormField<String>(
                dropdownColor: AppTheme.surfaceWhite,
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                value: _condition,
                decoration: _buildInputDecoration(),
                items: [
                  DropdownMenuItem(value: 'used', child: Text(isArabic ? 'مستعمل' : context.tr('condition_used'), style: const TextStyle(color: AppTheme.textDark))),
                  DropdownMenuItem(value: 'new', child: Text(isArabic ? 'جديد كلياً' : context.tr('condition_new'), style: const TextStyle(color: AppTheme.textDark))),
                ],
                onChanged: (v) => setState(() => _condition = v ?? 'used'),
              ),
              const SizedBox(height: 16),

              // Description
              _buildFieldLabel('${isArabic ? "تفاصيل الإعلان" : context.tr('ad_description')} *'),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                decoration: _buildInputDecoration(hintText: isArabic ? 'اكتب تفاصيل ومواصفات السلعة هنا...' : 'Write item details and specifications here...'),
                validator: (v) => v == null || v.trim().isEmpty ? (isArabic ? 'الوصف مطلوب' : 'Description is required') : null,
              ),
              const SizedBox(height: 18),

              // Urgent & Featured Options
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight, width: 0.8),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.brandOrange,
                      title: Text(isArabic ? 'تمييز كإعلان عاجل' : 'Mark as Urgent', style: const TextStyle(color: AppTheme.textDark, fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text(isArabic ? 'يظهر مع شارة برتقالية بارزة (عاجل)' : 'Highlighted with an orange URGENT badge', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                      value: _isUrgent,
                      onChanged: (val) => setState(() => _isUrgent = val),
                    ),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.brandOrange,
                      title: Text(isArabic ? 'إعلان مميز (VIP)' : 'Feature this Ad (VIP)', style: const TextStyle(color: AppTheme.textDark, fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text(isArabic ? 'يظهر في أعلى نتائج البحث في جميع مناطق الكويت' : 'Placed at the top of searches across all Kuwait', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                      value: _isFeatured,
                      onChanged: (val) => setState(() => _isFeatured = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: ads.loading ? null : _submit,
                  child: ads.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          isArabic ? 'نشر الإعلان الآن' : context.tr('submit_ad'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(color: AppTheme.textDark, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
      filled: true,
      fillColor: AppTheme.surfaceWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.2),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }
}
