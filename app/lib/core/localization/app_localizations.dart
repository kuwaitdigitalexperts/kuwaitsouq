import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // General & Branding
      'app_name': 'سوق الكويت',
      'tagline': 'سوق الكويت الأول - بيع واشتري كل شي',
      'all_districts': 'الكويت (جميع المحافظات)',
      'currency_symbol': 'د.ك',
      'kuwaitsouq': 'سوق الكويت',

      // Navigation Bar & Drawer
      'nav_home': 'الرئيسية',
      'nav_search': 'بحث',
      'nav_post': 'أضف إعلان',
      'nav_saved': 'المفضلة',
      'nav_account': 'حسابي',
      'nav_chat': 'الرسائل',
      'menu': 'القائمة',

      // Welcome Screen
      'welcome_explore': 'تصفح سوق الكويت',
      'welcome_signin': 'تسجيل الدخول / حساب جديد',
      'buy_and_sell_kuwait': 'بيع واشتري في الكويت!',
      'local_platform': 'منصة الكويت الأولى',
      'for_better_tomorrow': 'تجارة سهلة وسريعة وآمنة',

      // Hero Banner
      'hero_title_1': 'سوق الكويت الأول',
      'hero_title_2': 'بين يديك الآن',
      'safe_transaction': 'معاملات آمنة',
      'trusted_seller': 'بائعون موثوقون',
      'districts_coverage':
          'مدينة الكويت، حولي، الفروانية، الأحمدي، الجهراء، مبارك الكبير',
      'search_hint': 'عن ماذا تبحث؟ (سيارات، عقارات، هواتف، أجهزة...)',
      'post_ad_cta':
          'انشر إعلانك مجاناً وبكل سهولة\nللوصول لآلاف المشترين فوراً',

      // Popular Categories
      'popular_categories': 'الأقسام الرئيسية',
      'view_all_categories': 'عرض جميع الأقسام',
      'cat_electronics_bn': 'إلكترونيات وأجهزة',
      'cat_electronics_en': 'Electronics',
      'cat_vehicles_bn': 'سيارات ومركبات',
      'cat_vehicles_en': 'Vehicles & Autos',
      'cat_property_bn': 'عقارات',
      'cat_property_en': 'Real Estate',
      'cat_furniture_bn': 'أثاث وديكور',
      'cat_furniture_en': 'Home & Furniture',
      'cat_services_bn': 'خدمات ومقاولات',
      'cat_services_en': 'Services',
      'cat_jobs_bn': 'وظائف وفرص عمل',
      'cat_jobs_en': 'Jobs & Careers',
      'cat_pets_bn': 'حيوانات وطيور',
      'cat_pets_en': 'Animals & Pets',
      'cat_education_bn': 'تعليم وتدريب',
      'cat_education_en': 'Education',
      'cat_fashion_bn': 'أزياء وموضة',
      'cat_fashion_en': 'Fashion & Beauty',
      'cat_sports_bn': 'رياضة ومخيمات',
      'cat_sports_en': 'Sports & Outdoors',
      'cat_matrimonial_bn': 'خدمات مناسبات',
      'cat_matrimonial_en': 'Events',
      'cat_charity_bn': 'أغراض مجانية وتبرعات',
      'cat_charity_en': 'Donations',

      // Recent Ads
      'recent_ads': 'أحدث الإعلانات',
      'see_all': 'عرض الكل',
      'badge_new': 'جديد',
      'badge_sell': 'للبيع',
      'badge_rent': 'للإيجار',
      'per_month': '/ شهرياً',
      'no_ads_found': 'لا توجد إعلانات مطابقة',

      // Auth Screen
      'welcome_to': 'مرحباً بك في',
      'login_or_signup': 'تسجيل الدخول أو إنشاء حساب',
      'enter_mobile_hint': 'أدخل رقم هاتفك للمتابعة واستلام رمز التحقق',
      'mobile_number': 'رقم الهاتف المحمول',
      'send_otp': 'إرسال رمز التحقق (OTP)',
      'enter_otp': 'أدخل رمز التحقق المكون من 6 أرقام',
      'verify_otp': 'تأكيد الرمز والمتابعة',
      'resend_otp': 'إعادة إرسال الرمز',
      'or_continue_with': 'أو المتابعة باستخدام',
      'terms_agreement': 'بمتابعتك فإنك توافق على شروط الاستخدام وسياسة الخصوصية',
      'password': 'كلمة المرور',
      'enter_password': 'أدخل كلمة المرور',
      'sign_in_password': 'الدخول بكلمة المرور',
      'sign_in_otp': 'الدخول برمز التحقق (SMS)',
      'dont_have_account': 'ليس لديك حساب؟ سجل الآن',
      'already_have_account': 'لديك حساب بالفعل؟ تسجيل الدخول',

      // Search & Filters
      'search_title': 'البحث في الإعلانات',
      'search_placeholder': 'ابحث عن سيارة، عقار، جهاز...',
      'filter': 'تصفية',
      'clear_filters': 'إعادة ضبط',
      'apply_filters': 'تطبيق الفلتر',
      'all': 'الكل',
      'sort_by': 'الترتيب حسب',
      'newest_first': 'الأحدث أولاً',
      'price_low_high': 'السعر: من الأقل للأعلى',
      'price_high_low': 'السعر: من الأعلى للأقل',
      'location': 'الموقع / المحافظة',
      'condition': 'الحالة',
      'condition_new': 'جديد',
      'condition_used': 'مستعمل',

      // Ad Details
      'posted_by': 'المعلن',
      'description': 'التفاصيل والوصف',
      'contact_seller': 'تواصل مع البائع',
      'call': 'اتصال هاتفي',
      'chat': 'محادثة فورية',
      'safety_tips': 'إرشادات الأمان للمشتري',
      'safety_tip_1': 'عاين السلعة وتأكد من سلامتها شخصياً قبل الدفع',
      'safety_tip_2': 'احرص على إجراء المقابلات في أماكن عامة ومعروفة',
      'similar_ads': 'إعلانات مشابهة',
      'share': 'مشاركة',

      // Post Ad
      'post_ad_title': 'إضافة إعلان جديد',
      'select_category': 'اختر القسم المناسب',
      'ad_title': 'عنوان الإعلان',
      'ad_description': 'وصف دقيق للسلعة أو الخدمة',
      'ad_price': 'السعر (د.ك)',
      'ad_location': 'المحافظة / المنطقة',
      'add_photos': 'إضافة صور وفيديو',
      'negotiable': 'قابل للتفاوض',
      'fixed_price': 'سعر نهائي',
      'submit_ad': 'نشر الإعلان الآن',

      // Saved & Messages
      'saved_ads_title': 'الإعلانات المحفوظة',
      'no_saved_ads': 'لم تقم بحفظ أي إعلان بعد',
      'conversations_title': 'الرسائل والمحادثات',
      'no_conversations': 'لا توجد محادثات نشطة حالياً',
      'type_message': 'اكتب رسالتك هنا...',
      'send': 'إرسال',

      // Profile & Settings
      'profile': 'الملف الشخصي',
      'my_ads': 'إعلاناتي',
      'saved_ads': 'المفضلة',
      'notifications': 'الإشعارات',
      'help_support': 'المساعدة والدعم الفني',
      'terms_privacy': 'الشروط وسياسة الخصوصية',
      'sign_in_or_register': 'تسجيل الدخول / حساب جديد',
      'guest_welcome': 'مرحباً بالزائر',
      'guest_desc': 'سجل الدخول لإدارة إعلاناتك ومحادثاتك ومتابعة المفضلة',
      'language': 'اللغة (Language)',
      'language_arabic': 'العربية (Arabic)',
      'language_english': 'English',
      'select_language': 'اختر اللغة المفضلة',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'login': 'دخول',
      'register': 'إنشاء حساب جديد',
      'logout': 'تسجيل الخروج',
      'delete_account': 'حذف الحساب نهائياً',
      'delete_account_confirm': 'هل أنت متأكد من رغبتك في حذف حسابك نهائياً؟ سيتم حذف جميع إعلاناتك ورسائلك ولا يمكن استرجاعها.',
      'delete_account_btn': 'نعم، حذف الحساب',
      'delete_account_success': 'تم حذف حسابك وجميع بياناتك بنجاح.',

      // Extra Screen & Feature Keys
      'nav_categories': 'الأقسام',
      'nav_my_ads': 'إعلاناتي',
      'categories_title': 'الأقسام والتصنيفات',
      'subcategories_title': 'التصنيفات الفرعية',
      'save_search': 'حفظ البحث (Save Search)',
      'save_search_desc': 'تنبيهي عند إضافة إعلانات جديدة في هذا القسم',
      'filter_car_make': 'تصفية سريعة بالماركة (Car Make)',
      'global_brands': 'الشركات العالمية',
      'category_results': 'نتائج البحث في الأقسام',
      'search_results': 'نتائج البحث',
      'ads_count_suffix': 'إعلان',
      'your_story': 'قصتك',
      'featured_ads_title': 'أحدث الإعلانات المميزة',
      'kuwait_and_gcc': 'كل الكويت',
      'all_cities': 'كل المناطق',
      'search_in_kuwaitsouq': 'ابحث في سوق الكويت...',
      'all_ads_in': 'جميع الإعلانات في',
      'share_copied': 'تم نسخ رابط المشاركة',
      'ad_link_copied': 'تم نسخ رابط الإعلان',
      'added_to_favorites': 'تمت إضافة الإعلان إلى المفضلة ❤️',
      'removed_from_favorites': 'تمت إزالة الإعلان من المفضلة',
      'call_seller': 'اتصال بالمعلن',
      'whatsapp_seller': 'محادثة واتساب',
      'call_action': 'اتصال',
      'whatsapp_action': 'واتساب',
      'price_drop_alert': 'تنبيه بانخفاض السعر: وفر مع هذا العرض',
      'views_title': 'المشاهدات',
      'rating_title': 'التقييم العام',
      'active_listings': 'إعلاناتي النشطة',
      'favorite_ads': 'الإعلانات المفضلة',
      'saved_drafts': 'المسودات المحفوظة',
      'saved_search_alerts': 'تنبيهات البحث المحفوظة',
      'promoted_ads': 'الإعلانات المميزة والترويج',
      'registered_listings': 'الإعلانات المسجلة',
      'account_title': 'حسابي (Account)',
      'verified_badge_title': 'احصل على شارة الحساب الموثق',
      'verified_badge_sub': 'ابنِ مصداقيتك . عزز ظهورك . اكسب ثقة المشترين',
      'quota_live_listings': 'كوتة الإعلانات النشطة (Live Listings)',
      'wallet_balance': 'رصيد المحفظة',
      'carfax_title': 'تقرير كارفكس للسيارات (CarFax)',
      'carfax_sub': 'افحص تاريخ وحوادث السيارة قبل الشراء',
      'language_label': 'اللغة (Language)',
      'country_and_city': 'المنطقة والمحافظة (مناطق الكويت)',
      'help_support_center': 'مركز المساعدة والدعم',
      'terms_privacy_policy': 'الشروط وسياسة الخصوصية',
      'time_ago': 'منذ فترة',
      'time_now': 'الآن',
      'time_hours_ago': 'منذ ساعتين',
      'featured_badge': 'مميز',
      'first_to_post_msg': 'كن أول من يضيف إعلاناً في هذا القسم أو الدولة',
      'no_ads_category_msg': 'لا توجد إعلانات مطابقة حالياً',
      'kayishha_title': 'كيّشها كاش مع كويت سوق 🚗',
      'kayishha_sub': 'احصل على أفضل سعر فوري لسيارتك الآن وبعها بدقائق',
      'kayishha_modal_title': 'كيّشها كاش مع كويت سوق 🚗',
      'kayishha_modal_sub': 'بيع سيارتك فوراً واستلم كاش خلال 24 ساعة بأعلى تقييم سوقي',
      'car_make': 'الشركة المصنعة (مثال: تويوتا، لاند كروزر)',
      'car_model': 'الموديل (الفئة)',
      'manufacture_year': 'سنة الصنع (مثال: 2024)',
      'approx_price': 'السعر المطلوب تقريبياً',
      'contact_phone': 'رقم الهاتف للتواصل واستلام العرض',
      'send_kayishha': 'إرسال طلب كيشها واستلام كاش فوري 💵',
      'specifications': 'المواصفات والتفاصيل',
      'ad_description_title': 'الوصف',
      'seller_info_title': 'معلومات المعلن',
      'member_since': 'عضو منذ',
      'verified_seller': 'بائع موثوق',
      'ask_lister': 'اسأل المعلن بنقرة واحدة (Quick Questions)',
      'safety_tip_notice': 'نصيحة أمان: عاين السلعة وتأكد منها بنفسك قبل تحويل أي مبالغ مالية.',
    },
    'en': {
      // General & Branding
      'app_name': 'KuwaitSouq',
      'tagline': "Kuwait's #1 Classifieds Marketplace",
      'all_districts': 'Kuwait (All Governorates)',
      'currency_symbol': 'KD',
      'kuwaitsouq': 'KuwaitSouq',

      // Navigation Bar & Drawer
      'nav_home': 'Home',
      'nav_search': 'Search',
      'nav_post': 'Post Ad',
      'nav_saved': 'Saved',
      'nav_account': 'Account',
      'nav_chat': 'Chat',
      'menu': 'Menu',

      // Welcome Screen
      'welcome_explore': 'Explore Marketplace',
      'welcome_signin': 'Sign In / Register',
      'buy_and_sell_kuwait': 'Buy & Sell in Kuwait!',
      'local_platform': "Kuwait's #1 Local Platform",
      'for_better_tomorrow': 'Trade Smart, Fast & Safe',

      // Hero Banner
      'hero_title_1': 'Kuwait Marketplace',
      'hero_title_2': 'In Your Pocket Today',
      'safe_transaction': 'Safe Transactions',
      'trusted_seller': 'Verified Sellers',
      'districts_coverage':
          'Kuwait City, Hawally, Farwaniya, Ahmadi, Jahra, Mubarak Al-Kabeer',
      'search_hint': 'What are you looking for? (Cars, Electronics, Properties...)',
      'post_ad_cta':
          'Post an ad for your items,\nservices or business easily',

      // Popular Categories
      'popular_categories': 'Popular Categories',
      'view_all_categories': 'View All Categories',
      'cat_electronics_bn': 'Electronics',
      'cat_electronics_en': 'Electronics',
      'cat_vehicles_bn': 'Cars & Vehicles',
      'cat_vehicles_en': 'Vehicles & Autos',
      'cat_property_bn': 'Real Estate',
      'cat_property_en': 'Real Estate',
      'cat_furniture_bn': 'Furniture & Home',
      'cat_furniture_en': 'Home & Furniture',
      'cat_services_bn': 'Services & Contractors',
      'cat_services_en': 'Services',
      'cat_jobs_bn': 'Jobs & Careers',
      'cat_jobs_en': 'Jobs & Careers',
      'cat_pets_bn': 'Animals & Pets',
      'cat_pets_en': 'Animals & Pets',
      'cat_education_bn': 'Education & Courses',
      'cat_education_en': 'Education',
      'cat_fashion_bn': 'Fashion & Clothing',
      'cat_fashion_en': 'Fashion & Beauty',
      'cat_sports_bn': 'Sports & Camping',
      'cat_sports_en': 'Sports & Outdoors',
      'cat_matrimonial_bn': 'Events & Weddings',
      'cat_matrimonial_en': 'Events',
      'cat_charity_bn': 'Donations & Free Items',
      'cat_charity_en': 'Donations',

      // Recent Ads
      'recent_ads': 'Recent Ads',
      'see_all': 'See All',
      'badge_new': 'New',
      'badge_sell': 'For Sale',
      'badge_rent': 'Rent',
      'per_month': '/ mo',
      'no_ads_found': 'No ads found matching your criteria',

      // Auth Screen
      'welcome_to': 'Welcome to',
      'login_or_signup': 'Login or Sign Up',
      'enter_mobile_hint': 'Enter your mobile number to receive OTP',
      'mobile_number': 'Mobile Number',
      'send_otp': 'Send OTP',
      'enter_otp': 'Enter 6-digit OTP Code',
      'verify_otp': 'Verify OTP',
      'resend_otp': 'Resend OTP',
      'or_continue_with': 'Or continue with',
      'terms_agreement': 'By continuing, you agree to our Terms & Privacy Policy',
      'password': 'Password',
      'enter_password': 'Enter password',
      'sign_in_password': 'Sign In with Password',
      'sign_in_otp': 'Sign In with OTP',
      'dont_have_account': "Don't have an account? Sign up",
      'already_have_account': 'Already have an account? Sign in',

      // Search & Filters
      'search_title': 'Search Ads',
      'search_placeholder': 'Search cars, properties, phones...',
      'filter': 'Filter',
      'clear_filters': 'Reset Filters',
      'apply_filters': 'Apply Filters',
      'all': 'All',
      'sort_by': 'Sort By',
      'newest_first': 'Newest First',
      'price_low_high': 'Price: Low to High',
      'price_high_low': 'Price: High to Low',
      'location': 'Location / Governorate',
      'condition': 'Condition',
      'condition_new': 'New',
      'condition_used': 'Used',

      // Ad Details
      'posted_by': 'Advertiser',
      'description': 'Description & Specs',
      'contact_seller': 'Contact Seller',
      'call': 'Phone Call',
      'chat': 'Instant Chat',
      'safety_tips': 'Safety Guidelines',
      'safety_tip_1': 'Inspect the item thoroughly before making payment',
      'safety_tip_2': 'Always meet in a secure, public location',
      'similar_ads': 'Similar Listings',
      'share': 'Share',

      // Post Ad
      'post_ad_title': 'Post an Ad',
      'select_category': 'Select Category',
      'ad_title': 'Ad Title',
      'ad_description': 'Detailed Description',
      'ad_price': 'Price (KD)',
      'ad_location': 'Governorate / Area',
      'add_photos': 'Add Photos & Video',
      'negotiable': 'Negotiable',
      'fixed_price': 'Fixed Price',
      'submit_ad': 'Publish Ad Now',

      // Saved & Messages
      'saved_ads_title': 'Saved Ads',
      'no_saved_ads': 'No saved ads yet',
      'conversations_title': 'Messages & Chats',
      'no_conversations': 'No active conversations yet',
      'type_message': 'Type your message...',
      'send': 'Send',

      // Profile & Settings
      'profile': 'My Profile',
      'my_ads': 'My Listings',
      'saved_ads': 'Favorites & Saved',
      'notifications': 'Notifications',
      'help_support': 'Help & Support',
      'terms_privacy': 'Terms & Privacy Policy',
      'sign_in_or_register': 'Sign In or Register',
      'guest_welcome': 'Welcome, Guest',
      'guest_desc': 'Sign in to manage your listings, chats, and favorites',
      'language': 'Language (اللغة)',
      'language_arabic': 'العربية (Arabic)',
      'language_english': 'English',
      'select_language': 'Select Preferred Language',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'login': 'Login',
      'register': 'Create Account',
      'logout': 'Log Out',
      'delete_account': 'Delete Account',
      'delete_account_confirm': 'Are you sure you want to permanently delete your account? All your ads, messages, and profile data will be permanently removed. This action cannot be undone.',
      'delete_account_btn': 'Delete Permanently',
      'delete_account_success': 'Your account and all associated data have been permanently deleted.',

      // Extra Screen & Feature Keys
      'nav_categories': 'Categories',
      'nav_my_ads': 'My Listings',
      'categories_title': 'Categories & Classifications',
      'subcategories_title': 'Subcategories',
      'save_search': 'Save Search',
      'save_search_desc': 'Alert me when new listings are added here',
      'filter_car_make': 'Quick Filter by Car Make',
      'global_brands': 'Global Brands',
      'category_results': 'Category Listings',
      'search_results': 'Search Results',
      'ads_count_suffix': 'Ads',
      'your_story': 'Your Story',
      'featured_ads_title': 'Latest Featured Ads',
      'kuwait_and_gcc': 'All Kuwait',
      'all_cities': 'All Areas',
      'search_in_kuwaitsouq': 'Search KuwaitSouq...',
      'all_ads_in': 'All listings in',
      'share_copied': 'Share link copied to clipboard',
      'ad_link_copied': 'Listing link copied to clipboard',
      'added_to_favorites': 'Added to favorites ❤️',
      'removed_from_favorites': 'Removed from favorites',
      'call_seller': 'Call Seller',
      'whatsapp_seller': 'WhatsApp Chat',
      'call_action': 'Call',
      'whatsapp_action': 'WhatsApp',
      'price_drop_alert': 'Price Drop Alert: Save on this deal',
      'views_title': 'Views',
      'rating_title': 'Overall Rating',
      'active_listings': 'Active Listings',
      'favorite_ads': 'Favorite Listings',
      'saved_drafts': 'Saved Drafts',
      'saved_search_alerts': 'Saved Search Alerts',
      'promoted_ads': 'Boosted & Promoted Ads',
      'registered_listings': 'Registered Listings',
      'account_title': 'My Account',
      'verified_badge_title': 'Get Verified Seller Badge',
      'verified_badge_sub': 'Build trust . Boost visibility . Win buyers',
      'quota_live_listings': 'Live Listings Quota',
      'wallet_balance': 'Wallet Balance',
      'carfax_title': 'CarFax Vehicle Report',
      'carfax_sub': 'Check accident and vehicle history before buying',
      'language_label': 'Language (اللغة)',
      'country_and_city': 'Kuwait Area & Region',
      'help_support_center': 'Help & Support Center',
      'terms_privacy_policy': 'Terms & Privacy Policy',
      'time_ago': 'Recently',
      'time_now': 'Just Now',
      'time_hours_ago': '2 hours ago',
      'featured_badge': 'Featured',
      'first_to_post_msg': 'Be the first to post a listing in this category or country',
      'no_ads_category_msg': 'No matching listings found',
      'kayishha_title': 'Instant Cash with KuwaitSouq 🚗',
      'kayishha_sub': 'Get the best cash offer for your car in minutes',
      'kayishha_modal_title': 'Instant Cash with KuwaitSouq 🚗',
      'kayishha_modal_sub': 'Sell your car instantly and get cash within 24 hours at the highest valuation',
      'car_make': 'Car Make (e.g. Toyota, Land Cruiser)',
      'car_model': 'Model / Trim',
      'manufacture_year': 'Year of Manufacture (e.g. 2024)',
      'approx_price': 'Desired Price',
      'contact_phone': 'Contact phone to receive offer',
      'send_kayishha': 'Submit Request & Get Instant Cash 💵',
      'specifications': 'Specifications & Details',
      'ad_description_title': 'Description',
      'seller_info_title': 'Seller Information',
      'member_since': 'Member since',
      'verified_seller': 'Verified Seller',
      'ask_lister': 'Quick Questions for Lister',
      'safety_tip_notice': 'Safety tip: Inspect the item thoroughly before transferring any payment.',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _localizedValues[langCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this).translate(key);
  }

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
