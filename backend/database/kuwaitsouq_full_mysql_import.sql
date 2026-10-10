
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
