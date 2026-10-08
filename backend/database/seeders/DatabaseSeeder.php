<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Country;
use App\Models\City;
use App\Models\Neighborhood;
use App\Models\Category;
use App\Models\CategoryFilter;
use App\Models\CategoryFilterOption;
use App\Models\Ad;
use App\Models\AdMedia;
use App\Models\SellerStory;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Seed Countries (Gulf Countries)
        $countriesData = [
            [
                'name' => 'Kuwait',
                'name_ar' => 'الكويت',
                'code' => 'KW',
                'phone_code' => '+965',
                'currency' => 'KWD',
                'currency_ar' => 'د.ك',
                'flag' => '🇰🇼',
                'is_default' => true,
                'pos' => 1,
            ],
            [
                'name' => 'Saudi Arabia',
                'name_ar' => 'المملكة العربية السعودية',
                'code' => 'SA',
                'phone_code' => '+966',
                'currency' => 'SAR',
                'currency_ar' => 'ر.س',
                'flag' => '🇸🇦',
                'is_default' => false,
                'pos' => 2,
            ],
            [
                'name' => 'United Arab Emirates',
                'name_ar' => 'الإمارات العربية المتحدة',
                'code' => 'AE',
                'phone_code' => '+971',
                'currency' => 'AED',
                'currency_ar' => 'د.إ',
                'flag' => '🇦🇪',
                'is_default' => false,
                'pos' => 3,
            ],
            [
                'name' => 'Qatar',
                'name_ar' => 'قطر',
                'code' => 'QA',
                'phone_code' => '+974',
                'currency' => 'QAR',
                'currency_ar' => 'ر.ق',
                'flag' => '🇶🇦',
                'is_default' => false,
                'pos' => 4,
            ],
            [
                'name' => 'Bahrain',
                'name_ar' => 'البحرين',
                'code' => 'BH',
                'phone_code' => '+973',
                'currency' => 'BHD',
                'currency_ar' => 'د.ب',
                'flag' => '🇧🇭',
                'is_default' => false,
                'pos' => 5,
            ],
            [
                'name' => 'Oman',
                'name_ar' => 'سلطنة عمان',
                'code' => 'OM',
                'phone_code' => '+968',
                'currency' => 'OMR',
                'currency_ar' => 'ر.ع',
                'flag' => '🇴🇲',
                'is_default' => false,
                'pos' => 6,
            ],
        ];

        $countries = [];
        foreach ($countriesData as $c) {
            $countries[$c['code']] = Country::create($c);
        }

        // 2. Seed Cities & Neighborhoods
        // Kuwait Cities
        $kwCities = [
            ['name' => 'Kuwait City', 'name_ar' => 'مدينة الكويت', 'pos' => 1],
            ['name' => 'Hawally', 'name_ar' => 'حولي', 'pos' => 2],
            ['name' => 'Salmiya', 'name_ar' => 'السالمية', 'pos' => 3],
            ['name' => 'Al Farwaniyah', 'name_ar' => 'الفروانية', 'pos' => 4],
            ['name' => 'Al Ahmadi', 'name_ar' => 'الأحمدي', 'pos' => 5],
            ['name' => 'Al Jahra', 'name_ar' => 'الجهراء', 'pos' => 6],
            ['name' => 'Mubarak Al-Kabeer', 'name_ar' => 'مبارك الكبير', 'pos' => 7],
        ];
        foreach ($kwCities as $c) {
            $city = $countries['KW']->cities()->create($c);
            if ($c['name'] === 'Kuwait City') {
                $city->neighborhoods()->createMany([
                    ['name' => 'Sharq', 'name_ar' => 'شرق', 'pos' => 1],
                    ['name' => 'Mirqab', 'name_ar' => 'المرقاب', 'pos' => 2],
                    ['name' => 'Dasman', 'name_ar' => 'دسمان', 'pos' => 3],
                    ['name' => 'Shuwaikh', 'name_ar' => 'الشويخ', 'pos' => 4],
                ]);
            }
        }

        // Saudi Arabia Cities
        $saCities = [
            ['name' => 'Al Riyadh', 'name_ar' => 'الرياض', 'pos' => 1],
            ['name' => 'Jeddah', 'name_ar' => 'جدة', 'pos' => 2],
            ['name' => 'Dammam', 'name_ar' => 'الدمام', 'pos' => 3],
            ['name' => 'Mecca', 'name_ar' => 'مكة المكرمة', 'pos' => 4],
            ['name' => 'Medina', 'name_ar' => 'المدينة المنورة', 'pos' => 5],
            ['name' => 'Al Khobar', 'name_ar' => 'الخبر', 'pos' => 6],
        ];
        $riyadhCity = null;
        foreach ($saCities as $c) {
            $city = $countries['SA']->cities()->create($c);
            if ($c['name'] === 'Al Riyadh') {
                $riyadhCity = $city;
                $city->neighborhoods()->createMany([
                    ['name' => 'Al Munsiyah', 'name_ar' => 'المنسية', 'pos' => 1],
                    ['name' => 'Al Malaz', 'name_ar' => 'الملز', 'pos' => 2],
                    ['name' => 'Al Olaya', 'name_ar' => 'العليا', 'pos' => 3],
                    ['name' => 'Al Narjis', 'name_ar' => 'النرجس', 'pos' => 4],
                    ['name' => 'Al Yasmin', 'name_ar' => 'الياسمين', 'pos' => 5],
                ]);
            }
        }

        // UAE Cities
        $uaeCities = [
            ['name' => 'Dubai', 'name_ar' => 'دبي', 'pos' => 1],
            ['name' => 'Abu Dhabi', 'name_ar' => 'أبوظبي', 'pos' => 2],
            ['name' => 'Sharjah', 'name_ar' => 'الشارقة', 'pos' => 3],
            ['name' => 'Ajman', 'name_ar' => 'عجمان', 'pos' => 4],
        ];
        foreach ($uaeCities as $c) {
            $countries['AE']->cities()->create($c);
        }

        // Qatar Cities
        $qaCities = [
            ['name' => 'Doha', 'name_ar' => 'الدوحة', 'pos' => 1],
            ['name' => 'Al Rayyan', 'name_ar' => 'الريان', 'pos' => 2],
            ['name' => 'Al Wakrah', 'name_ar' => 'الوكرة', 'pos' => 3],
        ];
        foreach ($qaCities as $c) {
            $countries['QA']->cities()->create($c);
        }

        // Bahrain Cities
        $bhCities = [
            ['name' => 'Manama', 'name_ar' => 'المنامة', 'pos' => 1],
            ['name' => 'Riffa', 'name_ar' => 'الرفاع', 'pos' => 2],
            ['name' => 'Muharraq', 'name_ar' => 'المحرق', 'pos' => 3],
        ];
        foreach ($bhCities as $c) {
            $countries['BH']->cities()->create($c);
        }

        // Oman Cities
        $omCities = [
            ['name' => 'Muscat', 'name_ar' => 'مسقط', 'pos' => 1],
            ['name' => 'Salalah', 'name_ar' => 'صلالة', 'pos' => 2],
            ['name' => 'Sohar', 'name_ar' => 'صحار', 'pos' => 3],
        ];
        foreach ($omCities as $c) {
            $countries['OM']->cities()->create($c);
        }

        // 3. Seed Users
        // Admin
        $admin = User::create([
            'name' => 'KuwaitSouq Admin',
            'email' => 'admin@kuwaitsouq.com',
            'phone' => '99001122',
            'phone_code' => '+965',
            'password' => Hash::make('password123'),
            'is_admin' => true,
            'is_verified' => true,
            'member_type' => 'Admin',
            'member_id_number' => '10000001',
            'member_since' => Carbon::parse('2024-01-01'),
            'live_listings_limit' => 500,
            'rating' => 5.0,
            'rating_count' => 12,
            'listing_credits' => 100,
            'vas_credits' => 50,
            'cv_completeness' => 100,
            'cv_views' => 25,
            'job_applications_count' => 0,
            'member_views' => 1400,
            'whatsapp' => '+96599001122',
        ]);

        // Verified Seller: "Al Ghanim global" from Screenshot 11
        $sellerAlGhanim = User::create([
            'name' => 'Al Ghanim global',
            'email' => 'alghanim@kuwaitsouq.com',
            'phone' => '0504880922',
            'phone_code' => '+966',
            'password' => Hash::make('password123'),
            'is_admin' => false,
            'is_verified' => true,
            'member_type' => 'Free Member',
            'member_id_number' => '81355485',
            'member_since' => Carbon::parse('2026-05-01'),
            'live_listings_limit' => 20,
            'rating' => 0.0,
            'rating_count' => 0,
            'listing_credits' => 2,
            'vas_credits' => 1,
            'cv_completeness' => 0,
            'cv_views' => 0,
            'job_applications_count' => 0,
            'member_views' => 416,
            'whatsapp' => '+966504880922',
        ]);

        // Standard User: Abu Fahad from Screenshot 7
        $userAbuFahad = User::create([
            'name' => 'Abu Fahad',
            'email' => 'fahad@kuwaitsouq.com',
            'phone' => '0504880988',
            'phone_code' => '+966',
            'password' => Hash::make('password123'),
            'is_admin' => false,
            'is_verified' => false,
            'member_type' => 'Free Member',
            'member_id_number' => '28794008',
            'member_since' => Carbon::parse('2016-08-17'),
            'live_listings_limit' => 20,
            'rating' => 4.8,
            'rating_count' => 18,
            'listing_credits' => 0,
            'vas_credits' => 0,
            'cv_completeness' => 30,
            'cv_views' => 5,
            'job_applications_count' => 1,
            'member_views' => 150,
            'whatsapp' => '+966504880988',
        ]);

        // 4. Seed Categories & Subcategories
        // Main Category: Autos (سيارات ومركبات)
        $catAutos = Category::create([
            'name' => 'Autos',
            'name_ar' => 'سيارات ومركبات',
            'slug' => 'autos',
            'icon' => 'car',
            'pos' => 1,
            'is_active' => true,
        ]);

        // Subcategories of Autos (matching Screenshot 1)
        $subCarsForSale = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Cars For Sale',
            'name_ar' => 'سيارات للبيع',
            'slug' => 'cars-for-sale',
            'icon' => 'car',
            'pos' => 1,
            'is_active' => true,
        ]);

        $subVehicleAcc = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Vehicle Accessories',
            'name_ar' => 'إكسسوارات وقطع غيار',
            'slug' => 'vehicle-accessories',
            'icon' => 'steering-wheel',
            'pos' => 2,
            'is_active' => true,
        ]);

        $subAutosForRent = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Autos for Rent',
            'name_ar' => 'سيارات للإيجار',
            'slug' => 'autos-for-rent',
            'icon' => 'car-key',
            'pos' => 3,
            'is_active' => true,
        ]);

        $subHeavyMachinery = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Heavy Machinery',
            'name_ar' => 'آليات ومعدات ثقيلة',
            'slug' => 'heavy-machinery',
            'icon' => 'bulldozer',
            'pos' => 4,
            'is_active' => true,
        ]);

        $subVehicleSpare = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Vehicle Spare Parts',
            'name_ar' => 'قطع غيار سيارات',
            'slug' => 'vehicle-spare-parts',
            'icon' => 'brake-disk',
            'pos' => 5,
            'is_active' => true,
        ]);

        $subPlateNumbers = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Plate Numbers',
            'name_ar' => 'لوحات مميزة',
            'slug' => 'plate-numbers',
            'icon' => 'license-plate',
            'pos' => 6,
            'is_active' => true,
        ]);

        $subQuadBikes = Category::create([
            'parent_id' => $catAutos->id,
            'name' => 'Quad Bikes, Buggies And ATV',
            'name_ar' => 'دبابات وبجي وسكوترات',
            'slug' => 'quad-bikes-buggies-atv',
            'icon' => 'motorcycle',
            'pos' => 7,
            'is_active' => true,
        ]);

        // Other Core Categories
        Category::create([
            'name' => 'Real Estate',
            'name_ar' => 'عقارات',
            'slug' => 'real-estate',
            'icon' => 'home',
            'pos' => 2,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Electronics',
            'name_ar' => 'إلكترونيات',
            'slug' => 'electronics',
            'icon' => 'mobile',
            'pos' => 3,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Jobs',
            'name_ar' => 'وظائف',
            'slug' => 'jobs',
            'icon' => 'briefcase',
            'pos' => 4,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Services',
            'name_ar' => 'خدمات',
            'slug' => 'services',
            'icon' => 'tools',
            'pos' => 5,
            'is_active' => true,
        ]);

        // 5. Seed Dynamic Filters for Autos & Cars For Sale
        // Filter 1: Condition
        $filterCondition = CategoryFilter::create([
            'category_id' => $catAutos->id,
            'name' => 'Condition',
            'name_ar' => 'الحالة',
            'filter_key' => 'condition',
            'type' => 'pills',
            'is_pinned' => true,
            'pos' => 1,
        ]);
        $filterCondition->options()->createMany([
            ['label' => 'Used', 'label_ar' => 'مستعمل', 'value' => 'used', 'pos' => 1],
            ['label' => 'New', 'label_ar' => 'جديد', 'value' => 'new', 'pos' => 2],
        ]);

        // Filter 2: Car Make (with Brand Logo Quick Cards from Screenshot 2)
        $filterMake = CategoryFilter::create([
            'category_id' => $catAutos->id,
            'name' => 'Car Make',
            'name_ar' => 'الشركة المصنعة',
            'filter_key' => 'car_make',
            'type' => 'brands_grid',
            'is_pinned' => true,
            'pos' => 2,
        ]);

        $brands = [
            ['label' => 'Toyota', 'label_ar' => 'تويوتا', 'value' => 'toyota', 'is_quick_card' => true, 'pos' => 1],
            ['label' => 'Ford', 'label_ar' => 'فورد', 'value' => 'ford', 'is_quick_card' => true, 'pos' => 2],
            ['label' => 'Chevrolet', 'label_ar' => 'شفروليه', 'value' => 'chevrolet', 'is_quick_card' => true, 'pos' => 3],
            ['label' => 'MG', 'label_ar' => 'إم جي', 'value' => 'mg', 'is_quick_card' => true, 'pos' => 4],
            ['label' => 'Hyundai', 'label_ar' => 'هيونداي', 'value' => 'hyundai', 'is_quick_card' => true, 'pos' => 5],
            ['label' => 'Kia', 'label_ar' => 'كيا', 'value' => 'kia', 'is_quick_card' => true, 'pos' => 6],
            ['label' => 'Nissan', 'label_ar' => 'نيسان', 'value' => 'nissan', 'is_quick_card' => true, 'pos' => 7],
            ['label' => 'Haval', 'label_ar' => 'هافال', 'value' => 'haval', 'is_quick_card' => true, 'pos' => 8],
            ['label' => 'Mercedes', 'label_ar' => 'مرسيدس', 'value' => 'mercedes', 'is_quick_card' => true, 'pos' => 9],
            ['label' => 'BMW', 'label_ar' => 'بي إم دبليو', 'value' => 'bmw', 'is_quick_card' => true, 'pos' => 10],
            ['label' => 'Lexus', 'label_ar' => 'لكزس', 'value' => 'lexus', 'is_quick_card' => true, 'pos' => 11],
        ];
        foreach ($brands as $b) {
            $filterMake->options()->create($b);
        }

        // Filter 3: Model
        $filterModel = CategoryFilter::create([
            'category_id' => $catAutos->id,
            'name' => 'Model',
            'name_ar' => 'الموديل',
            'filter_key' => 'model',
            'type' => 'select',
            'is_pinned' => true,
            'pos' => 3,
        ]);
        $filterModel->options()->createMany([
            ['label' => 'Land Cruiser', 'label_ar' => 'لاند كروزر', 'value' => 'land_cruiser', 'pos' => 1],
            ['label' => 'Camry', 'label_ar' => 'كامري', 'value' => 'camry', 'pos' => 2],
            ['label' => 'F-150', 'label_ar' => 'إف-150', 'value' => 'f150', 'pos' => 3],
            ['label' => 'Patrol', 'label_ar' => 'باترول', 'value' => 'patrol', 'pos' => 4],
            ['label' => 'Tahoe', 'label_ar' => 'تاهو', 'value' => 'tahoe', 'pos' => 5],
        ]);

        // Filter 4: Transmission
        $filterTransmission = CategoryFilter::create([
            'category_id' => $catAutos->id,
            'name' => 'Transmission',
            'name_ar' => 'ناقل الحركة',
            'filter_key' => 'transmission',
            'type' => 'pills',
            'is_pinned' => true,
            'pos' => 4,
        ]);
        $filterTransmission->options()->createMany([
            ['label' => 'Automatic', 'label_ar' => 'أوتوماتيك', 'value' => 'automatic', 'pos' => 1],
            ['label' => 'Manual', 'label_ar' => 'يدوي', 'value' => 'manual', 'pos' => 2],
        ]);

        // 6. Seed Sample Ads (Exact matches to screenshots!)
        // Ad 1: Mini Golf Scooter (Screenshots 1, 3, 4, 5)
        $munsiyah = $riyadhCity ? $riyadhCity->neighborhoods()->where('name', 'Al Munsiyah')->first() : null;

        $ad1 = Ad::create([
            'user_id' => $sellerAlGhanim->id,
            'category_id' => $catAutos->id,
            'sub_category_id' => $subQuadBikes->id,
            'country_id' => $countries['SA']->id,
            'city_id' => $riyadhCity ? $riyadhCity->id : 1,
            'neighborhood_id' => $munsiyah ? $munsiyah->id : null,
            'neighborhood_name' => 'Al Munsiyah',
            'title' => 'Mini Golf 4-Wheel Scooter',
            'title_ar' => 'ميني جولف سكوتر رباعي',
            'description' => 'The cart is excellent for resorts, gated communities (compounds), and parks. It accommodates 3 passengers and features a second auxiliary battery installed to increase the driving distance and double operating time.',
            'description_ar' => 'العربة ممتازة للمنتجعات، المجمعات المغلقة (الكمباوند)، والمنتزهات. تتسع لـ 3 ركاب وتتميز بوجود بطارية ثانية إضافية تم تركيبها لزيادة المسافة المقطوعة ومضاعفة وقت التشغيل.',
            'price' => 3800.00,
            'currency' => 'SAR',
            'condition' => 'used',
            'attributes' => [
                'condition' => 'used',
                'color' => 'Turquoise Blue',
                'battery' => 'Dual Electric Battery',
                'capacity' => '3 Passengers',
            ],
            'phone' => '0504880922',
            'whatsapp' => '+966504880922',
            'is_boosted' => true,
            'is_featured' => true,
            'views_count' => 416,
            'favorites_count' => 3,
            'status' => 'active',
            'published_at' => Carbon::now()->subHours(3),
        ]);

        // Add media for Ad 1 (17 photos, 1 video)
        $ad1->media()->createMany([
            ['type' => 'image', 'file_path' => 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800', 'is_primary' => true, 'pos' => 1],
            ['type' => 'image', 'file_path' => 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800', 'is_primary' => false, 'pos' => 2],
            ['type' => 'image', 'file_path' => 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=800', 'is_primary' => false, 'pos' => 3],
            ['type' => 'video', 'file_path' => 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4', 'is_primary' => false, 'pos' => 4],
        ]);

        // Ad 2: Tornado Bicycle (Screenshot 6)
        $ad2 = Ad::create([
            'user_id' => $userAbuFahad->id,
            'category_id' => $catAutos->id,
            'sub_category_id' => $subQuadBikes->id,
            'country_id' => $countries['SA']->id,
            'city_id' => $riyadhCity ? $riyadhCity->id : 1,
            'neighborhood_name' => 'Al Malaz',
            'title' => 'TORNADO Bicycle For Sale on Offer',
            'title_ar' => 'للبيع سيكل دراجة هوائية TORNADO على السوم',
            'description' => 'Original high performance Tornado sports bicycle in very good condition with speed gears.',
            'description_ar' => 'دراجة هوائية رياضية تورنادو أصلية بحالة ممتازة مع سرعات متعددة وفرامل قرصية.',
            'price' => 450.00,
            'currency' => 'SAR',
            'condition' => 'used',
            'attributes' => ['condition' => 'used', 'brand' => 'Tornado'],
            'phone' => '0504880988',
            'whatsapp' => '+966504880988',
            'is_boosted' => false,
            'is_featured' => false,
            'views_count' => 180,
            'favorites_count' => 5,
            'status' => 'active',
            'published_at' => Carbon::now()->subHours(5),
        ]);
        $ad2->media()->create([
            'type' => 'image',
            'file_path' => 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=800',
            'is_primary' => true,
            'pos' => 1,
        ]);

        // Ad 3: Sports Bicycle Large (Screenshot 6)
        $ad3 = Ad::create([
            'user_id' => $userAbuFahad->id,
            'category_id' => $catAutos->id,
            'sub_category_id' => $subQuadBikes->id,
            'country_id' => $countries['SA']->id,
            'city_id' => $riyadhCity ? $riyadhCity->id : 1,
            'neighborhood_name' => 'Al Olaya',
            'title' => 'Large Sports Bicycle',
            'title_ar' => 'سيكل رياضي كبير',
            'description' => 'Large sports bicycle with shock absorbers.',
            'description_ar' => 'دراجة رياضية مقاس كبير مع ممتص صدمات وسرعات.',
            'price' => 600.00,
            'currency' => 'SAR',
            'condition' => 'used',
            'attributes' => ['condition' => 'used'],
            'phone' => '0504880988',
            'whatsapp' => '+966504880988',
            'is_boosted' => false,
            'is_featured' => false,
            'views_count' => 95,
            'favorites_count' => 2,
            'status' => 'active',
            'published_at' => Carbon::now()->subHours(6),
        ]);
        $ad3->media()->create([
            'type' => 'image',
            'file_path' => 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?w=800',
            'is_primary' => true,
            'pos' => 1,
        ]);

        // Ad 4: Adly ATV-100V RS Taiwanese Quad bike (Screenshot 6)
        $ad4 = Ad::create([
            'user_id' => $sellerAlGhanim->id,
            'category_id' => $catAutos->id,
            'sub_category_id' => $subQuadBikes->id,
            'country_id' => $countries['SA']->id,
            'city_id' => $riyadhCity ? $riyadhCity->id : 1,
            'neighborhood_name' => 'Al Narjis',
            'title' => 'Adly ATV-100V RS Taiwanese Quad bike',
            'title_ar' => 'دباب ادلي تايواني Adly ATV-100V RS',
            'description' => 'Original Taiwanese Adly ATV-100V RS quad bike in mint condition.',
            'description_ar' => 'دباب ادلي تايواني اصلي موديل Adly ATV-100V RS قمة بالنظافة وتشغيل سلف.',
            'price' => 2200.00,
            'currency' => 'SAR',
            'condition' => 'used',
            'attributes' => ['condition' => 'used', 'make' => 'Adly', 'engine' => '100cc'],
            'phone' => '0504880922',
            'whatsapp' => '+966504880922',
            'is_boosted' => true,
            'is_featured' => true,
            'views_count' => 310,
            'favorites_count' => 8,
            'status' => 'active',
            'published_at' => Carbon::now()->subDay(),
        ]);
        $ad4->media()->create([
            'type' => 'image',
            'file_path' => 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800',
            'is_primary' => true,
            'pos' => 1,
        ]);

        // Ad 5: Kuwait Listing - Toyota Land Cruiser 2024
        $kwCity = $countries['KW']->cities()->first();
        $adKw = Ad::create([
            'user_id' => $admin->id,
            'category_id' => $catAutos->id,
            'sub_category_id' => $subCarsForSale->id,
            'country_id' => $countries['KW']->id,
            'city_id' => $kwCity ? $kwCity->id : 1,
            'neighborhood_name' => 'Shuwaikh',
            'title' => 'Toyota Land Cruiser VXR 2024 Kuwait Agency',
            'title_ar' => 'تويوتا لاند كروزر VXR 2024 وكالة الساير الكويت',
            'description' => 'Full option, 0 km, Sunroof, Leather seats, 360 Camera, 5-year warranty.',
            'description_ar' => 'كامل المواصفات، عداد صفر، فتحة سقف، جلد، كاميرات 360، كفالة الساير 5 سنوات.',
            'price' => 26500.00,
            'currency' => 'KWD',
            'condition' => 'new',
            'attributes' => [
                'car_make' => 'toyota',
                'model' => 'land_cruiser',
                'year' => '2024',
                'transmission' => 'automatic',
                'condition' => 'new',
            ],
            'phone' => '99001122',
            'whatsapp' => '+96599001122',
            'is_boosted' => true,
            'is_featured' => true,
            'views_count' => 890,
            'favorites_count' => 45,
            'status' => 'active',
            'published_at' => Carbon::now()->subHours(2),
        ]);
        $adKw->media()->create([
            'type' => 'image',
            'file_path' => 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800',
            'is_primary' => true,
            'pos' => 1,
        ]);

        // 7. Seed Seller Stories (Gradient Ring Avatars as in Screenshot 1 & 2)
        SellerStory::create([
            'user_id' => $sellerAlGhanim->id,
            'ad_id' => $ad1->id,
            'media_path' => 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500',
            'caption' => 'عرض خاص على السكوترات الميني جولف',
            'ring_color' => 'orange',
            'expires_at' => Carbon::now()->addHours(20),
            'is_active' => true,
        ]);

        SellerStory::create([
            'user_id' => $userAbuFahad->id,
            'ad_id' => $ad2->id,
            'media_path' => 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=500',
            'caption' => 'دراجات رياضية أصلية',
            'ring_color' => 'green',
            'expires_at' => Carbon::now()->addHours(18),
            'is_active' => true,
        ]);

        SellerStory::create([
            'user_id' => $admin->id,
            'ad_id' => $adKw->id,
            'media_path' => 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=500',
            'caption' => 'لاندكروزر 2024 جديد بالكويت',
            'ring_color' => 'blue',
            'expires_at' => Carbon::now()->addHours(24),
            'is_active' => true,
        ]);
    }
}
