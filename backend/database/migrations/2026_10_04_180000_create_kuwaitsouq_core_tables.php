<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Extend Users Table
        Schema::table('users', function (Blueprint $table) {
            $table->string('phone')->nullable()->after('email');
            $table->string('phone_code', 10)->default('+965')->after('phone');
            $table->string('avatar')->nullable()->after('password');
            $table->boolean('is_admin')->default(false)->after('avatar');
            $table->boolean('is_verified')->default(false)->after('is_admin');
            $table->string('member_type')->default('Free Member')->after('is_verified');
            $table->string('member_id_number', 20)->nullable()->after('member_type');
            $table->date('member_since')->nullable()->after('member_id_number');
            $table->integer('live_listings_limit')->default(20)->after('member_since');
            $table->decimal('rating', 3, 1)->default(0.0)->after('live_listings_limit');
            $table->integer('rating_count')->default(0)->after('rating');
            $table->integer('listing_credits')->default(0)->after('rating_count');
            $table->integer('vas_credits')->default(0)->after('listing_credits');
            $table->integer('cv_completeness')->default(0)->after('vas_credits');
            $table->integer('cv_views')->default(0)->after('cv_completeness');
            $table->integer('job_applications_count')->default(0)->after('cv_views');
            $table->integer('member_views')->default(0)->after('job_applications_count');
            $table->string('whatsapp')->nullable()->after('member_views');
        });

        // 2. Countries Table
        Schema::create('countries', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('name_ar');
            $table->string('code', 5)->unique(); // KW, SA, AE, QA, BH, OM
            $table->string('phone_code', 10); // +965, +966, +971, +974, +973, +968
            $table->string('currency', 10); // KWD, SAR, AED, QAR, BHD, OMR
            $table->string('currency_ar', 10); // د.ك, ر.س, د.إ, ر.ق, د.ب, ر.ع
            $table->string('flag', 10)->default('🇰🇼');
            $table->boolean('is_default')->default(false);
            $table->boolean('is_active')->default(true);
            $table->integer('pos')->default(0);
            $table->timestamps();
        });

        // 3. Cities Table
        Schema::create('cities', function (Blueprint $table) {
            $table->id();
            $table->foreignId('country_id')->constrained('countries')->onDelete('cascade');
            $table->string('name');
            $table->string('name_ar');
            $table->boolean('is_active')->default(true);
            $table->integer('pos')->default(0);
            $table->timestamps();

            $table->index(['country_id', 'pos']);
        });

        // 4. Neighborhoods Table
        Schema::create('neighborhoods', function (Blueprint $table) {
            $table->id();
            $table->foreignId('city_id')->constrained('cities')->onDelete('cascade');
            $table->string('name');
            $table->string('name_ar');
            $table->integer('pos')->default(0);
            $table->timestamps();

            $table->index(['city_id', 'pos']);
        });

        // 5. Categories Table
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->foreignId('parent_id')->nullable()->constrained('categories')->onDelete('cascade');
            $table->string('name');
            $table->string('name_ar');
            $table->string('slug')->unique();
            $table->string('icon')->nullable();
            $table->string('banner_image')->nullable();
            $table->integer('pos')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index(['parent_id', 'pos']);
        });

        // 6. Category Filters Table (Dynamic Filters)
        Schema::create('category_filters', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')->nullable()->constrained('categories')->onDelete('cascade');
            $table->string('name');
            $table->string('name_ar')->nullable();
            $table->string('filter_key');
            $table->string('type')->default('select'); // select, pills, brands_grid, range, checkbox
            $table->boolean('is_pinned')->default(true);
            $table->integer('pos')->default(0);
            $table->timestamps();

            $table->index(['category_id', 'pos']);
            $table->index('filter_key');
        });

        // 7. Category Filter Options Table (e.g. Brands, Models, Conditions)
        Schema::create('category_filter_options', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_filter_id')->constrained('category_filters')->onDelete('cascade');
            $table->string('label');
            $table->string('label_ar')->nullable();
            $table->string('value');
            $table->string('icon')->nullable(); // brand logo URL/SVG
            $table->boolean('is_quick_card')->default(false); // shown in visual brand grid
            $table->integer('pos')->default(0);
            $table->timestamps();

            $table->index(['category_filter_id', 'pos']);
            $table->index('is_quick_card');
        });

        // 8. Ads Table
        Schema::create('ads', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('category_id')->constrained('categories')->onDelete('cascade');
            $table->foreignId('sub_category_id')->nullable()->constrained('categories')->onDelete('set null');
            $table->foreignId('country_id')->constrained('countries')->onDelete('cascade');
            $table->foreignId('city_id')->constrained('cities')->onDelete('cascade');
            $table->foreignId('neighborhood_id')->nullable()->constrained('neighborhoods')->onDelete('set null');
            $table->string('neighborhood_name')->nullable();
            $table->string('title');
            $table->string('title_ar')->nullable();
            $table->text('description');
            $table->text('description_ar')->nullable();
            $table->decimal('price', 12, 2)->default(0.00);
            $table->string('currency', 10)->default('KWD');
            $table->string('condition')->default('used'); // used, new
            $table->json('attributes')->nullable(); // Dynamic filter attributes
            $table->string('phone')->nullable();
            $table->string('whatsapp')->nullable();
            $table->boolean('is_boosted')->default(false); // Rocket icon
            $table->boolean('is_featured')->default(false);
            $table->integer('views_count')->default(0);
            $table->integer('favorites_count')->default(0);
            $table->string('status')->default('active'); // active, pending, draft, rejected, sold
            $table->timestamp('published_at')->nullable();
            $table->timestamps();

            $table->index(['country_id', 'city_id']);
            $table->index(['category_id', 'status']);
            $table->index('is_boosted');
            $table->index('is_featured');
            $table->index('published_at');
        });

        // 9. Ad Media Table
        Schema::create('ad_media', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ad_id')->constrained('ads')->onDelete('cascade');
            $table->enum('type', ['image', 'video'])->default('image');
            $table->string('file_path');
            $table->boolean('is_primary')->default(false);
            $table->integer('pos')->default(0);
            $table->timestamps();

            $table->index(['ad_id', 'pos']);
        });

        // 10. Seller Stories Table (Circle avatar story carousel)
        Schema::create('seller_stories', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('ad_id')->nullable()->constrained('ads')->onDelete('set null');
            $table->string('media_path');
            $table->string('caption')->nullable();
            $table->string('ring_color')->default('orange'); // orange, green, blue
            $table->timestamp('expires_at')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // 11. Saved Searches
        Schema::create('saved_searches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('title')->nullable();
            $table->foreignId('category_id')->nullable()->constrained('categories')->onDelete('set null');
            $table->foreignId('city_id')->nullable()->constrained('cities')->onDelete('set null');
            $table->json('filters')->nullable();
            $table->boolean('notify_on_new')->default(true);
            $table->timestamps();
        });

        // 12. Favorites
        Schema::create('favorites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('ad_id')->constrained('ads')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'ad_id']);
        });

        // 13. Price Drop Alerts
        Schema::create('price_drop_alerts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('ad_id')->constrained('ads')->onDelete('cascade');
            $table->decimal('target_price', 12, 2)->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'ad_id']);
        });

        // 14. Messages (In-App Chat)
        Schema::create('messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ad_id')->nullable()->constrained('ads')->onDelete('set null');
            $table->foreignId('sender_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('receiver_id')->constrained('users')->onDelete('cascade');
            $table->text('message');
            $table->boolean('is_read')->default(false);
            $table->timestamps();

            $table->index(['sender_id', 'receiver_id']);
            $table->index(['receiver_id', 'is_read']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('messages');
        Schema::dropIfExists('price_drop_alerts');
        Schema::dropIfExists('favorites');
        Schema::dropIfExists('saved_searches');
        Schema::dropIfExists('seller_stories');
        Schema::dropIfExists('ad_media');
        Schema::dropIfExists('ads');
        Schema::dropIfExists('category_filter_options');
        Schema::dropIfExists('category_filters');
        Schema::dropIfExists('categories');
        Schema::dropIfExists('neighborhoods');
        Schema::dropIfExists('cities');
        Schema::dropIfExists('countries');

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'phone', 'phone_code', 'avatar', 'is_admin', 'is_verified',
                'member_type', 'member_id_number', 'member_since',
                'live_listings_limit', 'rating', 'rating_count',
                'listing_credits', 'vas_credits', 'cv_completeness',
                'cv_views', 'job_applications_count', 'member_views', 'whatsapp'
            ]);
        });
    }
};
