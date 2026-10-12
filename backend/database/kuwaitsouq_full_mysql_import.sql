
-- ========================================================
-- KuwaitSouq Complete MySQL Database Import for Namecheap cPanel
-- Includes: Full InnoDB DDL (Key length 191 safe) + GCC Seed Data
-- ========================================================

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET NAMES utf8mb4;

-- DROP EXISTING TABLES SAFELY --
DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `price_drop_alerts`;
DROP TABLE IF EXISTS `favorites`;
DROP TABLE IF EXISTS `saved_searches`;
DROP TABLE IF EXISTS `seller_stories`;
DROP TABLE IF EXISTS `ad_media`;
DROP TABLE IF EXISTS `ads`;
DROP TABLE IF EXISTS `category_filter_options`;
DROP TABLE IF EXISTS `category_filters`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `neighborhoods`;
DROP TABLE IF EXISTS `cities`;
DROP TABLE IF EXISTS `countries`;
DROP TABLE IF EXISTS `personal_access_tokens`;
DROP TABLE IF EXISTS `failed_jobs`;
DROP TABLE IF EXISTS `job_batches`;
DROP TABLE IF EXISTS `jobs`;
DROP TABLE IF EXISTS `cache_locks`;
DROP TABLE IF EXISTS `cache`;
DROP TABLE IF EXISTS `sessions`;
DROP TABLE IF EXISTS `password_reset_tokens`;
DROP TABLE IF EXISTS `users`;

