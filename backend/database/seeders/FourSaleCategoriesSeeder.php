<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class FourSaleCategoriesSeeder extends Seeder
{
    /**
     * Seed all 24 4Sale Kuwait main categories with accurate 3D icons and subcategories.
     */
    public function run(): void
    {
        $categories = [
            [
                'id' => 13,
                'slug' => 'commercial-ads',
                'name' => 'Commercial Ads',
                'name_ar' => 'إعلانات تجارية',
                'icon' => 'commercial_ads.png',
                'pos' => 1,
                'subcategories' => [
                    ['slug' => 'featured-companies', 'name' => 'Featured Companies', 'name_ar' => 'شركات مميزة'],
                    ['slug' => 'business-offers', 'name' => 'Business Offers', 'name_ar' => 'عروض تجارية'],
                    ['slug' => 'franchise-opportunities', 'name' => 'Franchise Opportunities', 'name_ar' => 'فرص امتياز تجاري'],
                ],
            ],
            [
                'id' => 14,
                'slug' => 'shops',
                'name' => 'Shops',
                'name_ar' => 'محلات ومتاجر',
                'icon' => 'shops.png',
                'pos' => 2,
                'subcategories' => [
                    ['slug' => 'retail-stores', 'name' => 'Retail Stores', 'name_ar' => 'محلات تجزئة'],
                    ['slug' => 'online-boutiques', 'name' => 'Online Boutiques', 'name_ar' => 'متاجر إلكترونية'],
                    ['slug' => 'wholesale-shops', 'name' => 'Wholesale Shops', 'name_ar' => 'محلات جملة'],
                ],
            ],
            [
                'id' => 1,
                'slug' => 'autos',
                'name' => 'Autos',
                'name_ar' => 'سيارات',
                'icon' => 'autos.png',
                'pos' => 3,
                'subcategories' => [
                    ['slug' => 'cars-for-sale', 'name' => 'Cars For Sale', 'name_ar' => 'سيارات للبيع'],
                    ['slug' => 'vehicle-accessories', 'name' => 'Vehicle Accessories', 'name_ar' => 'إكسسوارات وقطع غيار'],
                    ['slug' => 'autos-for-rent', 'name' => 'Autos for Rent', 'name_ar' => 'سيارات للإيجار'],
                    ['slug' => 'heavy-machinery', 'name' => 'Heavy Machinery', 'name_ar' => 'آليات ومعدات ثقيلة'],
                    ['slug' => 'vehicle-spare-parts', 'name' => 'Vehicle Spare Parts', 'name_ar' => 'قطع غيار سيارات'],
                    ['slug' => 'plate-numbers', 'name' => 'Plate Numbers', 'name_ar' => 'لوحات مميزة'],
                ],
            ],
            [
                'id' => 15,
                'slug' => 'motorcycles',
                'name' => 'Motorcycles',
                'name_ar' => 'دراجات نارية',
                'icon' => 'motorcycles.png',
                'pos' => 4,
                'subcategories' => [
                    ['slug' => 'sports-bikes', 'name' => 'Sports Bikes', 'name_ar' => 'دراجات رياضية'],
                    ['slug' => 'cruisers-touring', 'name' => 'Cruisers & Touring', 'name_ar' => 'دراجات كروز وسفر'],
                    ['slug' => 'scooters-mopeds', 'name' => 'Scooters & Mopeds', 'name_ar' => 'سكوترات'],
                    ['slug' => 'quad-bikes-atv', 'name' => 'Quad Bikes & ATV', 'name_ar' => 'دبابات وبجي'],
                    ['slug' => 'bicycles-accessories', 'name' => 'Bicycles & Accessories', 'name_ar' => 'دراجات هوائية ومستلزماتها'],
                ],
            ],
            [
                'id' => 9,
                'slug' => 'property-for-sale',
                'name' => 'Property For Sale',
                'name_ar' => 'عقارات للبيع',
                'icon' => 'property_for_sale.png',
                'pos' => 5,
                'subcategories' => [
                    ['slug' => 'apartments-for-sale', 'name' => 'Apartments for Sale', 'name_ar' => 'شقق للبيع'],
                    ['slug' => 'villas-houses-sale', 'name' => 'Villas & Houses', 'name_ar' => 'فلل وبيوت للبيع'],
                    ['slug' => 'lands-plots-sale', 'name' => 'Lands & Plots', 'name_ar' => 'أراضي وفضاء للبيع'],
                    ['slug' => 'commercial-properties-sale', 'name' => 'Commercial Properties', 'name_ar' => 'عقارات تجارية للبيع'],
                    ['slug' => 'chalets-farms-sale', 'name' => 'Chalets & Farms', 'name_ar' => 'شاليهات ومزارع للبيع'],
                ],
            ],
            [
                'id' => 16,
                'slug' => 'property-for-rent',
                'name' => 'Property For Rent',
                'name_ar' => 'عقارات للإيجار',
                'icon' => 'property_for_rent.png',
                'pos' => 6,
                'subcategories' => [
                    ['slug' => 'apartments-for-rent', 'name' => 'Apartments for Rent', 'name_ar' => 'شقق للإيجار'],
                    ['slug' => 'floors-duplexes-rent', 'name' => 'Floors & Duplexes', 'name_ar' => 'أدوار ودوبلكس للإيجار'],
                    ['slug' => 'villas-houses-rent', 'name' => 'Villas & Houses', 'name_ar' => 'فلل وبيوت للإيجار'],
                    ['slug' => 'commercial-offices-rent', 'name' => 'Offices & Commercial', 'name_ar' => 'مكاتب ومحلات للإيجار'],
                    ['slug' => 'chalets-camps-rent', 'name' => 'Chalets & Camps', 'name_ar' => 'شاليهات ومخيمات للإيجار'],
                ],
            ],
            [
                'id' => 11,
                'slug' => 'jobs',
                'name' => 'Jobs',
                'name_ar' => 'وظائف',
                'icon' => 'jobs.png',
                'pos' => 7,
                'subcategories' => [
                    ['slug' => 'accounting-finance-jobs', 'name' => 'Accounting & Finance', 'name_ar' => 'محاسبة ومالية'],
                    ['slug' => 'sales-marketing-jobs', 'name' => 'Sales & Marketing', 'name_ar' => 'مبيعات وتسويق'],
                    ['slug' => 'it-software-jobs', 'name' => 'IT & Software', 'name_ar' => 'تكنولوجيا وبرمجة'],
                    ['slug' => 'engineering-jobs', 'name' => 'Engineering', 'name_ar' => 'هندسة وفنيون'],
                    ['slug' => 'medical-healthcare-jobs', 'name' => 'Healthcare & Medical', 'name_ar' => 'طب ورعاية صحية'],
                    ['slug' => 'drivers-delivery-jobs', 'name' => 'Drivers & Logistics', 'name_ar' => 'سائقون وتوصيل'],
                ],
            ],
            [
                'id' => 12,
                'slug' => 'services',
                'name' => 'Services',
                'name_ar' => 'خدمات',
                'icon' => 'services.png',
                'pos' => 8,
                'subcategories' => [
                    ['slug' => 'moving-relocation', 'name' => 'Moving & Transport', 'name_ar' => 'نقل عفش وأثاث'],
                    ['slug' => 'cleaning-pest-control', 'name' => 'Cleaning Services', 'name_ar' => 'تنظيف ومكافحة حشرات'],
                    ['slug' => 'home-maintenance-repair', 'name' => 'Home Maintenance', 'name_ar' => 'صيانة منزلية وفنيون'],
                    ['slug' => 'legal-business-services', 'name' => 'Legal & Business', 'name_ar' => 'خدمات قانونية وتخليص معاملات'],
                    ['slug' => 'events-catering', 'name' => 'Events & Parties', 'name_ar' => 'تنظيم حفلات ومناسبات'],
                ],
            ],
            [
                'id' => 17,
                'slug' => 'phones-tablets',
                'name' => 'Phones & Tablets',
                'name_ar' => 'هواتف وأجهزة',
                'icon' => 'phones_tablets.png',
                'pos' => 9,
                'subcategories' => [
                    ['slug' => 'mobile-phones', 'name' => 'Mobile Phones', 'name_ar' => 'هواتف ذكية'],
                    ['slug' => 'tablets-ipads', 'name' => 'Tablets & iPads', 'name_ar' => 'أجهزة لوحية وآيباد'],
                    ['slug' => 'smart-watches-wearables', 'name' => 'Smart Watches', 'name_ar' => 'ساعات ذكية'],
                    ['slug' => 'phone-accessories', 'name' => 'Phone Accessories', 'name_ar' => 'إكسسوارات الهواتف'],
                ],
            ],
            [
                'id' => 18,
                'slug' => 'computers-laptops',
                'name' => 'Computers & Laptops',
                'name_ar' => 'كمبيوتر ولابتوب',
                'icon' => 'computers_laptops.png',
                'pos' => 10,
                'subcategories' => [
                    ['slug' => 'laptops-macbooks', 'name' => 'Laptops & MacBooks', 'name_ar' => 'لابتوب وماك بوك'],
                    ['slug' => 'desktop-pcs', 'name' => 'Desktop Computers', 'name_ar' => 'كمبيوتر مكتبي'],
                    ['slug' => 'computer-components-pc', 'name' => 'Components & Upgrades', 'name_ar' => 'قطع وتجميعات كمبيوتر'],
                    ['slug' => 'printers-scanners', 'name' => 'Printers & Networking', 'name_ar' => 'طابعات وشبكات'],
                ],
            ],
            [
                'id' => 19,
                'slug' => 'gaming-toys',
                'name' => 'Gaming & Toys',
                'name_ar' => 'ألعاب فيديو',
                'icon' => 'gaming_toys.png',
                'pos' => 11,
                'subcategories' => [
                    ['slug' => 'playstation-consoles', 'name' => 'PlayStation', 'name_ar' => 'بلايستيشن'],
                    ['slug' => 'xbox-consoles', 'name' => 'Xbox', 'name_ar' => 'إكس بوكس'],
                    ['slug' => 'nintendo-consoles', 'name' => 'Nintendo', 'name_ar' => 'نينتندو'],
                    ['slug' => 'gaming-accessories-rigs', 'name' => 'Gaming Accessories', 'name_ar' => 'مستلزمات جيمنج'],
                    ['slug' => 'board-games-toys', 'name' => 'Toys & Board Games', 'name_ar' => 'ألعاب أطفال ومجسمات'],
                ],
            ],
            [
                'id' => 20,
                'slug' => 'sports-fitness',
                'name' => 'Sports & Fitness',
                'name_ar' => 'رياضة ولياقة',
                'icon' => 'sports_fitness.png',
                'pos' => 12,
                'subcategories' => [
                    ['slug' => 'gym-fitness-equipment', 'name' => 'Gym Equipment', 'name_ar' => 'أجهزة رياضية وجيم'],
                    ['slug' => 'football-racket-sports', 'name' => 'Outdoor Sports', 'name_ar' => 'كرة قدم ورياضات خارجية'],
                    ['slug' => 'water-sports-diving', 'name' => 'Water Sports', 'name_ar' => 'رياضات بحرية وغوص'],
                    ['slug' => 'camping-hiking-gear', 'name' => 'Camping Gear', 'name_ar' => 'معدات تخييم ورحلات'],
                ],
            ],
            [
                'id' => 10,
                'slug' => 'electronics',
                'name' => 'Electronics',
                'name_ar' => 'إلكترونيات',
                'icon' => 'electronics.png',
                'pos' => 13,
                'subcategories' => [
                    ['slug' => 'tvs-home-theater', 'name' => 'Smart TVs & Screens', 'name_ar' => 'شاشات وتلفزيونات'],
                    ['slug' => 'cameras-photography', 'name' => 'Cameras & Lenses', 'name_ar' => 'كاميرات وعدسات'],
                    ['slug' => 'audio-sound-systems', 'name' => 'Audio & Speakers', 'name_ar' => 'سماعات وأنظمة صوتية'],
                    ['slug' => 'smart-home-gadgets', 'name' => 'Smart Home Gadgets', 'name_ar' => 'أجهزة منزلية ذكية'],
                ],
            ],
            [
                'id' => 21,
                'slug' => 'household-appliances',
                'name' => 'Household Appliances',
                'name_ar' => 'أجهزة منزلية',
                'icon' => 'household_appliances.png',
                'pos' => 14,
                'subcategories' => [
                    ['slug' => 'refrigerators-freezers', 'name' => 'Refrigerators & Freezers', 'name_ar' => 'ثلاجات وفريزرات'],
                    ['slug' => 'washing-machines-dryers', 'name' => 'Washing Machines', 'name_ar' => 'غسالات ونشافات'],
                    ['slug' => 'stoves-microwaves-ovens', 'name' => 'Ovens & Microwaves', 'name_ar' => 'أفران وميكروويف'],
                    ['slug' => 'air-conditioners-heaters', 'name' => 'Air Conditioners', 'name_ar' => 'مكيفات وتدفئة'],
                ],
            ],
            [
                'id' => 22,
                'slug' => 'home-garden',
                'name' => 'Home & Garden',
                'name_ar' => 'المنزل والحديقة',
                'icon' => 'home_garden.png',
                'pos' => 15,
                'subcategories' => [
                    ['slug' => 'living-room-furniture', 'name' => 'Living Room Furniture', 'name_ar' => 'أثاث غرف جلوس'],
                    ['slug' => 'bedroom-furniture', 'name' => 'Bedroom Furniture', 'name_ar' => 'أثاث غرف نوم'],
                    ['slug' => 'outdoor-garden-furniture', 'name' => 'Garden & Plants', 'name_ar' => 'حدائق ونباتات'],
                    ['slug' => 'home-decor-lighting', 'name' => 'Home Decor & Lighting', 'name_ar' => 'ديكورات وإضاءة'],
                ],
            ],
            [
                'id' => 23,
                'slug' => 'fashion-kids',
                'name' => 'Fashion & Kids',
                'name_ar' => 'أزياء وأطفال',
                'icon' => 'fashion_kids.png',
                'pos' => 16,
                'subcategories' => [
                    ['slug' => 'mens-clothing-accessories', 'name' => "Men's Fashion", 'name_ar' => 'أزياء رجالية ومستلزمات'],
                    ['slug' => 'womens-clothing-dresses', 'name' => "Women's Fashion", 'name_ar' => 'أزياء نسائية وفساتين'],
                    ['slug' => 'kids-clothing-baby-gear', 'name' => 'Kids & Baby Gear', 'name_ar' => 'ملابس ومستلزمات أطفال'],
                    ['slug' => 'luxury-watches-jewelry', 'name' => 'Watches & Jewelry', 'name_ar' => 'ساعات ومجوهرات فاخرة'],
                    ['slug' => 'bags-shoes-wallets', 'name' => 'Bags & Footwear', 'name_ar' => 'حقائب وأحذية'],
                ],
            ],
            [
                'id' => 24,
                'slug' => 'pets-accessories',
                'name' => 'Pets & Accessories',
                'name_ar' => 'حيوانات وأليفة',
                'icon' => 'pets_accessories.png',
                'pos' => 17,
                'subcategories' => [
                    ['slug' => 'cats-kittens', 'name' => 'Cats & Kittens', 'name_ar' => 'قطط ومستلزماتها'],
                    ['slug' => 'dogs-puppies', 'name' => 'Dogs & Puppies', 'name_ar' => 'كلاب ومستلزماتها'],
                    ['slug' => 'birds-parrots', 'name' => 'Birds & Parrots', 'name_ar' => 'طيور وببغاوات'],
                    ['slug' => 'horses-equestrian', 'name' => 'Horses & Equestrian', 'name_ar' => 'خيول ومعدات فروسية'],
                    ['slug' => 'fish-aquariums', 'name' => 'Fish & Aquariums', 'name_ar' => 'أسماك وأحواض'],
                ],
            ],
            [
                'id' => 25,
                'slug' => 'leisure-collectibles',
                'name' => 'Leisure & Collectibles',
                'name_ar' => 'مقتنيات وتخييم',
                'icon' => 'leisure_collectibles.png',
                'pos' => 18,
                'subcategories' => [
                    ['slug' => 'vintage-antiques', 'name' => 'Vintage & Antiques', 'name_ar' => 'تحف ومقتنيات قديمة'],
                    ['slug' => 'camping-tents-gear', 'name' => 'Tents & Camping Equipment', 'name_ar' => 'خيام ومستلزمات البر'],
                    ['slug' => 'musical-instruments', 'name' => 'Musical Instruments', 'name_ar' => 'آلات موسيقية'],
                    ['slug' => 'art-paintings-crafts', 'name' => 'Art & Handcrafts', 'name_ar' => 'لوحات وفنون يدوية'],
                ],
            ],
            [
                'id' => 26,
                'slug' => 'food',
                'name' => 'Food',
                'name_ar' => 'أطعمة ومأكولات',
                'icon' => 'food.png',
                'pos' => 19,
                'subcategories' => [
                    ['slug' => 'home-cooking-catering', 'name' => 'Home Cooking & Sweets', 'name_ar' => 'أكلات منزلية وحلويات'],
                    ['slug' => 'dates-honey-spices', 'name' => 'Dates, Honey & Coffee', 'name_ar' => 'تمور، عسل وبهارات'],
                    ['slug' => 'livestock-meat', 'name' => 'Livestock & Fresh Meat', 'name_ar' => 'ذبائح ومواشي طازجة'],
                ],
            ],
            [
                'id' => 27,
                'slug' => 'beauty-health',
                'name' => 'Beauty & Health',
                'name_ar' => 'صحة وجمال',
                'icon' => 'beauty_health.png',
                'pos' => 20,
                'subcategories' => [
                    ['slug' => 'perfumes-oud-incense', 'name' => 'Perfumes & Bukhoor', 'name_ar' => 'عطور وبخور'],
                    ['slug' => 'skincare-cosmetics', 'name' => 'Skin Care & Cosmetics', 'name_ar' => 'عناية بالبشرة ومكياج'],
                    ['slug' => 'haircare-personal-care', 'name' => 'Hair & Personal Care', 'name_ar' => 'عناية بالشعر والجسم'],
                    ['slug' => 'medical-equipment-wellness', 'name' => 'Medical Equipment', 'name_ar' => 'أجهزة ومستلزمات طبية'],
                ],
            ],
            [
                'id' => 28,
                'slug' => 'businesses-equipment',
                'name' => 'Businesses & Equipment',
                'name_ar' => 'معدات ومشاريع',
                'icon' => 'businesses_equipment.png',
                'pos' => 21,
                'subcategories' => [
                    ['slug' => 'restaurant-equipment', 'name' => 'Restaurant & Cafe Equipment', 'name_ar' => 'معدات مطاعم ومقاهي'],
                    ['slug' => 'industrial-machinery', 'name' => 'Industrial Machinery', 'name_ar' => 'معدات وورش صناعية'],
                    ['slug' => 'commercial-vehicles', 'name' => 'Commercial Vans & Trucks', 'name_ar' => 'سيارات تجارية ونقل'],
                    ['slug' => 'businesses-for-sale', 'name' => 'Businesses for Sale', 'name_ar' => 'مشاريع ورخص للبيع'],
                ],
            ],
            [
                'id' => 29,
                'slug' => 'education-training',
                'name' => 'Education & Training',
                'name_ar' => 'تعليم وتدريب',
                'icon' => 'education_training.png',
                'pos' => 22,
                'subcategories' => [
                    ['slug' => 'private-tutors', 'name' => 'Private Tutors & Lessons', 'name_ar' => 'مدرسون خصوصيون ودروس'],
                    ['slug' => 'language-skills-courses', 'name' => 'Language & Skills Courses', 'name_ar' => 'دورات لغات وتطوير'],
                    ['slug' => 'driving-lessons', 'name' => 'Driving Lessons', 'name_ar' => 'تعليم قيادة'],
                ],
            ],
            [
                'id' => 30,
                'slug' => 'job-seekers',
                'name' => 'Job Seekers',
                'name_ar' => 'باحثون عن عمل',
                'icon' => 'job_seekers.png',
                'pos' => 23,
                'subcategories' => [
                    ['slug' => 'administrative-seekers', 'name' => 'Administrative & Clerical', 'name_ar' => 'إداريون وسكرتارية'],
                    ['slug' => 'sales-customer-service-seekers', 'name' => 'Sales & Customer Care', 'name_ar' => 'مبيعات وخدمة عملاء'],
                    ['slug' => 'technicians-labor-seekers', 'name' => 'Technicians & Craftsmen', 'name_ar' => 'فنيون وحرفيون'],
                    ['slug' => 'drivers-helpers-seekers', 'name' => 'Drivers & Helpers', 'name_ar' => 'سائقون ومساعدون'],
                ],
            ],
            [
                'id' => 31,
                'slug' => 'reviews-ratings',
                'name' => 'Reviews & Ratings',
                'name_ar' => 'تقييمات ومراجعات',
                'icon' => 'reviews_ratings.png',
                'pos' => 24,
                'subcategories' => [
                    ['slug' => 'auto-dealers-reviews', 'name' => 'Auto Showrooms Reviews', 'name_ar' => 'تقييم معارض السيارات'],
                    ['slug' => 'contractors-reviews', 'name' => 'Home Services Reviews', 'name_ar' => 'تقييم مقاولي الخدمات'],
                    ['slug' => 'top-rated-sellers', 'name' => 'Top Rated Sellers', 'name_ar' => 'أفضل المعلنين تقييماً'],
                ],
            ],
        ];

        foreach ($categories as $catData) {
            $subs = $catData['subcategories'] ?? [];
            unset($catData['subcategories']);

            $cat = Category::updateOrCreate(
                ['slug' => $catData['slug']],
                [
                    'name' => $catData['name'],
                    'name_ar' => $catData['name_ar'],
                    'icon' => $catData['icon'],
                    'pos' => $catData['pos'],
                    'is_active' => true,
                ]
            );

            $subPos = 1;
            foreach ($subs as $sub) {
                Category::updateOrCreate(
                    [
                        'parent_id' => $cat->id,
                        'slug' => $sub['slug'],
                    ],
                    [
                        'name' => $sub['name'],
                        'name_ar' => $sub['name_ar'],
                        'icon' => $catData['icon'],
                        'pos' => $subPos++,
                        'is_active' => true,
                    ]
                );
            }
        }

        $this->command->info('✅ Successfully seeded all 24 4Sale categories and subcategories with 3D icons.');
    }
}
