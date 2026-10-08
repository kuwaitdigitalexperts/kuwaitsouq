-- ========================================================
-- KuwaitSouq Complete MySQL Database Import for Namecheap
-- Includes: Full Schema DDL + Complete GCC Seed Data
-- Generated: 2026-10-07 17:58:06
-- ========================================================

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET NAMES utf8mb4;

-- SCHEMA DDL --

create table `users` (`id` bigint unsigned not null auto_increment primary key, `name` varchar(255) not null, `email` varchar(255) not null, `email_verified_at` timestamp null, `password` varchar(255) not null, `remember_token` varchar(100) null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `users` add unique `users_email_unique`(`email`);

create table `password_reset_tokens` (`email` varchar(255) not null, `token` varchar(255) not null, `created_at` timestamp null, primary key (`email`)) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

create table `sessions` (`id` varchar(255) not null, `user_id` bigint unsigned null, `ip_address` varchar(45) null, `user_agent` text null, `payload` longtext not null, `last_activity` int not null, primary key (`id`)) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `sessions` add index `sessions_user_id_index`(`user_id`);

alter table `sessions` add index `sessions_last_activity_index`(`last_activity`);

create table `cache` (`key` varchar(255) not null, `value` mediumtext not null, `expiration` bigint not null, primary key (`key`)) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `cache` add index `cache_expiration_index`(`expiration`);

create table `cache_locks` (`key` varchar(255) not null, `owner` varchar(255) not null, `expiration` bigint not null, primary key (`key`)) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `cache_locks` add index `cache_locks_expiration_index`(`expiration`);

create table `jobs` (`id` bigint unsigned not null auto_increment primary key, `queue` varchar(255) not null, `payload` longtext not null, `attempts` smallint unsigned not null, `reserved_at` int unsigned null, `available_at` int unsigned not null, `created_at` int unsigned not null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `jobs` add index `jobs_queue_index`(`queue`);

create table `job_batches` (`id` varchar(255) not null, `name` varchar(255) not null, `total_jobs` int not null, `pending_jobs` int not null, `failed_jobs` int not null, `failed_job_ids` longtext not null, `options` mediumtext null, `cancelled_at` int null, `created_at` int not null, `finished_at` int null, primary key (`id`)) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

create table `failed_jobs` (`id` bigint unsigned not null auto_increment primary key, `uuid` varchar(255) not null, `connection` varchar(255) not null, `queue` varchar(255) not null, `payload` longtext not null, `exception` longtext not null, `failed_at` timestamp not null default CURRENT_TIMESTAMP) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `failed_jobs` add index `failed_jobs_connection_queue_failed_at_index`(`connection`, `queue`, `failed_at`);

alter table `failed_jobs` add unique `failed_jobs_uuid_unique`(`uuid`);

create table `personal_access_tokens` (`id` bigint unsigned not null auto_increment primary key, `tokenable_type` varchar(255) not null, `tokenable_id` bigint unsigned not null, `name` text not null, `token` varchar(64) not null, `abilities` text null, `last_used_at` timestamp null, `expires_at` timestamp null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `personal_access_tokens` add index `personal_access_tokens_tokenable_type_tokenable_id_index`(`tokenable_type`, `tokenable_id`);

alter table `personal_access_tokens` add unique `personal_access_tokens_token_unique`(`token`);

alter table `personal_access_tokens` add index `personal_access_tokens_expires_at_index`(`expires_at`);

alter table `users` add `phone` varchar(255) null after `email`;

alter table `users` add `phone_code` varchar(10) not null default '+965' after `phone`;

alter table `users` add `avatar` varchar(255) null after `password`;

alter table `users` add `is_admin` tinyint(1) not null default '0' after `avatar`;

alter table `users` add `is_verified` tinyint(1) not null default '0' after `is_admin`;

alter table `users` add `member_type` varchar(255) not null default 'Free Member' after `is_verified`;

alter table `users` add `member_id_number` varchar(20) null after `member_type`;

alter table `users` add `member_since` date null after `member_id_number`;

alter table `users` add `live_listings_limit` int not null default '20' after `member_since`;

alter table `users` add `rating` decimal(3, 1) not null default '0' after `live_listings_limit`;

alter table `users` add `rating_count` int not null default '0' after `rating`;

alter table `users` add `listing_credits` int not null default '0' after `rating_count`;

alter table `users` add `vas_credits` int not null default '0' after `listing_credits`;

alter table `users` add `cv_completeness` int not null default '0' after `vas_credits`;

alter table `users` add `cv_views` int not null default '0' after `cv_completeness`;

alter table `users` add `job_applications_count` int not null default '0' after `cv_views`;

alter table `users` add `member_views` int not null default '0' after `job_applications_count`;

alter table `users` add `whatsapp` varchar(255) null after `member_views`;

create table `countries` (`id` bigint unsigned not null auto_increment primary key, `name` varchar(255) not null, `name_ar` varchar(255) not null, `code` varchar(5) not null, `phone_code` varchar(10) not null, `currency` varchar(10) not null, `currency_ar` varchar(10) not null, `flag` varchar(10) not null default '🇰🇼', `is_default` tinyint(1) not null default '0', `is_active` tinyint(1) not null default '1', `pos` int not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `countries` add unique `countries_code_unique`(`code`);

create table `cities` (`id` bigint unsigned not null auto_increment primary key, `country_id` bigint unsigned not null, `name` varchar(255) not null, `name_ar` varchar(255) not null, `is_active` tinyint(1) not null default '1', `pos` int not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `cities` add constraint `cities_country_id_foreign` foreign key (`country_id`) references `countries` (`id`) on delete cascade;

alter table `cities` add index `cities_country_id_pos_index`(`country_id`, `pos`);

create table `neighborhoods` (`id` bigint unsigned not null auto_increment primary key, `city_id` bigint unsigned not null, `name` varchar(255) not null, `name_ar` varchar(255) not null, `pos` int not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `neighborhoods` add constraint `neighborhoods_city_id_foreign` foreign key (`city_id`) references `cities` (`id`) on delete cascade;

alter table `neighborhoods` add index `neighborhoods_city_id_pos_index`(`city_id`, `pos`);

create table `categories` (`id` bigint unsigned not null auto_increment primary key, `parent_id` bigint unsigned null, `name` varchar(255) not null, `name_ar` varchar(255) not null, `slug` varchar(255) not null, `icon` varchar(255) null, `banner_image` varchar(255) null, `pos` int not null default '0', `is_active` tinyint(1) not null default '1', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `categories` add constraint `categories_parent_id_foreign` foreign key (`parent_id`) references `categories` (`id`) on delete cascade;

alter table `categories` add index `categories_parent_id_pos_index`(`parent_id`, `pos`);

alter table `categories` add unique `categories_slug_unique`(`slug`);

create table `category_filters` (`id` bigint unsigned not null auto_increment primary key, `category_id` bigint unsigned null, `name` varchar(255) not null, `name_ar` varchar(255) null, `filter_key` varchar(255) not null, `type` varchar(255) not null default 'select', `is_pinned` tinyint(1) not null default '1', `pos` int not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `category_filters` add constraint `category_filters_category_id_foreign` foreign key (`category_id`) references `categories` (`id`) on delete cascade;

alter table `category_filters` add index `category_filters_category_id_pos_index`(`category_id`, `pos`);

alter table `category_filters` add index `category_filters_filter_key_index`(`filter_key`);

create table `category_filter_options` (`id` bigint unsigned not null auto_increment primary key, `category_filter_id` bigint unsigned not null, `label` varchar(255) not null, `label_ar` varchar(255) null, `value` varchar(255) not null, `icon` varchar(255) null, `is_quick_card` tinyint(1) not null default '0', `pos` int not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `category_filter_options` add constraint `category_filter_options_category_filter_id_foreign` foreign key (`category_filter_id`) references `category_filters` (`id`) on delete cascade;

alter table `category_filter_options` add index `category_filter_options_category_filter_id_pos_index`(`category_filter_id`, `pos`);

alter table `category_filter_options` add index `category_filter_options_is_quick_card_index`(`is_quick_card`);

create table `ads` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `category_id` bigint unsigned not null, `sub_category_id` bigint unsigned null, `country_id` bigint unsigned not null, `city_id` bigint unsigned not null, `neighborhood_id` bigint unsigned null, `neighborhood_name` varchar(255) null, `title` varchar(255) not null, `title_ar` varchar(255) null, `description` text not null, `description_ar` text null, `price` decimal(12, 2) not null default '0', `currency` varchar(10) not null default 'KWD', `condition` varchar(255) not null default 'used', `attributes` json null, `phone` varchar(255) null, `whatsapp` varchar(255) null, `is_boosted` tinyint(1) not null default '0', `is_featured` tinyint(1) not null default '0', `views_count` int not null default '0', `favorites_count` int not null default '0', `status` varchar(255) not null default 'active', `published_at` timestamp null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `ads` add constraint `ads_user_id_foreign` foreign key (`user_id`) references `users` (`id`) on delete cascade;

alter table `ads` add constraint `ads_category_id_foreign` foreign key (`category_id`) references `categories` (`id`) on delete cascade;

alter table `ads` add constraint `ads_sub_category_id_foreign` foreign key (`sub_category_id`) references `categories` (`id`) on delete set null;

alter table `ads` add constraint `ads_country_id_foreign` foreign key (`country_id`) references `countries` (`id`) on delete cascade;

alter table `ads` add constraint `ads_city_id_foreign` foreign key (`city_id`) references `cities` (`id`) on delete cascade;

alter table `ads` add constraint `ads_neighborhood_id_foreign` foreign key (`neighborhood_id`) references `neighborhoods` (`id`) on delete set null;

alter table `ads` add index `ads_country_id_city_id_index`(`country_id`, `city_id`);

alter table `ads` add index `ads_category_id_status_index`(`category_id`, `status`);

alter table `ads` add index `ads_is_boosted_index`(`is_boosted`);

alter table `ads` add index `ads_is_featured_index`(`is_featured`);

alter table `ads` add index `ads_published_at_index`(`published_at`);

create table `ad_media` (`id` bigint unsigned not null auto_increment primary key, `ad_id` bigint unsigned not null, `type` enum('image', 'video') not null default 'image', `file_path` varchar(255) not null, `is_primary` tinyint(1) not null default '0', `pos` int not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `ad_media` add constraint `ad_media_ad_id_foreign` foreign key (`ad_id`) references `ads` (`id`) on delete cascade;

alter table `ad_media` add index `ad_media_ad_id_pos_index`(`ad_id`, `pos`);

create table `seller_stories` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `ad_id` bigint unsigned null, `media_path` varchar(255) not null, `caption` varchar(255) null, `ring_color` varchar(255) not null default 'orange', `expires_at` timestamp null, `is_active` tinyint(1) not null default '1', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `seller_stories` add constraint `seller_stories_user_id_foreign` foreign key (`user_id`) references `users` (`id`) on delete cascade;

alter table `seller_stories` add constraint `seller_stories_ad_id_foreign` foreign key (`ad_id`) references `ads` (`id`) on delete set null;

create table `saved_searches` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `title` varchar(255) null, `category_id` bigint unsigned null, `city_id` bigint unsigned null, `filters` json null, `notify_on_new` tinyint(1) not null default '1', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `saved_searches` add constraint `saved_searches_user_id_foreign` foreign key (`user_id`) references `users` (`id`) on delete cascade;

alter table `saved_searches` add constraint `saved_searches_category_id_foreign` foreign key (`category_id`) references `categories` (`id`) on delete set null;

alter table `saved_searches` add constraint `saved_searches_city_id_foreign` foreign key (`city_id`) references `cities` (`id`) on delete set null;

create table `favorites` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `ad_id` bigint unsigned not null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `favorites` add constraint `favorites_user_id_foreign` foreign key (`user_id`) references `users` (`id`) on delete cascade;

alter table `favorites` add constraint `favorites_ad_id_foreign` foreign key (`ad_id`) references `ads` (`id`) on delete cascade;

alter table `favorites` add unique `favorites_user_id_ad_id_unique`(`user_id`, `ad_id`);

create table `price_drop_alerts` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `ad_id` bigint unsigned not null, `target_price` decimal(12, 2) null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `price_drop_alerts` add constraint `price_drop_alerts_user_id_foreign` foreign key (`user_id`) references `users` (`id`) on delete cascade;

alter table `price_drop_alerts` add constraint `price_drop_alerts_ad_id_foreign` foreign key (`ad_id`) references `ads` (`id`) on delete cascade;

alter table `price_drop_alerts` add unique `price_drop_alerts_user_id_ad_id_unique`(`user_id`, `ad_id`);

create table `messages` (`id` bigint unsigned not null auto_increment primary key, `ad_id` bigint unsigned null, `sender_id` bigint unsigned not null, `receiver_id` bigint unsigned not null, `message` text not null, `is_read` tinyint(1) not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';

alter table `messages` add constraint `messages_ad_id_foreign` foreign key (`ad_id`) references `ads` (`id`) on delete set null;

alter table `messages` add constraint `messages_sender_id_foreign` foreign key (`sender_id`) references `users` (`id`) on delete cascade;

alter table `messages` add constraint `messages_receiver_id_foreign` foreign key (`receiver_id`) references `users` (`id`) on delete cascade;

alter table `messages` add index `messages_sender_id_receiver_id_index`(`sender_id`, `receiver_id`);

alter table `messages` add index `messages_receiver_id_is_read_index`(`receiver_id`, `is_read`);

-- SEED DATA --

-- ----------------------------
-- Records of countries
-- ----------------------------
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (1, 'Kuwait', 'الكويت', 'KW', '+965', 'KWD', 'د.ك', '🇰🇼', 1, 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (2, 'Saudi Arabia', 'المملكة العربية السعودية', 'SA', '+966', 'SAR', 'ر.س', '🇸🇦', 0, 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (3, 'United Arab Emirates', 'الإمارات العربية المتحدة', 'AE', '+971', 'AED', 'د.إ', '🇦🇪', 0, 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (4, 'Qatar', 'قطر', 'QA', '+974', 'QAR', 'ر.ق', '🇶🇦', 0, 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (5, 'Bahrain', 'البحرين', 'BH', '+973', 'BHD', 'د.ب', '🇧🇭', 0, 1, 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (6, 'Oman', 'سلطنة عمان', 'OM', '+968', 'OMR', 'ر.ع', '🇴🇲', 0, 1, 6, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of cities
-- ----------------------------
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'Kuwait City', 'مدينة الكويت', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'Hawally', 'حولي', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (3, 1, 'Salmiya', 'السالمية', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (4, 1, 'Al Farwaniyah', 'الفروانية', 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (5, 1, 'Al Ahmadi', 'الأحمدي', 1, 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (6, 1, 'Al Jahra', 'الجهراء', 1, 6, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (7, 1, 'Mubarak Al-Kabeer', 'مبارك الكبير', 1, 7, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (8, 2, 'Al Riyadh', 'الرياض', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (9, 2, 'Jeddah', 'جدة', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (10, 2, 'Dammam', 'الدمام', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (11, 2, 'Mecca', 'مكة المكرمة', 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (12, 2, 'Medina', 'المدينة المنورة', 1, 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (13, 2, 'Al Khobar', 'الخبر', 1, 6, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (14, 3, 'Dubai', 'دبي', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (15, 3, 'Abu Dhabi', 'أبوظبي', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (16, 3, 'Sharjah', 'الشارقة', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (17, 3, 'Ajman', 'عجمان', 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (18, 4, 'Doha', 'الدوحة', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (19, 4, 'Al Rayyan', 'الريان', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (20, 4, 'Al Wakrah', 'الوكرة', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (21, 5, 'Manama', 'المنامة', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (22, 5, 'Riffa', 'الرفاع', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (23, 5, 'Muharraq', 'المحرق', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (24, 6, 'Muscat', 'مسقط', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (25, 6, 'Salalah', 'صلالة', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `cities` (`id`, `country_id`, `name`, `name_ar`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (26, 6, 'Sohar', 'صحار', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of neighborhoods
-- ----------------------------
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'Sharq', 'شرق', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'Mirqab', 'المرقاب', 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (3, 1, 'Dasman', 'دسمان', 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (4, 1, 'Shuwaikh', 'الشويخ', 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (5, 8, 'Al Munsiyah', 'المنسية', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (6, 8, 'Al Malaz', 'الملز', 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (7, 8, 'Al Olaya', 'العليا', 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (8, 8, 'Al Narjis', 'النرجس', 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (9, 8, 'Al Yasmin', 'الياسمين', 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (1, NULL, 'Autos', 'سيارات ومركبات', 'autos', 'car', NULL, 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (2, 1, 'Cars For Sale', 'سيارات للبيع', 'cars-for-sale', 'car', NULL, 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (3, 1, 'Vehicle Accessories', 'إكسسوارات وقطع غيار', 'vehicle-accessories', 'steering-wheel', NULL, 2, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (4, 1, 'Autos for Rent', 'سيارات للإيجار', 'autos-for-rent', 'car-key', NULL, 3, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (5, 1, 'Heavy Machinery', 'آليات ومعدات ثقيلة', 'heavy-machinery', 'bulldozer', NULL, 4, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (6, 1, 'Vehicle Spare Parts', 'قطع غيار سيارات', 'vehicle-spare-parts', 'brake-disk', NULL, 5, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (7, 1, 'Plate Numbers', 'لوحات مميزة', 'plate-numbers', 'license-plate', NULL, 6, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (8, 1, 'Quad Bikes, Buggies And ATV', 'دبابات وبجي وسكوترات', 'quad-bikes-buggies-atv', 'motorcycle', NULL, 7, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (9, NULL, 'Real Estate', 'عقارات', 'real-estate', 'home', NULL, 2, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (10, NULL, 'Electronics', 'إلكترونيات', 'electronics', 'mobile', NULL, 3, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (11, NULL, 'Jobs', 'وظائف', 'jobs', 'briefcase', NULL, 4, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `categories` (`id`, `parent_id`, `name`, `name_ar`, `slug`, `icon`, `banner_image`, `pos`, `is_active`, `created_at`, `updated_at`) VALUES (12, NULL, 'Services', 'خدمات', 'services', 'tools', NULL, 5, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of category_filters
-- ----------------------------
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'Condition', 'الحالة', 'condition', 'pills', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'Car Make', 'الشركة المصنعة', 'car_make', 'brands_grid', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (3, 1, 'Model', 'الموديل', 'model', 'select', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (4, 1, 'Transmission', 'ناقل الحركة', 'transmission', 'pills', 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of category_filter_options
-- ----------------------------
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'Used', 'مستعمل', 'used', NULL, 0, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'New', 'جديد', 'new', NULL, 0, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (3, 2, 'Toyota', 'تويوتا', 'toyota', NULL, 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (4, 2, 'Ford', 'فورد', 'ford', NULL, 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (5, 2, 'Chevrolet', 'شفروليه', 'chevrolet', NULL, 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (6, 2, 'MG', 'إم جي', 'mg', NULL, 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (7, 2, 'Hyundai', 'هيونداي', 'hyundai', NULL, 1, 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (8, 2, 'Kia', 'كيا', 'kia', NULL, 1, 6, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (9, 2, 'Nissan', 'نيسان', 'nissan', NULL, 1, 7, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (10, 2, 'Haval', 'هافال', 'haval', NULL, 1, 8, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (11, 2, 'Mercedes', 'مرسيدس', 'mercedes', NULL, 1, 9, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (12, 2, 'BMW', 'بي إم دبليو', 'bmw', NULL, 1, 10, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (13, 2, 'Lexus', 'لكزس', 'lexus', NULL, 1, 11, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (14, 3, 'Land Cruiser', 'لاند كروزر', 'land_cruiser', NULL, 0, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (15, 3, 'Camry', 'كامري', 'camry', NULL, 0, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (16, 3, 'F-150', 'إف-150', 'f150', NULL, 0, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (17, 3, 'Patrol', 'باترول', 'patrol', NULL, 0, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (18, 3, 'Tahoe', 'تاهو', 'tahoe', NULL, 0, 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (19, 4, 'Automatic', 'أوتوماتيك', 'automatic', NULL, 0, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filter_options` (`id`, `category_filter_id`, `label`, `label_ar`, `value`, `icon`, `is_quick_card`, `pos`, `created_at`, `updated_at`) VALUES (20, 4, 'Manual', 'يدوي', 'manual', NULL, 0, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (1, 'KuwaitSouq Admin', 'admin@kuwaitsouq.com', NULL, '$2y$12$JsdIyt93i5unrTyM0tKCOezpnlyhIVN5PGG/4SezfE8qDzJ/GDvP6', NULL, '2026-10-04 17:44:30', '2026-10-04 17:44:30', '99001122', '+965', NULL, 1, 1, 'Admin', '10000001', '2024-01-01 00:00:00', 500, 5, 12, 100, 50, 100, 25, 0, 1400, '+96599001122');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (2, 'Al Ghanim global', 'alghanim@kuwaitsouq.com', NULL, '$2y$12$xPdoWJLqGFACHCZ8gEgcAOHhJFXWLZaUP1xhjYuWBQOgpsJ5WJ0T2', NULL, '2026-10-04 17:44:30', '2026-10-04 18:15:40', '0504880922', '+966', NULL, 0, 1, 'Free Member', '81355485', '2026-05-01 00:00:00', 20, 0, 0, 2, 1, 0, 0, 0, 417, '+966504880922');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (3, 'Abu Fahad', 'fahad@kuwaitsouq.com', NULL, '$2y$12$xSchRQ5cBaS9ywI.wk3vg.U3lcpAgL/RKDQIEUTigmS4Vsk9pQCRW', NULL, '2026-10-04 17:44:30', '2026-10-04 17:44:30', '0504880988', '+966', NULL, 0, 0, 'Free Member', '28794008', '2016-08-17 00:00:00', 20, 4.8, 18, 0, 0, 30, 5, 1, 150, '+966504880988');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (4, 'Ahmad Al-Sabah', 'user_96599991234@kuwaitsouq.app', NULL, '$2y$12$frPCwmTmbj1tZoWLUV6sxeBCKGqOeHr.AzFo65b0YIqxkTrSpxeN6', NULL, '2026-10-07 17:40:51', '2026-10-07 17:40:51', '+96599991234', '+965', NULL, 0, 1, 'Standard Member', NULL, '2026-10-07 17:40:51', 20, 0, 0, 0, 0, 0, 0, 0, 0, NULL);

-- ----------------------------
-- Records of ads
-- ----------------------------
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (1, 2, 1, 8, 2, 8, 5, 'Al Munsiyah', 'Mini Golf 4-Wheel Scooter', 'ميني جولف سكوتر رباعي', 'The cart is excellent for resorts, gated communities (compounds), and parks. It accommodates 3 passengers and features a second auxiliary battery installed to increase the driving distance and double operating time.', 'العربة ممتازة للمنتجعات، المجمعات المغلقة (الكمباوند)، والمنتزهات. تتسع لـ 3 ركاب وتتميز بوجود بطارية ثانية إضافية تم تركيبها لزيادة المسافة المقطوعة ومضاعفة وقت التشغيل.', 3800, 'SAR', 'used', '{\"condition\":\"used\",\"color\":\"Turquoise Blue\",\"battery\":\"Dual Electric Battery\",\"capacity\":\"3 Passengers\"}', '0504880922', '+966504880922', 1, 1, 417, 4, 'active', '2026-10-04 14:44:30', '2026-10-04 17:44:30', '2026-10-07 17:40:51');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (2, 3, 1, 8, 2, 8, NULL, 'Al Malaz', 'TORNADO Bicycle For Sale on Offer', 'للبيع سيكل دراجة هوائية TORNADO على السوم', 'Original high performance Tornado sports bicycle in very good condition with speed gears.', 'دراجة هوائية رياضية تورنادو أصلية بحالة ممتازة مع سرعات متعددة وفرامل قرصية.', 450, 'SAR', 'used', '{\"condition\":\"used\",\"brand\":\"Tornado\"}', '0504880988', '+966504880988', 0, 0, 180, 5, 'active', '2026-10-04 12:44:30', '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (3, 3, 1, 8, 2, 8, NULL, 'Al Olaya', 'Large Sports Bicycle', 'سيكل رياضي كبير', 'Large sports bicycle with shock absorbers.', 'دراجة رياضية مقاس كبير مع ممتص صدمات وسرعات.', 600, 'SAR', 'used', '{\"condition\":\"used\"}', '0504880988', '+966504880988', 0, 0, 95, 2, 'active', '2026-10-04 11:44:30', '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (4, 2, 1, 8, 2, 8, NULL, 'Al Narjis', 'Adly ATV-100V RS Taiwanese Quad bike', 'دباب ادلي تايواني Adly ATV-100V RS', 'Original Taiwanese Adly ATV-100V RS quad bike in mint condition.', 'دباب ادلي تايواني اصلي موديل Adly ATV-100V RS قمة بالنظافة وتشغيل سلف.', 2200, 'SAR', 'used', '{\"condition\":\"used\",\"make\":\"Adly\",\"engine\":\"100cc\"}', '0504880922', '+966504880922', 1, 1, 310, 8, 'active', '2026-10-03 17:44:30', '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (5, 1, 1, 2, 1, 1, NULL, 'Shuwaikh', 'Toyota Land Cruiser VXR 2024 Kuwait Agency', 'تويوتا لاند كروزر VXR 2024 وكالة الساير الكويت', 'Full option, 0 km, Sunroof, Leather seats, 360 Camera, 5-year warranty.', 'كامل المواصفات، عداد صفر، فتحة سقف، جلد، كاميرات 360، كفالة الساير 5 سنوات.', 26500, 'KWD', 'new', '{\"car_make\":\"toyota\",\"model\":\"land_cruiser\",\"year\":\"2024\",\"transmission\":\"automatic\",\"condition\":\"new\"}', '99001122', '+96599001122', 1, 1, 890, 45, 'active', '2026-10-04 15:44:30', '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (6, 1, 1, 2, 1, 1, NULL, 'الشويخ الصناعية', 'Lexus LX600 VIP 2024 Kuwait Al-Sayer Full Option', 'لكزس LX600 VIP 2024 وكالة الساير صبغ وكالة فل أوبشن', 'Lexus LX600 2024 VIP edition, zero km, Kuwait Al-Sayer warranty, radar, 360 camera, rear entertainment screens.', 'لكزس LX600 موديل 2024 فئة VIP، وارد الساير تحت الكفالة، عداد أصفار، رادار، كاميرات 360، شاشات خلفية، بحالة الوكالة تماماً.', 46500, 'KWD', 'new', NULL, '+965 99001122', '+965 99001122', 1, 1, 436, 26, 'active', '2026-10-07 09:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (7, 1, 1, 2, 1, 3, NULL, 'السالمية', 'Nissan Patrol Platinum 2023 V8 Full Option', 'نيسان باترول بلاتينيوم 2023 V8 بحالة ممتازة وكالة البابطين', 'Nissan Patrol 2023 Platinum V8 5.6L, Al Babtain agency, regular service, sunroof, leather seats, cooled seats.', 'نيسان باترول موديل 2023 بلاتينيوم 8 سلندر، وكالة البابطين سيرفس منتظم، فتحة سقف، جلد تان، تدفئة وتبريد، صبغ وكالة شرط الفحص.', 21800, 'KWD', 'used', NULL, '+965 98765432', '+965 98765432', 1, 1, 342, 23, 'active', '2026-10-05 18:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (8, 1, 1, 2, 1, 2, NULL, 'حولي', 'Porsche Cayenne Coupe GTS 2022 Kuwait Behbehani', 'بورش كايين كوبيه GTS 2022 وكالة بهبهاني كفالة شاملة', 'Porsche Cayenne Coupe GTS 2022, Behbehani agency, 38,000 km, sports exhaust, panoramic roof, ceramic brakes.', 'بورش كايين كوبيه GTS موديل 2022، وكالة بهبهاني الكويت، عداد 38 ألف كم، اكزوز رياضي، بانوراما، كاربون فايبر، صبغ وكالة بالكامل.', 31000, 'KWD', 'used', NULL, '+965 94455667', '+965 94455667', 0, 1, 611, 21, 'active', '2026-10-05 19:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (9, 1, 9, NULL, 1, 5, NULL, 'مدينة الخيران البحرية', 'Chalet For Rent in Khiran Creek Front Sea View', 'شاليه للإيجار في مدينة صباح الأحمد البحرية (الخيران) صف أول', 'Luxury sea front chalet in Khiran, 6 master bedrooms, private swimming pool, direct sea access, private dock for jet ski.', 'شاليه راقي ومميز على الخور مباشرة صف أول، 6 غرف ماستر، مسبح خاص معقم، جلسات خارجية مطلة على البحر، مرسى طراريد وجت سكي.', 450, 'KWD', 'new', NULL, '+965 97711223', '+965 97711223', 1, 1, 545, 32, 'active', '2026-10-06 07:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (10, 1, 9, NULL, 1, 3, NULL, 'السالمية شارع بغداد', 'Luxury 3BR Apartment For Rent in Salmiya Sea View', 'شقة فندقية للإيجار في السالمية إطلالة بحرية بانورامية 3 غرف', 'Spacious 3 bedroom apartment, sea view, swimming pool, gym, covered parking, security 24/7.', 'شقة فاخرة للإيجار السالمية شارع البلاجات إطلالة بحرية مباشرة، 3 غرف نوم وصالة واسعة، مسبح ونادي صحي، حراسة ومواقف خاصة.', 750, 'KWD', 'used', NULL, '+965 96622334', '+965 96622334', 0, 1, 845, 23, 'active', '2026-10-07 00:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (11, 1, 10, NULL, 1, 1, NULL, 'شرق', 'iPhone 16 Pro Max 256GB Desert Titanium Sealed Box', 'آيفون 16 برو ماكس 256 جيجا تيتانيوم صحراوي كرتون مختوم كفالة الغانم', 'Apple iPhone 16 Pro Max 256GB, Desert Titanium color, brand new sealed with local Kuwait warranty.', 'ابل ايفون 16 برو ماكس 256 جيجابايت، اللون التيتانيوم الصحراوي الجديد، جهاز جديد بالكرتون متبرشم بكفالة الغانم إكسترا.', 389, 'KWD', 'new', NULL, '+965 99887766', '+965 99887766', 1, 1, 460, 27, 'active', '2026-10-07 06:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (12, 1, 10, NULL, 1, 2, NULL, 'حولي شارع ابن خلدون', 'Apple MacBook Pro 16 M3 Max 36GB RAM 1TB SSD', 'ماك بوك برو 16 إنش M3 Max رام 36 جيجا هارد 1 تيرا كالجديد', 'MacBook Pro 16-inch M3 Max chip, 36GB unified memory, 1TB SSD, Space Black, complete box and charger.', 'ماك بوك برو 16 إنش شريحة M3 Max الأقوى، رام 36 جيجابايت، سعة 1 تيرا SSD، اللون الأسود الفضائي Space Black، استخدام خفيف جداً مع الفاتورة والكرتون.', 920, 'KWD', 'used', NULL, '+965 95544332', '+965 95544332', 0, 1, 120, 18, 'active', '2026-10-07 00:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (13, 1, 8, NULL, 1, 6, NULL, 'الجهراء', 'Yamaha Raptor 700R Special Edition 2023', 'ياماها رابتر 700R سبيشل اديشن 2023 نظيف جداً مع عربانة', 'Yamaha Raptor 700R 2023 SE, low hours, original exhaust, customized nerf bars, comes with trailer.', 'سيكل ياماها رابتر 700R موديل 2023 سبيشل اديشن، بحالة ممتازة، تزويد خفيف، استخدام قليل، مع القلص والعربانة جاهز للموسم.', 2850, 'KWD', 'used', NULL, '+965 92211445', '+965 92211445', 1, 1, 418, 15, 'active', '2026-10-06 07:48:36', '2026-10-07 17:48:36', '2026-10-07 17:48:36');

-- ----------------------------
-- Records of ad_media
-- ----------------------------
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'image', 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'image', 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800', 0, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (3, 1, 'image', 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=800', 0, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (4, 1, 'video', 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4', 0, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (5, 2, 'image', 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=800', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (6, 3, 'image', 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?w=800', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (7, 4, 'image', 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (8, 5, 'image', 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (9, 6, 'image', 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (10, 7, 'image', 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (11, 8, 'image', 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (12, 9, 'image', 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (13, 10, 'image', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (14, 11, 'image', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (15, 12, 'image', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (16, 13, 'image', 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800', 1, 1, '2026-10-07 17:48:36', '2026-10-07 17:48:36');

-- ----------------------------
-- Records of seller_stories
-- ----------------------------
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (1, 2, 1, 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500', 'عرض خاص على السكوترات الميني جولف', 'orange', '2026-10-05 13:44:30', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (2, 3, 2, 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=500', 'دراجات رياضية أصلية', 'green', '2026-10-05 11:44:30', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (3, 1, 5, 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=500', 'لاندكروزر 2024 جديد بالكويت', 'blue', '2026-10-05 17:44:30', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- ----------------------------
-- Records of favorites
-- ----------------------------
INSERT INTO `favorites` (`id`, `user_id`, `ad_id`, `created_at`, `updated_at`) VALUES (1, 4, 1, '2026-10-07 17:40:51', '2026-10-07 17:40:51');

-- ----------------------------
-- Records of messages
-- ----------------------------
INSERT INTO `messages` (`id`, `ad_id`, `sender_id`, `receiver_id`, `message`, `is_read`, `created_at`, `updated_at`) VALUES (1, NULL, 2, 1, 'hello', 0, '2026-10-05 18:37:19', '2026-10-05 18:37:19');
INSERT INTO `messages` (`id`, `ad_id`, `sender_id`, `receiver_id`, `message`, `is_read`, `created_at`, `updated_at`) VALUES (2, NULL, 4, 1, 'Salam alaykum, is this car still available?', 0, '2026-10-07 17:40:51', '2026-10-07 17:40:51');

-- ----------------------------
-- Records of personal_access_tokens
-- ----------------------------
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES (1, 'App\\Models\\User', 4, 'mobile_app', '572a418bd498882d8c090f30c879233932ffaf9dd89acc6ea21f07a1a9e7b9cc', '[\"*\"]', '2026-10-07 17:40:51', NULL, '2026-10-07 17:40:51', '2026-10-07 17:40:51');

SET FOREIGN_KEY_CHECKS=1;