-- SCHEMA DDL (ENGINE=InnoDB, VARCHAR(191) KEYS) --

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `phone_code` varchar(10) NOT NULL DEFAULT "+965",
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT "0",
  `is_verified` tinyint(1) NOT NULL DEFAULT "0",
  `member_type` varchar(191) NOT NULL DEFAULT "Free Member",
  `member_id_number` varchar(20) DEFAULT NULL,
  `member_since` date DEFAULT NULL,
  `live_listings_limit` int NOT NULL DEFAULT "20",
  `rating` decimal(3,1) NOT NULL DEFAULT "0.0",
  `rating_count` int NOT NULL DEFAULT "0",
  `listing_credits` int NOT NULL DEFAULT "0",
  `vas_credits` int NOT NULL DEFAULT "0",
  `cv_completeness` int NOT NULL DEFAULT "0",
  `cv_views` int NOT NULL DEFAULT "0",
  `job_applications_count` int NOT NULL DEFAULT "0",
  `member_views` int NOT NULL DEFAULT "0",
  `whatsapp` varchar(191) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `password_reset_tokens` (
  `email` varchar(191) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sessions` (
  `id` varchar(191) NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cache` (
  `key` varchar(191) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cache_locks` (
  `key` varchar(191) NOT NULL,
  `owner` varchar(191) NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `job_batches` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `countries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `name_ar` varchar(191) NOT NULL,
  `code` varchar(10) NOT NULL,
  `phone_code` varchar(10) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `currency_ar` varchar(10) NOT NULL,
  `flag` varchar(10) NOT NULL DEFAULT "🇰🇼",
  `is_default` tinyint(1) NOT NULL DEFAULT "0",
  `is_active` tinyint(1) NOT NULL DEFAULT "1",
  `pos` int NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `countries_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `country_id` bigint unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `name_ar` varchar(191) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT "1",
  `pos` int NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cities_country_id_pos_index` (`country_id`,`pos`),
  CONSTRAINT `cities_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `neighborhoods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `city_id` bigint unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `name_ar` varchar(191) NOT NULL,
  `pos` int NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `neighborhoods_city_id_pos_index` (`city_id`,`pos`),
  CONSTRAINT `neighborhoods_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint unsigned DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `name_ar` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `icon` varchar(191) DEFAULT NULL,
  `banner_image` varchar(255) DEFAULT NULL,
  `pos` int NOT NULL DEFAULT "0",
  `is_active` tinyint(1) NOT NULL DEFAULT "1",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_slug_unique` (`slug`),
  KEY `categories_parent_id_pos_index` (`parent_id`,`pos`),
  CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `category_filters` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint unsigned DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `name_ar` varchar(191) DEFAULT NULL,
  `filter_key` varchar(191) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT "select",
  `is_pinned` tinyint(1) NOT NULL DEFAULT "1",
  `pos` int NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_filters_category_id_pos_index` (`category_id`,`pos`),
  KEY `category_filters_filter_key_index` (`filter_key`),
  CONSTRAINT `category_filters_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `category_filter_options` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category_filter_id` bigint unsigned NOT NULL,
  `label` varchar(191) NOT NULL,
  `label_ar` varchar(191) DEFAULT NULL,
  `value` varchar(191) NOT NULL,
  `icon` varchar(191) DEFAULT NULL,
  `is_quick_card` tinyint(1) NOT NULL DEFAULT "0",
  `pos` int NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_filter_options_category_filter_id_pos_index` (`category_filter_id`,`pos`),
  KEY `category_filter_options_is_quick_card_index` (`is_quick_card`),
  CONSTRAINT `category_filter_options_category_filter_id_foreign` FOREIGN KEY (`category_filter_id`) REFERENCES `category_filters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ads` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `sub_category_id` bigint unsigned DEFAULT NULL,
  `country_id` bigint unsigned NOT NULL,
  `city_id` bigint unsigned NOT NULL,
  `neighborhood_id` bigint unsigned DEFAULT NULL,
  `neighborhood_name` varchar(191) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `title_ar` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `description_ar` text DEFAULT NULL,
  `price` decimal(12,2) NOT NULL DEFAULT "0.00",
  `currency` varchar(10) NOT NULL DEFAULT "KWD",
  `condition` varchar(50) NOT NULL DEFAULT "used",
  `attributes` json DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(50) DEFAULT NULL,
  `is_boosted` tinyint(1) NOT NULL DEFAULT "0",
  `is_featured` tinyint(1) NOT NULL DEFAULT "0",
  `views_count` int NOT NULL DEFAULT "0",
  `favorites_count` int NOT NULL DEFAULT "0",
  `status` varchar(50) NOT NULL DEFAULT "active",
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ads_country_id_city_id_index` (`country_id`,`city_id`),
  KEY `ads_category_id_status_index` (`category_id`,`status`),
  KEY `ads_is_boosted_index` (`is_boosted`),
  KEY `ads_is_featured_index` (`is_featured`),
  KEY `ads_published_at_index` (`published_at`),
  CONSTRAINT `ads_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ads_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ads_sub_category_id_foreign` FOREIGN KEY (`sub_category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ads_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ads_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ads_neighborhood_id_foreign` FOREIGN KEY (`neighborhood_id`) REFERENCES `neighborhoods` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ad_media` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ad_id` bigint unsigned NOT NULL,
  `type` enum("image","video") NOT NULL DEFAULT "image",
  `file_path` varchar(255) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT "0",
  `pos` int NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ad_media_ad_id_pos_index` (`ad_id`,`pos`),
  CONSTRAINT `ad_media_ad_id_foreign` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `seller_stories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `ad_id` bigint unsigned DEFAULT NULL,
  `media_path` varchar(255) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `ring_color` varchar(50) NOT NULL DEFAULT "orange",
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT "1",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `seller_stories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `seller_stories_ad_id_foreign` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `saved_searches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `title` varchar(191) DEFAULT NULL,
  `category_id` bigint unsigned DEFAULT NULL,
  `city_id` bigint unsigned DEFAULT NULL,
  `filters` json DEFAULT NULL,
  `notify_on_new` tinyint(1) NOT NULL DEFAULT "1",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `saved_searches_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `saved_searches_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `saved_searches_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `favorites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `ad_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `favorites_user_id_ad_id_unique` (`user_id`,`ad_id`),
  CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorites_ad_id_foreign` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `price_drop_alerts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `ad_id` bigint unsigned NOT NULL,
  `target_price` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `price_drop_alerts_user_id_ad_id_unique` (`user_id`,`ad_id`),
  CONSTRAINT `price_drop_alerts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `price_drop_alerts_ad_id_foreign` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ad_id` bigint unsigned DEFAULT NULL,
  `sender_id` bigint unsigned NOT NULL,
  `receiver_id` bigint unsigned NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT "0",
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `messages_sender_id_receiver_id_index` (`sender_id`,`receiver_id`),
  KEY `messages_receiver_id_is_read_index` (`receiver_id`,`is_read`),
  CONSTRAINT `messages_ad_id_foreign` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_receiver_id_foreign` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- SEED DATA --

-- Records of countries --
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (1, 'Kuwait', 'الكويت', 'KW', '+965', 'KWD', 'د.ك', '🇰🇼', 1, 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (2, 'Saudi Arabia', 'المملكة العربية السعودية', 'SA', '+966', 'SAR', 'ر.س', '🇸🇦', 0, 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (3, 'United Arab Emirates', 'الإمارات العربية المتحدة', 'AE', '+971', 'AED', 'د.إ', '🇦🇪', 0, 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (4, 'Qatar', 'قطر', 'QA', '+974', 'QAR', 'ر.ق', '🇶🇦', 0, 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (5, 'Bahrain', 'البحرين', 'BH', '+973', 'BHD', 'د.ب', '🇧🇭', 0, 1, 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `countries` (`id`, `name`, `name_ar`, `code`, `phone_code`, `currency`, `currency_ar`, `flag`, `is_default`, `is_active`, `pos`, `created_at`, `updated_at`) VALUES (6, 'Oman', 'سلطنة عمان', 'OM', '+968', 'OMR', 'ر.ع', '🇴🇲', 0, 1, 6, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- Records of cities --
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

-- Records of neighborhoods --
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'Sharq', 'شرق', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'Mirqab', 'المرقاب', 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (3, 1, 'Dasman', 'دسمان', 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (4, 1, 'Shuwaikh', 'الشويخ', 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (5, 8, 'Al Munsiyah', 'المنسية', 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (6, 8, 'Al Malaz', 'الملز', 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (7, 8, 'Al Olaya', 'العليا', 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (8, 8, 'Al Narjis', 'النرجس', 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `neighborhoods` (`id`, `city_id`, `name`, `name_ar`, `pos`, `created_at`, `updated_at`) VALUES (9, 8, 'Al Yasmin', 'الياسمين', 5, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- Records of categories --
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

-- Records of category_filters --
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'Condition', 'الحالة', 'condition', 'pills', 1, 1, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'Car Make', 'الشركة المصنعة', 'car_make', 'brands_grid', 1, 2, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (3, 1, 'Model', 'الموديل', 'model', 'select', 1, 3, '2026-10-04 17:44:30', '2026-10-04 17:44:30');
INSERT INTO `category_filters` (`id`, `category_id`, `name`, `name_ar`, `filter_key`, `type`, `is_pinned`, `pos`, `created_at`, `updated_at`) VALUES (4, 1, 'Transmission', 'ناقل الحركة', 'transmission', 'pills', 1, 4, '2026-10-04 17:44:30', '2026-10-04 17:44:30');

-- Records of category_filter_options --
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

-- Records of users --
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (1, 'KuwaitSouq Admin', 'admin@kuwaitsouq.online', NULL, '$2y$12$JsdIyt93i5unrTyM0tKCOezpnlyhIVN5PGG/4SezfE8qDzJ/GDvP6', NULL, '2026-10-04 17:44:30', '2026-10-04 17:44:30', '99001122', '+965', NULL, 1, 1, 'Admin', '10000001', '2024-01-01', 500, 5, 48, 100, 50, 100, 45, 0, 2400, '+96599001122');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (2, 'Al Sayer Certified Motors', 'alsayer@kuwaitsouq.online', NULL, '$2y$12$xPdoWJLqGFACHCZ8gEgcAOHhJFXWLZaUP1xhjYuWBQOgpsJ5WJ0T2', NULL, '2026-10-04 17:44:30', '2026-10-04 18:15:40', '98765432', '+965', NULL, 0, 1, 'Dealer Member', '81355485', '2024-05-01', 100, 4.9, 120, 50, 20, 95, 120, 0, 1850, '+96598765432');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (3, 'Gulf Elite Real Estate', 'realestate@kuwaitsouq.online', NULL, '$2y$12$xSchRQ5cBaS9ywI.wk3vg.U3lcpAgL/RKDQIEUTigmS4Vsk9pQCRW', NULL, '2026-10-04 17:44:30', '2026-10-04 17:44:30', '94455667', '+965', NULL, 0, 1, 'Verified Office', '28794008', '2023-08-17', 50, 4.8, 85, 25, 10, 90, 80, 0, 1420, '+96594455667');
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `phone`, `phone_code`, `avatar`, `is_admin`, `is_verified`, `member_type`, `member_id_number`, `member_since`, `live_listings_limit`, `rating`, `rating_count`, `listing_credits`, `vas_credits`, `cv_completeness`, `cv_views`, `job_applications_count`, `member_views`, `whatsapp`) VALUES (4, 'Ahmed Al-Mutawa', 'ahmed@kuwaitsouq.online', NULL, '$2y$12$frPCwmTmbj1tZoWLUV6sxeBCKGqOeHr.AzFo65b0YIqxkTrSpxeN6', NULL, '2026-10-07 17:40:51', '2026-10-07 17:40:51', '97711223', '+965', NULL, 0, 1, 'Standard Member', '54921044', '2025-01-10', 20, 4.7, 14, 10, 5, 80, 15, 0, 310, '+96597711223');

-- Records of ads --
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (1, 2, 1, 2, 1, 1, 4, 'Shuwaikh', 'Toyota Land Cruiser VXR 2024 Kuwait Agency', 'تويوتا لاند كروزر VXR 2024 وكالة الساير الكويت', 'Kuwait Al-Sayer agency, 0 km, Twin Turbo VXR, sunroof, tan leather, 360 cameras, radar, blind spot, rear entertainment screens, 5-year agency warranty with free service.', 'وارد الساير، عداد 0 كم، كامل المواصفات VXR محرك Twin Turbo، فتحة سقف، جلد تان فاخر، كاميرات 360، رادار ونقطة عمياء، شاشات خلفية، كفالة الساير 5 سنوات وسيرفس مجاني.', 26500, 'KWD', 'new', '{"car_make": "toyota", "model": "land_cruiser", "year": "2024", "transmission": "automatic", "condition": "new"}', '+965 98765432', '+96598765432', 1, 1, 1250, 45, 'active', '2026-10-10 10:00:00', '2026-10-10 10:00:00', '2026-10-10 10:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (2, 2, 1, 2, 1, 1, 4, 'الشويخ الصناعية', 'Lexus LX600 VIP 2024 Kuwait Al-Sayer Full Option', 'لكزس LX600 VIP 2024 وكالة الساير صبغ وكالة فل أوبشن', 'VIP Edition 4-seat executive, touch screens, cool box, hydraulic suspension, 12,000 km, mint agency condition, full body protection and ceramic tint, warranty until 2029.', 'فئة VIP أعلى درجة 4 مقاعد مفصولة، شاشات لمس، ثلاجة، هيدروليك، عداد 12,000 كم، بحالة الوكالة تماماً، حماية كاملة وعازل حراري أصلي، كفالة الساير لغاية 2029.', 46500, 'KWD', 'new', '{"car_make": "lexus", "model": "lx600", "year": "2024", "transmission": "automatic", "condition": "new"}', '+965 98765432', '+96598765432', 1, 1, 980, 62, 'active', '2026-10-10 11:30:00', '2026-10-10 11:30:00', '2026-10-10 11:30:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (3, 1, 1, 2, 1, 3, NULL, 'السالمية', 'Nissan Patrol Platinum 2023 V8 Kuwait Al-Babtain Agency', 'نيسان باترول بلاتينيوم 2023 V8 بحالة ممتازة وكالة البابطين', 'V8 400hp, Kuwait Al-Babtain agency, 28,000 km, regular agency service, sunroof, tan leather, radar, cooled/heated seats, original paint, inspection guaranteed.', 'مكينة 400 حصان 8 سلندر، وكالة البابطين، عداد 28,000 كم، سيرفس منتظم بالوكالة، فتحة سقف، جلد تان، رادار، كراسي تبريد وتدفئة، صبغ وكالة شرط الفحص بالكامل.', 21800, 'KWD', 'used', '{"car_make": "nissan", "model": "patrol", "year": "2023", "transmission": "automatic", "condition": "used"}', '+965 99001122', '+96599001122', 1, 1, 740, 28, 'active', '2026-10-09 14:00:00', '2026-10-09 14:00:00', '2026-10-09 14:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (4, 4, 1, 2, 1, 2, NULL, 'حولي', 'Porsche Cayenne Coupe GTS 2022 Kuwait Behbehani', 'بورش كايين كوبيه GTS 2022 وكالة بهبهاني كفالة شاملة', 'Behbehani agency Kuwait, 36,000 km, GTS sports exhaust, panoramic roof, full carbon fiber, red GTS leather/alcantara seats, under warranty with full service history.', 'وكالة بهبهاني الكويت، عداد 36,000 كم، اكزوز رياضي GTS، سقف بانوراما، كاربون فايبر كامل، كراسي GTS مخمل وجلد أحمر، تحت كفالة بهبهاني وسيرفس منتظم.', 31000, 'KWD', 'used', '{"car_make": "porsche", "model": "cayenne", "year": "2022", "transmission": "automatic", "condition": "used"}', '+965 97711223', '+96597711223', 1, 1, 890, 39, 'active', '2026-10-09 16:00:00', '2026-10-09 16:00:00', '2026-10-09 16:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (5, 2, 1, 2, 1, 4, NULL, 'الفروانية - الري', 'Ford F-150 Raptor 37 Package 2023 Alghanim', 'فورد رابتر F-150 باكج 37 موديل 2023 وكالة الغانم', 'Original 37 package, Fox Racing Live Valve suspension, panoramic roof, B&O Unleashed audio, 19,000 km, pristine condition, full inspection guarantee.', 'بكج 37 إنش الأصلي، شواصي Fox Racing Live Valve، سقف بانوراما، سماعات B&O Unleashed، عداد 19,000 كم، استخدام شخصي راقي جداً شرط الفحص بالكامل.', 24500, 'KWD', 'used', '{"car_make": "ford", "model": "f150", "year": "2023", "transmission": "automatic", "condition": "used"}', '+965 98765432', '+96598765432', 1, 1, 620, 31, 'active', '2026-10-08 12:00:00', '2026-10-08 12:00:00', '2026-10-08 12:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (6, 1, 1, 2, 1, 1, 1, 'شرق', 'Mercedes-Benz G63 AMG 2023 Night Package Al-Mulla', 'مرسيدس G63 AMG 2023 نايت بكج وكالة الملا بحالة الوكالة', 'Al Mulla agency Kuwait, 15,000 km, Night Package, 22-inch forged AMG wheels, Designo diamond red/black leather, full matte protection, flawless agency condition.', 'وارد الملا الكويت، عداد 15,000 كم، نايت بكج أصلي، جنوط 22 إنش فورجد، كراسي ديزاينو دايموند أحمر وأسود، حماية كاملة مطفية، صبغ وكالة وخالية من الحوادث.', 54000, 'KWD', 'used', '{"car_make": "mercedes", "model": "g63", "year": "2023", "transmission": "automatic", "condition": "used"}', '+965 99001122', '+96599001122', 1, 1, 1450, 95, 'active', '2026-10-08 15:00:00', '2026-10-08 15:00:00', '2026-10-08 15:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (7, 2, 1, 2, 1, 1, 4, 'الشويخ', 'BMW 735i M-Sport 2023 Ali Alghanim Agency', 'بي إم دبليو 735i M-Sport 2023 وكالة علي الغانم', 'All-new 7 Series M-Sport, Ali Alghanim agency, 31-inch 8K theater screen, crystal interaction bar, autonomous driving package, full warranty and service till 2028.', 'الفئة السابعة الجديدة كلياً M-Sport، وكالة علي الغانم، شاشة سينما خلفية 31 إنش 8K، إضاءة كريستال تفاعلية، قيادة ذاتية ورادار، كفالة وسيرفس شامل لغاية 2028.', 28500, 'KWD', 'used', '{"car_make": "bmw", "model": "735i", "year": "2023", "transmission": "automatic", "condition": "used"}', '+965 98765432', '+96598765432', 0, 1, 510, 22, 'active', '2026-10-07 10:00:00', '2026-10-07 10:00:00', '2026-10-07 10:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (8, 4, 1, 2, 1, 7, NULL, 'مبارك الكبير', 'Toyota Camry Grande V6 2023 Al-Sayer Kuwait', 'تويوتا كامري قراندي V6 2023 وكالة الساير الكويت', 'Camry Grande V6 full option, sunroof, navigation, beige leather, power seats, 32,000 km regular Al-Sayer service, original agency paint, full inspection guaranteed.', 'كامري فل أوبشن قراندي 6 سلندر، فتحة سقف، شاشة ملاحة وكاميرا، جلد بيج، كراسي كهرباء، عداد 32,000 كم سيرفس منتظم بالساير، صبغ وكالة شرط الفحص جير ومكينة وشاصي.', 8400, 'KWD', 'used', '{"car_make": "toyota", "model": "camry", "year": "2023", "transmission": "automatic", "condition": "used"}', '+965 97711223', '+96597711223', 0, 0, 430, 18, 'active', '2026-10-07 13:00:00', '2026-10-07 13:00:00', '2026-10-07 13:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (9, 3, 9, NULL, 1, 5, NULL, 'مدينة صباح الأحمد البحرية (الخيران)', 'Chalet For Rent in Khiran Creek Front Sea View', 'شاليه للإيجار في مدينة صباح الأحمد البحرية (الخيران) صف أول', 'Luxury creek front chalet in Sabah Al-Ahmad Sea City (Khiran Phase 4), 6 master bedrooms, private heated pool, outdoor sea view lounge, private boat & jet ski dock.', 'شاليه راقي ومميز على الخور مباشرة صف أول المرحلة الرابعة، 6 غرف ماستر، مسبح خاص معقم بنظام تدفئة، جلسات خارجية مطلة على البحر، مرسى طراريد وجت سكي.', 450, 'KWD', 'new', '{"property_type": "chalet", "bedrooms": 6, "bathrooms": 7, "pool": "private", "view": "sea_front"}', '+965 94455667', '+96594455667', 1, 1, 1680, 84, 'active', '2026-10-10 09:00:00', '2026-10-10 09:00:00', '2026-10-10 09:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (10, 3, 9, NULL, 1, 3, NULL, 'السالمية شارع بغداد', 'Luxury 3BR Apartment For Rent in Salmiya Sea View', 'شقة فندقية للإيجار في السالمية إطلالة بحرية بانورامية 3 غرف', 'Ultra luxury apartment in Salmiya Baghdad / Blajat street, direct panoramic sea view, 3 bedrooms, spacious living hall, gym, pool, private parking and 24/7 security.', 'شقة فاخرة للإيجار السالمية شارع البلاجات إطلالة بحرية مباشرة، 3 غرف نوم وصالة واسعة، مسبح ونادي صحي، حراسة ومواقف خاصة ومصاعد سريعة شامل الصيانة.', 750, 'KWD', 'used', '{"property_type": "apartment", "bedrooms": 3, "bathrooms": 3, "view": "sea_view"}', '+965 94455667', '+96594455667', 0, 1, 1120, 52, 'active', '2026-10-09 11:00:00', '2026-10-09 11:00:00', '2026-10-09 11:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (11, 3, 9, NULL, 1, 1, 4, 'الشويخ الصناعية', 'Commercial Showroom for Rent in Shuwaikh Industrial Prime Location', 'معرض ومحل تجاري للإيجار في الشويخ الصناعية موقع مميز جداً', '140 sqm commercial space with mezzanine in Shuwaikh Industrial, wide glass facade on busy main road, ample front parking, central AC, suitable for high-end retail/services.', 'مساحة 140 متر مربع مع ميزانين، واجهة زجاجية عريضة على شارع حيوي، مواقف سيارات واسعة أمام المحل، جاهز مع ديكورات وتكييف مركزي، يصلح لكافة الأنشطة التجارية.', 1400, 'KWD', 'new', '{"property_type": "commercial", "area": "140sqm", "mezzanine": true}', '+965 94455667', '+96594455667', 1, 0, 530, 29, 'active', '2026-10-08 17:00:00', '2026-10-08 17:00:00', '2026-10-08 17:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (12, 1, 10, NULL, 1, 1, 1, 'شرق', 'iPhone 16 Pro Max 256GB Desert Titanium Sealed Box', 'آيفون 16 برو ماكس 256 جيجا تيتانيوم صحراوي كرتون مختوم كفالة الغانم', 'Apple iPhone 16 Pro Max 256GB Desert Titanium, brand new factory sealed with local Xcite Alghanim 1-year Kuwait warranty and official purchase receipt.', 'أبل آيفون 16 برو ماكس 256 جيجابايت، اللون التيتانيوم الصحراوي الجديد، جهاز جديد بالكرتون متبرشم بكفالة الغانم إكسترا لمدة سنة كاملة مع الفاتورة الرسمية.', 389, 'KWD', 'new', '{"brand": "apple", "model": "iphone_16_pro_max", "storage": "256gb", "color": "desert_titanium", "condition": "new"}', '+965 99001122', '+96599001122', 1, 1, 1890, 110, 'active', '2026-10-10 12:00:00', '2026-10-10 12:00:00', '2026-10-10 12:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (13, 4, 10, NULL, 1, 2, NULL, 'حولي شارع ابن خلدون', 'Apple MacBook Pro 16 M3 Max 36GB RAM 1TB SSD Space Black', 'ماك بوك برو 16 إنش M3 Max رام 36 جيجا هارد 1 تيرا كالجديد', 'MacBook Pro 16-inch M3 Max chip, 36GB unified memory, 1TB SSD, Space Black, pristine mint condition with battery cycle count under 20, complete box and MagSafe charger.', 'ماك بوك برو 16 إنش شريحة M3 Max الأقوى، رام 36 جيجابايت، سعة 1 تيرا SSD، اللون الأسود الفضائي Space Black، استخدام خفيف جداً مع الفاتورة والكرتون والشاحن الأصلي.', 920, 'KWD', 'used', '{"brand": "apple", "processor": "m3_max", "ram": "36gb", "storage": "1tb_ssd", "condition": "used"}', '+965 97711223', '+96597711223', 0, 1, 740, 42, 'active', '2026-10-09 18:00:00', '2026-10-09 18:00:00', '2026-10-09 18:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (14, 4, 10, NULL, 1, 2, NULL, 'حولي', 'Sony PlayStation 5 Slim 1TB Disc Edition with 2 Controllers', 'بلايستيشن 5 سليم بالقرص 1 تيرا مع جيرين أصليين كفالة محلية', 'Sony PS5 Slim Disc Edition 1TB with 2 original DualSense wireless controllers, brand new sealed with local Kuwait agent warranty.', 'جهاز سوني بلايستيشن 5 النسخة النحيفة Slim مع قارئ الأقراص، سعة 1 تيرا، يشمل جيرين دوال سينس أصليين، كفالة الوكيل المحلي بالكويت سنة كاملة، جديد بالكرتون.', 155, 'KWD', 'new', '{"brand": "sony", "model": "ps5_slim", "edition": "disc", "storage": "1tb"}', '+965 97711223', '+96597711223', 0, 0, 580, 34, 'active', '2026-10-08 14:00:00', '2026-10-08 14:00:00', '2026-10-08 14:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (15, 1, 1, 8, 1, 6, NULL, 'الجهراء', 'Yamaha Raptor 700R Special Edition 2023 with Trailer', 'ياماها رابتر 700R سبيشل اديشن 2023 نظيف جداً مع عربانة', 'Yamaha Raptor 700R 2023 Special Edition, mint condition, low operating hours, customized nerf bars, comes with registered towing trailer, ready for winter season.', 'سيكل ياماها رابتر 700R موديل 2023 سبيشل اديشن، بحالة الوكالة تماماً، تزويد خفيف، استخدام ساعات قليلة، مع القلص والعربانة مسجلة بالمرور جاهز للموسم.', 2850, 'KWD', 'used', '{"make": "yamaha", "model": "raptor_700r", "year": "2023", "condition": "used"}', '+965 99001122', '+96599001122', 1, 1, 910, 58, 'active', '2026-10-10 15:00:00', '2026-10-10 15:00:00', '2026-10-10 15:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (16, 2, 1, 8, 1, 5, NULL, 'الأحمدي - الوفرة', 'Can-Am Maverick X3 X RS Turbo RR 2023 200HP', 'كان ام مافريك X3 تيربو RR موديل 2023 تزويد كامل وكالة', 'Can-Am Maverick X3 Turbo RR 200hp, agency import, regular maintenance, original roof, Rigid LED bar, 4-point harnesses, reinforced roll cage, immaculate condition.', 'كان ام مافريك 200 حصان، وارد الوكالة سيرفس منتظم، سقف أصلي، ليد بار ريجيد، حزام أمان سباق 4 نقاط، قفص حماية معزز، استخدام راقي جداً شرط الفحص.', 8400, 'KWD', 'used', '{"make": "can_am", "model": "maverick_x3", "year": "2023", "horsepower": 200}', '+965 98765432', '+96598765432', 1, 1, 1340, 77, 'active', '2026-10-09 17:00:00', '2026-10-09 17:00:00', '2026-10-09 17:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (17, 4, 1, 8, 1, 3, NULL, 'السالمية مارينا', 'Sea-Doo RXT-X 300 Jet Ski 2023 Supercharged with Audio', 'جت سكي سي دو RXT-X 300 سوبرتشارج 2023 سماعات أصلية', 'Sea-Doo RXT-X 300 supercharged Rotax engine, factory BRP premium Bluetooth audio system, full color display, boarding ladder, mint condition with aluminum trailer.', 'سي دو RXT-X 300 موديل 2023 محرك روتكس سوبر تشارج، نظام صوت بلوتوث BRP الأصلي، شاشة ملونة، سلالم صعود، بحالة الوكالة مع قالوصة ألمنيوم مرخصة.', 4100, 'KWD', 'used', '{"make": "sea_doo", "model": "rxt_x_300", "year": "2023", "supercharged": true}', '+965 97711223', '+96597711223', 0, 1, 820, 46, 'active', '2026-10-08 16:00:00', '2026-10-08 16:00:00', '2026-10-08 16:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (18, 3, 12, NULL, 1, 1, NULL, 'كافة مناطق الكويت', 'Professional Parquet & Marble Flooring Installation Kuwait', 'فني تركيب باركيه وأرضيات خشبية ورخام بالكويت خبرة 15 عاماً', 'Comprehensive supply and installation of German & Swiss parquet, marble, luxury vinyl tiles, and moisture barriers. Serving all Kuwait governorates with full warranty.', 'خدمات متكاملة لتوريد وتركيب أرضيات الباركيه الألمانية والسويسرية، الرخام، الفينيل، وعزل الأرضيات، دقة وسرعة في العمل مع ضمان شامل على التركيب لكافة مناطق الكويت.', 25, 'KWD', 'new', '{"service_type": "flooring_installation", "warranty": "yes", "coverage": "all_kuwait"}', '+965 94455667', '+96594455667', 1, 0, 490, 31, 'active', '2026-10-10 08:00:00', '2026-10-10 08:00:00', '2026-10-10 08:00:00');
INSERT INTO `ads` (`id`, `user_id`, `category_id`, `sub_category_id`, `country_id`, `city_id`, `neighborhood_id`, `neighborhood_name`, `title`, `title_ar`, `description`, `description_ar`, `price`, `currency`, `condition`, `attributes`, `phone`, `whatsapp`, `is_boosted`, `is_featured`, `views_count`, `favorites_count`, `status`, `published_at`, `created_at`, `updated_at`) VALUES (19, 1, 12, NULL, 1, 1, 4, 'الشويخ الصناعية', 'Luxury Car Detailing & Nano Ceramic Coating Shuwaikh', 'مركز تلميع سيارات وحماية نانو سيراميك الشويخ الصناعية', 'German 9H nano ceramic coating package with comprehensive interior/exterior detailing, multi-stage paint correction, steam interior sanitization, and 3-year warranty.', 'باقة حماية النانو سيراميك 9H الألمانية مع تلميع داخلي وخارجي شامل وإزالة الخدوش، تنظيف الفرش بالبخار والتعقيم بالأوزون، كفالة 3 سنوات وسيرفس دوري مجاني.', 75, 'KWD', 'new', '{"service_type": "car_detailing", "coating": "ceramic_9h", "warranty": "3_years"}', '+965 99001122', '+96599001122', 1, 1, 670, 38, 'active', '2026-10-09 13:00:00', '2026-10-09 13:00:00', '2026-10-09 13:00:00');

-- Records of ad_media --
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (1, 1, 'image', 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=1200', 1, 1, '2026-10-10 10:00:00', '2026-10-10 10:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (2, 1, 'image', 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=1200', 0, 2, '2026-10-10 10:00:00', '2026-10-10 10:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (3, 2, 'image', 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=1200', 1, 1, '2026-10-10 11:30:00', '2026-10-10 11:30:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (4, 2, 'image', 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200', 0, 2, '2026-10-10 11:30:00', '2026-10-10 11:30:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (5, 3, 'image', 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=1200', 1, 1, '2026-10-09 14:00:00', '2026-10-09 14:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (6, 4, 'image', 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=1200', 1, 1, '2026-10-09 16:00:00', '2026-10-09 16:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (7, 4, 'image', 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200', 0, 2, '2026-10-09 16:00:00', '2026-10-09 16:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (8, 5, 'image', 'https://images.unsplash.com/photo-1551830820-330a71b99659?w=1200', 1, 1, '2026-10-08 12:00:00', '2026-10-08 12:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (9, 6, 'image', 'https://images.unsplash.com/photo-1520031441872-265e4ff70366?w=1200', 1, 1, '2026-10-08 15:00:00', '2026-10-08 15:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (10, 7, 'image', 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=1200', 1, 1, '2026-10-07 10:00:00', '2026-10-07 10:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (11, 8, 'image', 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=1200', 1, 1, '2026-10-07 13:00:00', '2026-10-07 13:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (12, 9, 'image', 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=1200', 1, 1, '2026-10-10 09:00:00', '2026-10-10 09:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (13, 9, 'image', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=1200', 0, 2, '2026-10-10 09:00:00', '2026-10-10 09:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (14, 10, 'image', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=1200', 1, 1, '2026-10-09 11:00:00', '2026-10-09 11:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (15, 11, 'image', 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=1200', 1, 1, '2026-10-08 17:00:00', '2026-10-08 17:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (16, 12, 'image', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=1200', 1, 1, '2026-10-10 12:00:00', '2026-10-10 12:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (17, 13, 'image', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=1200', 1, 1, '2026-10-09 18:00:00', '2026-10-09 18:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (18, 14, 'image', 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=1200', 1, 1, '2026-10-08 14:00:00', '2026-10-08 14:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (19, 15, 'image', 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=1200', 1, 1, '2026-10-10 15:00:00', '2026-10-10 15:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (20, 16, 'image', 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=1200', 1, 1, '2026-10-09 17:00:00', '2026-10-09 17:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (21, 17, 'image', 'https://images.unsplash.com/photo-1569263979104-865ab7cd8d17?w=1200', 1, 1, '2026-10-08 16:00:00', '2026-10-08 16:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (22, 18, 'image', 'https://images.unsplash.com/photo-1581858726788-75bc0f6a952d?w=1200', 1, 1, '2026-10-10 08:00:00', '2026-10-10 08:00:00');
INSERT INTO `ad_media` (`id`, `ad_id`, `type`, `file_path`, `is_primary`, `pos`, `created_at`, `updated_at`) VALUES (23, 19, 'image', 'https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=1200', 1, 1, '2026-10-09 13:00:00', '2026-10-09 13:00:00');

-- Records of seller_stories --
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (1, 2, 1, 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=600', 'لاندكروزر 2024 VXR جديد بالكرتون وكالة الساير', 'blue', '2026-10-25 10:00:00', 1, '2026-10-10 10:00:00', '2026-10-10 10:00:00');
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (2, 2, 2, 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=600', 'لكزس VIP LX600 قمة الفخامة وارد الساير', 'orange', '2026-10-25 11:30:00', 1, '2026-10-10 11:30:00', '2026-10-10 11:30:00');
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (3, 3, 9, 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=600', 'شاليه الخيران صف أول مسبح خاص ومرسى جت سكي', 'green', '2026-10-25 09:00:00', 1, '2026-10-10 09:00:00', '2026-10-10 09:00:00');
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (4, 1, 12, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600', 'آيفون 16 برو ماكس كرتون متبرشم كفالة الغانم', 'orange', '2026-10-25 12:00:00', 1, '2026-10-10 12:00:00', '2026-10-10 12:00:00');
INSERT INTO `seller_stories` (`id`, `user_id`, `ad_id`, `media_path`, `caption`, `ring_color`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES (5, 2, 16, 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=600', 'كان ام مافريك تيربو RR جاهز للموسم الشتوي', 'blue', '2026-10-25 17:00:00', 1, '2026-10-09 17:00:00', '2026-10-09 17:00:00');

-- Records of personal_access_tokens --
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES (1, 'App\\Models\\User', 4, 'mobile_app', '572a418bd498882d8c090f30c879233932ffaf9dd89acc6ea21f07a1a9e7b9cc', '["*"]', '2026-10-07 17:40:51', NULL, '2026-10-07 17:40:51', '2026-10-07 17:40:51');

SET FOREIGN_KEY_CHECKS=1;
