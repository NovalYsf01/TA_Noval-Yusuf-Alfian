/*
 Navicat Premium Dump SQL

 Source Server         : noval
 Source Server Type    : MySQL
 Source Server Version : 100244 (10.2.44-MariaDB-1:10.2.44+maria~bionic-log)
 Source Host           : 192.168.100.35:14326
 Source Schema         : rt_rw

 Target Server Type    : MySQL
 Target Server Version : 100244 (10.2.44-MariaDB-1:10.2.44+maria~bionic-log)
 File Encoding         : 65001

 Date: 18/08/2026 23:03:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_log
-- ----------------------------
DROP TABLE IF EXISTS `activity_log`;
CREATE TABLE `activity_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `log_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `event` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `subject_id` bigint UNSIGNED NULL DEFAULT NULL,
  `causer_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `causer_id` bigint UNSIGNED NULL DEFAULT NULL,
  `properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `batch_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `subject`(`subject_type` ASC, `subject_id` ASC) USING BTREE,
  INDEX `causer`(`causer_type` ASC, `causer_id` ASC) USING BTREE,
  INDEX `activity_log_log_name_index`(`log_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity_log
-- ----------------------------
INSERT INTO `activity_log` VALUES (1, 'Resource', 'Role Created', 'Spatie\\Permission\\Models\\Role', 'Created', 1, NULL, NULL, '{\"guard_name\":\"web\",\"name\":\"super_admin\",\"updated_at\":\"2026-08-18 20:26:30\",\"created_at\":\"2026-08-18 20:26:30\",\"id\":1}', NULL, '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `activity_log` VALUES (2, 'Access', 'Admin logged in', 'App\\Models\\User', 'Login', 1, 'App\\Models\\User', 1, '{\"ip\":\"10.200.11.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/151.0.0.0 Safari\\/537.36\"}', NULL, '2026-08-18 22:54:00', '2026-08-18 22:54:00');
INSERT INTO `activity_log` VALUES (3, 'Access', 'Admin logged in', 'App\\Models\\User', 'Login', 1, 'App\\Models\\User', 1, '{\"ip\":\"10.200.11.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/151.0.0.0 Safari\\/537.36\"}', NULL, '2026-08-18 22:54:49', '2026-08-18 22:54:49');
INSERT INTO `activity_log` VALUES (4, 'Access', 'Admin logged in', 'App\\Models\\User', 'Login', 1, 'App\\Models\\User', 1, '{\"ip\":\"10.200.11.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/151.0.0.0 Safari\\/537.36\"}', NULL, '2026-08-18 22:55:06', '2026-08-18 22:55:06');
INSERT INTO `activity_log` VALUES (5, 'Access', 'Admin logged in', 'App\\Models\\User', 'Login', 1, 'App\\Models\\User', 1, '{\"ip\":\"10.200.11.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/151.0.0.0 Safari\\/537.36\"}', NULL, '2026-08-18 22:56:47', '2026-08-18 22:56:47');
INSERT INTO `activity_log` VALUES (6, 'Resource', 'Role Created', 'Spatie\\Permission\\Models\\Role', 'Created', 2, NULL, NULL, '{\"guard_name\":\"web\",\"name\":\"ketua_rt\",\"updated_at\":\"2026-08-18 22:57:01\",\"created_at\":\"2026-08-18 22:57:01\",\"id\":2}', NULL, '2026-08-18 22:57:01', '2026-08-18 22:57:01');
INSERT INTO `activity_log` VALUES (7, 'Resource', 'Role Created', 'Spatie\\Permission\\Models\\Role', 'Created', 3, NULL, NULL, '{\"guard_name\":\"web\",\"name\":\"warga\",\"updated_at\":\"2026-08-18 22:57:01\",\"created_at\":\"2026-08-18 22:57:01\",\"id\":3}', NULL, '2026-08-18 22:57:01', '2026-08-18 22:57:01');
INSERT INTO `activity_log` VALUES (8, 'Resource', 'User Updated', 'App\\Models\\User', 'Updated', 1, NULL, NULL, '{\"name\":\"Ketua RT 20\",\"updated_at\":\"2026-08-18 22:57:02\",\"username\":\"ketuart20\"}', NULL, '2026-08-18 22:57:02', '2026-08-18 22:57:02');
INSERT INTO `activity_log` VALUES (9, 'Access', 'Ketua RT 20 logged in', 'App\\Models\\User', 'Login', 1, 'App\\Models\\User', 1, '{\"ip\":\"10.200.11.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/151.0.0.0 Safari\\/537.36\"}', NULL, '2026-08-18 22:57:10', '2026-08-18 22:57:10');

-- ----------------------------
-- Table structure for cache
-- ----------------------------
DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache`  (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`) USING BTREE,
  INDEX `cache_expiration_index`(`expiration` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cache
-- ----------------------------
INSERT INTO `cache` VALUES ('noval-cache-spatie.permission.cache', 'a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:38:{i:0;a:4:{s:1:\"a\";i:1;s:1:\"b\";s:12:\"ViewAny:User\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:1;a:4:{s:1:\"a\";i:2;s:1:\"b\";s:9:\"View:User\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:2;a:4:{s:1:\"a\";i:3;s:1:\"b\";s:11:\"Create:User\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:3;a:4:{s:1:\"a\";i:4;s:1:\"b\";s:11:\"Update:User\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:4;a:4:{s:1:\"a\";i:5;s:1:\"b\";s:11:\"Delete:User\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:5;a:4:{s:1:\"a\";i:6;s:1:\"b\";s:12:\"ViewAny:Role\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:6;a:4:{s:1:\"a\";i:7;s:1:\"b\";s:9:\"View:Role\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:7;a:4:{s:1:\"a\";i:8;s:1:\"b\";s:11:\"Create:Role\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:8;a:4:{s:1:\"a\";i:9;s:1:\"b\";s:11:\"Update:Role\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:9;a:4:{s:1:\"a\";i:10;s:1:\"b\";s:11:\"Delete:Role\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:10;a:4:{s:1:\"a\";i:11;s:1:\"b\";s:16:\"ViewAny:Activity\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:11;a:4:{s:1:\"a\";i:12;s:1:\"b\";s:13:\"View:Activity\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:12;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:15:\"Create:Activity\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:13;a:4:{s:1:\"a\";i:14;s:1:\"b\";s:15:\"Update:Activity\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:14;a:4:{s:1:\"a\";i:15;s:1:\"b\";s:15:\"Delete:Activity\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:15;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:18:\"View:MyProfilePage\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:16;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:19:\"View:OverlookWidget\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:17;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:21:\"View:LatestAccessLogs\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:18;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:23:\"ViewAny:EmergencyReport\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:19;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:20:\"View:EmergencyReport\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:20;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:22:\"Create:EmergencyReport\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:21;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:22:\"Update:EmergencyReport\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:22;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:22:\"Delete:EmergencyReport\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:23;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:24:\"ViewAny:ImportantContact\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:24;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:21:\"View:ImportantContact\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:25;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:23:\"Create:ImportantContact\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:26;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:23:\"Update:ImportantContact\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:27;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:23:\"Delete:ImportantContact\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:28;a:4:{s:1:\"a\";i:29;s:1:\"b\";s:21:\"ViewAny:RtInformation\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:29;a:4:{s:1:\"a\";i:30;s:1:\"b\";s:18:\"View:RtInformation\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:30;a:4:{s:1:\"a\";i:31;s:1:\"b\";s:20:\"Create:RtInformation\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:31;a:4:{s:1:\"a\";i:32;s:1:\"b\";s:20:\"Update:RtInformation\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:32;a:4:{s:1:\"a\";i:33;s:1:\"b\";s:20:\"Delete:RtInformation\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:33;a:4:{s:1:\"a\";i:34;s:1:\"b\";s:22:\"ViewAny:ServiceRequest\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:34;a:4:{s:1:\"a\";i:35;s:1:\"b\";s:19:\"View:ServiceRequest\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:35;a:4:{s:1:\"a\";i:36;s:1:\"b\";s:21:\"Create:ServiceRequest\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:36;a:4:{s:1:\"a\";i:37;s:1:\"b\";s:21:\"Update:ServiceRequest\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:37;a:4:{s:1:\"a\";i:38;s:1:\"b\";s:21:\"Delete:ServiceRequest\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}}s:5:\"roles\";a:2:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:11:\"super_admin\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:8:\"ketua_rt\";s:1:\"c\";s:3:\"web\";}}}', 1787155225);

-- ----------------------------
-- Table structure for cache_locks
-- ----------------------------
DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks`  (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`) USING BTREE,
  INDEX `cache_locks_expiration_index`(`expiration` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cache_locks
-- ----------------------------

-- ----------------------------
-- Table structure for device_tokens
-- ----------------------------
DROP TABLE IF EXISTS `device_tokens`;
CREATE TABLE `device_tokens`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `token` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'android',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_seen_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `device_tokens_token_unique`(`token` ASC) USING BTREE,
  INDEX `device_tokens_user_id_is_active_index`(`user_id` ASC, `is_active` ASC) USING BTREE,
  CONSTRAINT `device_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_tokens
-- ----------------------------

-- ----------------------------
-- Table structure for emergency_reports
-- ----------------------------
DROP TABLE IF EXISTS `emergency_reports`;
CREATE TABLE `emergency_reports`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `emergency_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reported_at` timestamp NOT NULL DEFAULT current_timestamp,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `emergency_reports_user_id_reported_at_index`(`user_id` ASC, `reported_at` ASC) USING BTREE,
  INDEX `emergency_reports_emergency_type_index`(`emergency_type` ASC) USING BTREE,
  CONSTRAINT `emergency_reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of emergency_reports
-- ----------------------------

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `failed_jobs_uuid_unique`(`uuid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for important_contacts
-- ----------------------------
DROP TABLE IF EXISTS `important_contacts`;
CREATE TABLE `important_contacts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `important_contacts_is_active_category_index`(`is_active` ASC, `category` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of important_contacts
-- ----------------------------

-- ----------------------------
-- Table structure for job_batches
-- ----------------------------
DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `cancelled_at` int NULL DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of job_batches
-- ----------------------------

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED NULL DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `jobs_queue_index`(`queue` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of jobs
-- ----------------------------

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of migrations
-- ----------------------------
INSERT INTO `migrations` VALUES (1, '0001_01_01_000000_create_users_table', 1);
INSERT INTO `migrations` VALUES (2, '0001_01_01_000001_create_cache_table', 1);
INSERT INTO `migrations` VALUES (3, '0001_01_01_000002_create_jobs_table', 1);
INSERT INTO `migrations` VALUES (4, '0001_01_01_000003_create_notifications_table', 1);
INSERT INTO `migrations` VALUES (5, '0001_01_01_000004_create_permission_tables', 1);
INSERT INTO `migrations` VALUES (6, '0001_01_01_000005_create_activity_log_table', 1);
INSERT INTO `migrations` VALUES (7, '0001_01_01_000006_add_event_column_to_activity_log_table', 1);
INSERT INTO `migrations` VALUES (8, '0001_01_01_000007_add_batch_uuid_column_to_activity_log_table', 1);
INSERT INTO `migrations` VALUES (9, '2026_08_18_210001_extend_users_table_for_warga20', 2);
INSERT INTO `migrations` VALUES (10, '2026_08_18_210002_create_rt_informations_table', 2);
INSERT INTO `migrations` VALUES (11, '2026_08_18_210003_create_service_requests_table', 2);
INSERT INTO `migrations` VALUES (12, '2026_08_18_210004_create_service_request_status_histories_table', 2);
INSERT INTO `migrations` VALUES (13, '2026_08_18_210005_create_emergency_reports_table', 2);
INSERT INTO `migrations` VALUES (14, '2026_08_18_210006_create_important_contacts_table', 2);
INSERT INTO `migrations` VALUES (15, '2026_08_18_210007_create_device_tokens_table', 2);
INSERT INTO `migrations` VALUES (16, '2026_08_18_221353_create_personal_access_tokens_table', 2);

-- ----------------------------
-- Table structure for model_has_permissions
-- ----------------------------
DROP TABLE IF EXISTS `model_has_permissions`;
CREATE TABLE `model_has_permissions`  (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`permission_id`, `model_id`, `model_type`) USING BTREE,
  INDEX `model_has_permissions_model_id_model_type_index`(`model_id` ASC, `model_type` ASC) USING BTREE,
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of model_has_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for model_has_roles
-- ----------------------------
DROP TABLE IF EXISTS `model_has_roles`;
CREATE TABLE `model_has_roles`  (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `model_id`, `model_type`) USING BTREE,
  INDEX `model_has_roles_model_id_model_type_index`(`model_id` ASC, `model_type` ASC) USING BTREE,
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of model_has_roles
-- ----------------------------
INSERT INTO `model_has_roles` VALUES (1, 'App\\Models\\User', 1);
INSERT INTO `model_has_roles` VALUES (2, 'App\\Models\\User', 1);

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint UNSIGNED NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `notifications_notifiable_type_notifiable_id_index`(`notifiable_type` ASC, `notifiable_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications
-- ----------------------------

-- ----------------------------
-- Table structure for password_reset_tokens
-- ----------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens`  (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of password_reset_tokens
-- ----------------------------

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `permissions_name_guard_name_unique`(`name` ASC, `guard_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES (1, 'ViewAny:User', 'web', '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `permissions` VALUES (2, 'View:User', 'web', '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `permissions` VALUES (3, 'Create:User', 'web', '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `permissions` VALUES (4, 'Update:User', 'web', '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `permissions` VALUES (5, 'Delete:User', 'web', '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `permissions` VALUES (6, 'ViewAny:Role', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (7, 'View:Role', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (8, 'Create:Role', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (9, 'Update:Role', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (10, 'Delete:Role', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (11, 'ViewAny:Activity', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (12, 'View:Activity', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (13, 'Create:Activity', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (14, 'Update:Activity', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (15, 'Delete:Activity', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (16, 'View:MyProfilePage', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (17, 'View:OverlookWidget', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (18, 'View:LatestAccessLogs', 'web', '2026-08-18 20:26:31', '2026-08-18 20:26:31');
INSERT INTO `permissions` VALUES (19, 'ViewAny:EmergencyReport', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (20, 'View:EmergencyReport', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (21, 'Create:EmergencyReport', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (22, 'Update:EmergencyReport', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (23, 'Delete:EmergencyReport', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (24, 'ViewAny:ImportantContact', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (25, 'View:ImportantContact', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (26, 'Create:ImportantContact', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (27, 'Update:ImportantContact', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (28, 'Delete:ImportantContact', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (29, 'ViewAny:RtInformation', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (30, 'View:RtInformation', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (31, 'Create:RtInformation', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (32, 'Update:RtInformation', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (33, 'Delete:RtInformation', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (34, 'ViewAny:ServiceRequest', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (35, 'View:ServiceRequest', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (36, 'Create:ServiceRequest', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (37, 'Update:ServiceRequest', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');
INSERT INTO `permissions` VALUES (38, 'Delete:ServiceRequest', 'web', '2026-08-18 22:55:02', '2026-08-18 22:55:02');

-- ----------------------------
-- Table structure for personal_access_tokens
-- ----------------------------
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `personal_access_tokens_token_unique`(`token` ASC) USING BTREE,
  INDEX `personal_access_tokens_tokenable_type_tokenable_id_index`(`tokenable_type` ASC, `tokenable_id` ASC) USING BTREE,
  INDEX `personal_access_tokens_expires_at_index`(`expires_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of personal_access_tokens
-- ----------------------------

-- ----------------------------
-- Table structure for role_has_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_has_permissions`;
CREATE TABLE `role_has_permissions`  (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`permission_id`, `role_id`) USING BTREE,
  INDEX `role_has_permissions_role_id_foreign`(`role_id` ASC) USING BTREE,
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_has_permissions
-- ----------------------------
INSERT INTO `role_has_permissions` VALUES (1, 1);
INSERT INTO `role_has_permissions` VALUES (1, 2);
INSERT INTO `role_has_permissions` VALUES (2, 1);
INSERT INTO `role_has_permissions` VALUES (2, 2);
INSERT INTO `role_has_permissions` VALUES (3, 1);
INSERT INTO `role_has_permissions` VALUES (3, 2);
INSERT INTO `role_has_permissions` VALUES (4, 1);
INSERT INTO `role_has_permissions` VALUES (4, 2);
INSERT INTO `role_has_permissions` VALUES (5, 1);
INSERT INTO `role_has_permissions` VALUES (5, 2);
INSERT INTO `role_has_permissions` VALUES (6, 1);
INSERT INTO `role_has_permissions` VALUES (6, 2);
INSERT INTO `role_has_permissions` VALUES (7, 1);
INSERT INTO `role_has_permissions` VALUES (7, 2);
INSERT INTO `role_has_permissions` VALUES (8, 1);
INSERT INTO `role_has_permissions` VALUES (8, 2);
INSERT INTO `role_has_permissions` VALUES (9, 1);
INSERT INTO `role_has_permissions` VALUES (9, 2);
INSERT INTO `role_has_permissions` VALUES (10, 1);
INSERT INTO `role_has_permissions` VALUES (10, 2);
INSERT INTO `role_has_permissions` VALUES (11, 1);
INSERT INTO `role_has_permissions` VALUES (11, 2);
INSERT INTO `role_has_permissions` VALUES (12, 1);
INSERT INTO `role_has_permissions` VALUES (12, 2);
INSERT INTO `role_has_permissions` VALUES (13, 1);
INSERT INTO `role_has_permissions` VALUES (13, 2);
INSERT INTO `role_has_permissions` VALUES (14, 1);
INSERT INTO `role_has_permissions` VALUES (14, 2);
INSERT INTO `role_has_permissions` VALUES (15, 1);
INSERT INTO `role_has_permissions` VALUES (15, 2);
INSERT INTO `role_has_permissions` VALUES (16, 1);
INSERT INTO `role_has_permissions` VALUES (16, 2);
INSERT INTO `role_has_permissions` VALUES (17, 1);
INSERT INTO `role_has_permissions` VALUES (17, 2);
INSERT INTO `role_has_permissions` VALUES (18, 1);
INSERT INTO `role_has_permissions` VALUES (18, 2);
INSERT INTO `role_has_permissions` VALUES (19, 1);
INSERT INTO `role_has_permissions` VALUES (19, 2);
INSERT INTO `role_has_permissions` VALUES (20, 1);
INSERT INTO `role_has_permissions` VALUES (20, 2);
INSERT INTO `role_has_permissions` VALUES (21, 1);
INSERT INTO `role_has_permissions` VALUES (21, 2);
INSERT INTO `role_has_permissions` VALUES (22, 1);
INSERT INTO `role_has_permissions` VALUES (22, 2);
INSERT INTO `role_has_permissions` VALUES (23, 1);
INSERT INTO `role_has_permissions` VALUES (23, 2);
INSERT INTO `role_has_permissions` VALUES (24, 1);
INSERT INTO `role_has_permissions` VALUES (24, 2);
INSERT INTO `role_has_permissions` VALUES (25, 1);
INSERT INTO `role_has_permissions` VALUES (25, 2);
INSERT INTO `role_has_permissions` VALUES (26, 1);
INSERT INTO `role_has_permissions` VALUES (26, 2);
INSERT INTO `role_has_permissions` VALUES (27, 1);
INSERT INTO `role_has_permissions` VALUES (27, 2);
INSERT INTO `role_has_permissions` VALUES (28, 1);
INSERT INTO `role_has_permissions` VALUES (28, 2);
INSERT INTO `role_has_permissions` VALUES (29, 1);
INSERT INTO `role_has_permissions` VALUES (29, 2);
INSERT INTO `role_has_permissions` VALUES (30, 1);
INSERT INTO `role_has_permissions` VALUES (30, 2);
INSERT INTO `role_has_permissions` VALUES (31, 1);
INSERT INTO `role_has_permissions` VALUES (31, 2);
INSERT INTO `role_has_permissions` VALUES (32, 1);
INSERT INTO `role_has_permissions` VALUES (32, 2);
INSERT INTO `role_has_permissions` VALUES (33, 1);
INSERT INTO `role_has_permissions` VALUES (33, 2);
INSERT INTO `role_has_permissions` VALUES (34, 1);
INSERT INTO `role_has_permissions` VALUES (34, 2);
INSERT INTO `role_has_permissions` VALUES (35, 1);
INSERT INTO `role_has_permissions` VALUES (35, 2);
INSERT INTO `role_has_permissions` VALUES (36, 1);
INSERT INTO `role_has_permissions` VALUES (36, 2);
INSERT INTO `role_has_permissions` VALUES (37, 1);
INSERT INTO `role_has_permissions` VALUES (37, 2);
INSERT INTO `role_has_permissions` VALUES (38, 1);
INSERT INTO `role_has_permissions` VALUES (38, 2);

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `roles_name_guard_name_unique`(`name` ASC, `guard_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, 'super_admin', 'web', '2026-08-18 20:26:30', '2026-08-18 20:26:30');
INSERT INTO `roles` VALUES (2, 'ketua_rt', 'web', '2026-08-18 22:57:01', '2026-08-18 22:57:01');
INSERT INTO `roles` VALUES (3, 'warga', 'web', '2026-08-18 22:57:01', '2026-08-18 22:57:01');

-- ----------------------------
-- Table structure for rt_informations
-- ----------------------------
DROP TABLE IF EXISTS `rt_informations`;
CREATE TABLE `rt_informations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rt_informations_created_by_foreign`(`created_by` ASC) USING BTREE,
  INDEX `rt_informations_published_at_index`(`published_at` ASC) USING BTREE,
  CONSTRAINT `rt_informations_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rt_informations
-- ----------------------------

-- ----------------------------
-- Table structure for service_request_status_histories
-- ----------------------------
DROP TABLE IF EXISTS `service_request_status_histories`;
CREATE TABLE `service_request_status_histories`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `service_request_id` bigint UNSIGNED NOT NULL,
  `changed_by` bigint UNSIGNED NULL DEFAULT NULL,
  `old_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `new_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `service_request_status_histories_changed_by_foreign`(`changed_by` ASC) USING BTREE,
  INDEX `service_status_history_timeline_index`(`service_request_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `service_request_status_histories_changed_by_foreign` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `service_request_status_histories_service_request_id_foreign` FOREIGN KEY (`service_request_id`) REFERENCES `service_requests` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of service_request_status_histories
-- ----------------------------

-- ----------------------------
-- Table structure for service_requests
-- ----------------------------
DROP TABLE IF EXISTS `service_requests`;
CREATE TABLE `service_requests`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_number` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `purpose` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `attachment_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_verification',
  `admin_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `result_document_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `processed_by` bigint UNSIGNED NULL DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp,
  `processed_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `service_requests_request_number_unique`(`request_number` ASC) USING BTREE,
  INDEX `service_requests_processed_by_foreign`(`processed_by` ASC) USING BTREE,
  INDEX `service_requests_user_id_status_index`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `service_requests_status_submitted_at_index`(`status` ASC, `submitted_at` ASC) USING BTREE,
  INDEX `service_requests_status_index`(`status` ASC) USING BTREE,
  CONSTRAINT `service_requests_processed_by_foreign` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `service_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of service_requests
-- ----------------------------

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sessions_user_id_index`(`user_id` ASC) USING BTREE,
  INDEX `sessions_last_activity_index`(`last_activity` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sessions
-- ----------------------------
INSERT INTO `sessions` VALUES ('1J2rsYY8aczY0tLqmcEJfMHTiMzc415mi28MDwLl', 1, '10.200.11.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'ZXlKcGRpSTZJbmwzY3pJck9GUnpWbFZ6WjNoeFJqWlJhR3A1YVhjOVBTSXNJblpoYkhWbElqb2laM0p3TURZdllWQXpWbGhvV0hSV01GVmpiVGRYU2pFME5IUnJNRkpuT0ZnMWRWVkJUVnBEWlN0blJYQTRPR2RJWmtGWFJVMUdRa3d6VlVOSk9UbFdZaTg1VUZGMGEySkxOVUZCVlZwMWNITjNabEpHVkhWdGNXOU9WSEJOT0U1eVpUazVabmwzZDJsS1JGcFVSVnB4VGxwcFJFOXZhSEpYYlhJMVJITXJRelUyV0ZKVFExVkpXVlJrZERCUFJGQlpObEJ6UnpaRFdEQlZNRUo1U1VVelN6aGlkM2NySzNGNGEzQlpNR3hzYVhZNFZYTTRTMWh0TlVRelNEbDNXVzlCVFd4VFRucDJRbk55VmsxNWNUZ3hRbGhuVjBabk5uQnJaakZFUW5WcE0wVmpTa042UzNKMFVqZEVXRE5WTUdKWVZqQkNaa3R1TVdkcVNYbGlNaTlST1Uxb1ZHcG5ZbThyVlhkcldVMDVNWFZtZGtkc05XUndZbUZFYzJFNU1VaEtWa055TmsxdlpESk5SMWxpUlVwSWRERlFNbGxFWjNvelVtWXdhbXN5Ym1sQk5WTkhXR1UxVUVkSlVHRnVRbHBMUldKWWFFVnpZV1pyVmxwalJXeFZjamgwYWxkb1JIVndkemhIYkU0eVUzRTFkMHB0VlVoUGVYVjRZa1pVVTNOcmFFdDBhekpFU2pCdGIzcDZWelZJTW5KSE5WbHRjamhFY0hkT1pWbFRNMU5RYzI1WlQydE1Zamx1YWk5TlNrWXhlVXhWVUhsblUwSmtWU3RGV25CWE1UUkRka3RqTmxOb1NHSjJRbTlLYWtSTlVWQXJaRlJLTm5ObmFsRklkVmhUUlVRelNraFJNR0ZxUW1oSVJtWXhjbFJEU20weFFtWTNNak15ZEhWVlNFOTFPVU5LTkM5cVZIWmtWR1pwWWpGWlQwNVdTWEp2TlhaTU0yWkROR0pEVVVWUWQwOWhWRkZUTDFaUE9YSjROV2RUZFRCd01sUTNOSGR1TlZGNGVqQTFWV0pEV0hSTU9XbFJOM1J4U0U1UE1sUjNURVppTldWSVQwY3lRVGxFTVVOV1IwRnRhaXRsY0dSaEsxVXJTbUV2VXpKeWRqbFhha3gwV1c5MmVFd3JMMU41VG1kMlZsQjNUbTV1YkhoV2JtUktiVTh2VFZwR1QwUm1WM0FyZW5sbmNVWlpSelZQYVhoWFF6RklSQzlGY1ZseFRITnpkemxRVlhaRmF6Z3lSMlJYY1V0V1drdEhURFJJVUhrd2FFSmhVbHBaZVhWRFJHMURhREZ1WTIxWFZtNTRNa2hQWlhNNVZVODVhMVJGVVRsTldrRXlRMW8xY1Vwa05sSjRXaTlNVW1weGRTdE1SRE5OY0dWdU5uZHlOemM1YWxNMlVEQlJObEpUWjBoSGJXNVNka2hQVGpOeFkwSmFhemhNZWt0V04zZGpRV2wzUkhFNGNsTllWbWRJYW5GRVVFeEZjVVpTVmpWallVUjRlRFF4UVV0cFIzZFBWVmg0VDBKMFJuUlpRMDFaWmtWdVVtaElZVEJ6V21vMWJEWkZTbGhOTDJKTWFtSnJVbFF6TkdSUlZXWk9OV3RVT0RCTGVDdENTbVV3Tkd0Tk5UTktUMHAyZWxrMU9UTkJSVFZEV0U5a1Z6QjFkMk5QUVhFNGNESk5aMFUzWkZkdVZWaFJZM0YxTmpac2NEa3pRelF2ZGxOU2MwbzJSR2QxTWpsUVQyczRaSGhaUVVKbWFXOTZNalV4WWxveFRVdFNlalZRWTNBckwyZEZOelpTTDBwemFGZERNV3RuWTFwTlVEUlZabWRCVUUxQllVcFZRVVZRWkc1a1IyTTBlVmxNU2pSM1FpdEZRMEpyV2lzeGNFSm1iMk5XUkVGaVVXdFRURzV6VlhwemQwTjBNRUk1WW5sdVkxcERabVZyTDBoSVJGZGtaVmh6ZFV4RmEzbFhiSGN5THpWSE9HcGpPWGhwY2xsb2JGZDVZVUpYWkRKSmFGVnBWMkZxVEROVmEyeHRWMFJpY25KQ1J6Sm5URWhtV2taMlNuaFlSbnB4VURkV2RYSTVLMEpRUWtNclZXcFBkMHBFTjFaalMzaExNamRQVTA1S09FbG5TM0UxYm5oSFluVjBMMGhFYzFWU1R6RkdhVWc1VlVOQ01VZ3JVRlpuWkZKUWVrOHJaa0pOTVdoVmNYVkpWbEZqVFhFdlVVczJWVFpQVTFoTVFsSlRjM3BNZWk5MFJuSmthRVJvZG5GemVtOVlXa1ZCY1dkaFZFVmxXSGRxTkhSdk9XdGxObTh4UmpOUldqVlRSamRNSzJsUVUxbDZSelF5YmtVM2RFRkVTRVpCZDBwVU1IaFNNQ3RMYVRkamVHZzBPQ3RXYzJWcmVWTk9UV2xvWTFjMVRVTndPWGxPVUdGR1oxWTBSMVozVWt0S1JFWndRak5UZUN0MmFtcGtjVWxIUVZwU1dWRm5iMkphT1RKblRFcDJaVGgzZVhjNVYwcHlXV0pGV2twNGNIbHJUVXByZFRBNFV6RkNOelJxVGxGeFEwUkxhR0pTVlhJeFkzQkxXRUpuVWtoaVpHWnNhRkp5YVUxamVWZEtZazUzWnpoc2FVcFpNbUpEWWxsaE5IRnpUakZaTDJnMVZGTm5aVE5XTDBVMmRHTkNWbWN5TURaWk9FdzRWbkpRT1dvM1NVVnpOWGhzV0c1a1pVWjNOR0l2U25aUlFqQnJkR1IzYW10RGQyWlhWMGxtUjNFclIySnJTblo1VjFwak5tZERMMmRqVDFwYU1HSkpTWEpSYWtOTGFWWk9LMnhQUW1SNE9UWldiekl5VmpKNmFVYzNNMkkxVWtwMFZVaFVOblJZT1RkR2J6QlpRMFJ2VFV3NVFVZHViVVp1VDJsWU5tWjBVMDFGWTBrM2F6SnpUbEpvWWpGc1JDdDRjbmt5YzBoMlNHMXFPRTV0UlRKVFVqVkdNRGRET1ZwNVJqRmFSRTVWYlRsM2FGaGxZMWRHYjJGU00wOTZjbEJNTnpGRmJVSlpZWGx1WW1wQ1ZDdG5VMGh4UlhKWk4yVTVaRkZRUWt0NE5HaFpTblpIWWxkSVRFUjVhR05JTDJjelZEbGphWGxTV2xZM1FXaFJPRVpLTDB0SWRGVmxTVWhrZVdGdlpuY3laR2xSVUZBckszWmpMMmcwUldoVk5ISkNSMEpvYnpGTU0yOURXamRvVTJkMlNqUjFRbnBHUWs5cFpXaFJPR0U1WWpoTVpVTlFhM2gyWjJsMkswOWlaV3RzUmpseWNqZEhaME5pTjFSTWNFdEZkbnBEV1hSbmIwWjJUWGRQYTNGaWRuVkpaemxhUTFvNVVISjBSWGs1TVZKWE16bHRlSGRDVjJSUk1GQkNkRzlZTmtSR1ZYVkxSRFJNWlVOMVFVNHlhVU56WlVwNk0wTnlOa1pIZEV4VFRucHpSRWxXVWxJclVtRmtWVFJtY2tGNGJIWnVNVVV3ZFZoV2RYRklhemhRVjFKamNsUjZhR2htTUROV1NtaEdXREZCZDBOUU4yWnhhek5uVVZCTU5WbG1VRkJ0YzA1c1JUUm9abk5OVWtSVWMySmtXalZxVG05S1ZFTmlXVWhDYkVJd2FWQktkVVkxWmtOWGNFcHVXR2hTYkVKRFVUZElZV3haWjJSUk5FZGFaM1JzT0RCYVYwUlhRalZLTlU1T1psUjRlRkY1YWxBd00zYzFlakkyYjFwWlFpOVRObVp2T1VrNFlURnlZMFJHVm1sMk9ITlZjMDR4ZFdVNGMwdDRRamMwZDFFd01rRlFURzVrZDFSWVIzZ3JkRWxUYmxaTUwwNDRVVzFQYzBSa1kyTXJRVlJtYTNSME1ETmhZalJaV0dRNU1XOWpkRFUyUmtvNVRXWjNUbGh1Unl0bGJ6YzNLM2xDWkZWaVMzQldXV0pMVVZWMWFHZFZXbWhXUkhaS2VuVkdaazUzWjNsb1JqUkhNSGRzWVZkWlVHRnBRbW9yV1U5VVdYSTJWSFJITTJ4emVrWjNkbmhCV2tOdE4wcDBiRE01TURSUVZsTlFZazFSZW1GaGIzaElNRVkzYjFWNk0zQm1Vazh3TnpCbU0ySjNWbE5uU0ZOc2J6WmhSbnBoZFROUFNDdGFjazR5V2l0M2FqVTRTVGRaUmpWRFQxVnljVnA0Um0xUVVXNW1PWEF6UW5aVlYxUlRNRlpVTjFBeGVuSnRRa2w1VUdGdVRHaFZVakE1UnpoWlRsVTBWRzg1Wm5sa2FtWlJObEEzTlVSVlF6azJXaTlTVERSVlFUVlJlV1JYYTJSSU9YaEpSM05uUWtaQ1Vta3dhMFZ2TjNacGJsSlVXbTV0UVVOd1EySTVPQ3MwVEdKdFQzbEVWRUpQYjJReFQyZHNjMmhaVjNvMFFVcEVlRnBKTDNwcmFETk9ORnAxZG5OVlRIZEJhRUZZT0hwWWFrcGlhRU5vVVZsaFZXWlpVMGh4ZFRkYVRDdFdjRlUxYWtKNGFVaG9lazltVTNjMFVYZzBZVE4wU0dsc2RtZHRhM1ZKU2xsaGFXNXNiRVpSUjBGRmJHWnllSFpDTjNnMEsydDZlVmxsVTBablZsQkRTMVE1YUd4dGVEQnlTbWhPT1ZKT1UwTnJUVzFOVVN0S1ZYY3dSRkpWSzBGcmVXSXJXbEZMVFZVeldGSmtlbWxrT1ZsNWExTXZTMDFxTVVsRmFVVnViWGt3U3poWE5GVlRUMHhvY3pGMGFqTlJUelZ2VGxOcVMzRjNPV0ppU2xwQ1ZtTmFjMnQwV25NMFp5OVFNMjVsU25KSFlraEZOV1JxVjBneE5UaGtjMmR3ZWs5VU9GbE9aR3BxUzFwYVYwRktSa2xSWVU5SVNIQXplbTVUVEhkNWQwVkdVVkZoVjNCRWFsSXlWakphYldNeVJGVXdXRUpVV1dGcWRERTFZbTF5V0dsTE1HTnJOa2xwU2toTVRrNW1UbTFxU21OV1prY3dhakpzWlc1SU0xWktWa05xYzA4MU1YTTNOVkpwU21neFRXRkpWbFpPVkRac1QxQm1SMnA0WW1Vd0wyUlVTMnRqZEVjeU5WSnNORGRRUm1nNVJXeFpZbXBtUXpOdlNuRTJWa2hJZWpOaWNrRXdVR0poYVV0cFdHdERNMUJ3WjNWakwyd3hSWFpzY1dWWlFtY3dVMW8xUWxGRmF6QlBaR3R4ZEcxUE1rRm5NMDlHUzBGcmNteHpjM29yYkZObVRHdEtTWGtyY1RsU2VFdHBPVUUxVWl0elNFeHVkbEZwYUV0VWJFZG9Xa2Q0ZERObFZGZzNPVEpVY0N0RGNXZFRSRmhaTldObFpqaE5jbmM1YWpkNmNXVjVPRW8xZFVSelVqbHRRMVZaWjFoQlFYUlhhbGhtYmlzM1ZreDFURkpZU3k5aE1HVkNZM2d3Ym5WTE5ITkVRa1V4Tlc5alozaFJkVkJNWVU4d2VUaG1lbUZIV0RoUU4wRXlURFI1TTJSeWJYb3pUR0kzVHpOdlpXNU9Rako2UjA5MFdEZ3dSeTl4YUhoa1JHNU5URlF6Y2xoTGVrczJTakV3Y25ZMVZXZHpVWEoyWnpaVk4wdGFTMmRxVTJGYU4yVkpVa2xKTUZOVVdHeHpkMk5ZVm5KQlozZ3dhVEV3Vlc0dllYcEViMnhaT1ZJdmJucFRNbTV2VUdreFR6bGxPVzFUWm1nNFQxbFJNWE4zUWt4cVJIVndaMFk0ZVVkTldEbGliakJ4YVZWTVkzRjVUbGhEWTNGb2MxWnZRVGxtTjJwVlMzSkhZeXM1ZG5FelIyNDFOMjk0VW5oaFVIVTNUV2hhTkhSMEswNXRZbmd5VFVKeU9FUkRaV1JsWnpka016UmFkVVJKY0U1UE5UWXJkVUpPY0N0blIyVmxUak41YjFOdFUzSkZMemhDZEdSa2JEZHJUMmRhYTJwWGRHOXNXVmxXY25aVVVUazBWMUJ2UVZGblUyRXJTbUZVUzJGVVNFVjVZMXBHZDNWTGNsTkdWRGc1TDBOeE1qZDRSbVZDWkM5YVNUaEZXV3RXV1Rnd01rNXlTVnBwTVRoRFJFZHhSU3N6Y1N0T01sbzVNSGw0U25CTVEwcDNNV2N6UnpOellUbG1ZbnBvWTNoNVVVZGtZamsxZWs4eFNVeEVMekoxVW5Wa1pqRnVhMU5zV205aUwxcHNMMFV6UVZKU05teDJkSFZEZURRdlpHRlpUVFZpTUhKV1YwaEZXV0ZWZDA1R2FGUkxUVEZCYVRkUFNVMTFkV1pCYjJKNWRuZEZjazFSUmtKWVJXVktjSE54YzJjNFMwTkpLMHhYYm5wcE5YTXJaVXhCVW5oMWVGaEVhVWx5TkRCS1RXdzBabXhJYUVkb2FVeDJNREV2ZW01b1kzTjFTM0pFVmsxeWJGbEpWSFIzU1RKSE5Xb3hhVVZtVjFsUmFXcFhOamRXWlhwd09TdEhkR2N4VFdaRVQyZHlWbkZtVlc5R1RqTkRTSGsxT0ZGTFQyRnRlRzFvU21Wall6RTBhRWxqWjNKcmFFTllPRUV4Y0RsTWRFRm9NMFJ6TUhvclVrMW5ZaTlMVkdkMVIwWnRiRWRyV2t0SWN6aDVjelZTU2tkcmFUWTVkMVkyZFdsVFRVZzNkRXBvYUhkM1drZFBiRXhrTWxFcmFFZHlWWEF4VVhwUVYzZ3ZVa0puVm1KUk0yRlhWVmhXY2xKc05sZENRekl2TUhOaU5XNVBLMkpOWTJseU1tYzVWbVpOYkU5b2FsRmpRMDhyYmtGaVdYSTBUWGRIU1hrNWJVTmFRelYyV1VseFRqbDFjVFZSYkhOeVpsVlNWRkIxY2xWVlNVMU9lVzVQV1VkbmJtRXJNWHBoZDNCTmNETjNhRnBaYmxCSVdXUlJZVTA1Ym1zMFNraDNPRXBGWmtkVVJFaHFhSEZuU2xacldHbHVZMEpVUVVwRE9HOUVaMDlaZUc1d1FUQnpWMmxwWlhvM2NHaDRORlp4Y1VveVJWRlZaRmsyV0dacGNHSnRlVXRoZWtjelRISXdkRWxxTlRkT1JFVjNOR2xpZEd0RFYzQklWMEpQUzJweWRrUTJLM2x6WWpGcVYwNUlTMHA0V21kMFUwdElRbFUxY2sxNU1sQkxXbWxOWVhjd1lWRkpjMnMzU1ZGNGEydHZTMDlUUjB4NE1GaFpZblJYWm01M2JIWkVOV3BWVTFwTFkwNXBMMDl2WVRreFUxRTNSVmRRYUd0cUswOUhTVzVGUmxCNmEyTXZSVzVUTjJkMU5UQTBNbVIwV0haMGFYUkxhbGt5VGpoeFV6QllaVXhsTmxsalJVVnlSWGgzWVdSS1YwVkdlbkJrWm5Oa2VubGhhWGRTTldoWWRWbEdaa1ZzVmpGc1R6VlBXRnB2YjFWUFVEaDVjMWxNVG1zeFRDdFpTWE0xVW5CSWVtMUpURUZIUjBRdlp6bHBkVk5UVmxBd1V6VTJTM0Z1YVc1eGFtZHRNMk5wVjNWeVNXOTRka2x6Y0VSTlJXVjZWMFp5WlRSM2JUazJjekpDUW05NmFXNU9WazlaY21admNqWTVTeTkxWTNWcFRtcFNRbGgyT0ZwT05VaEpXWFJKVDBRd1dESTRVMVZqTlVSMlRUVk9hVXQyYmk5UWFXNXNRbmxRVFhWVGJ6SmhTa1p4VTBaSE4yVTFVV1I1VUU1bGREWklOelphZEdKMU0xVlVSMVY1UlhwNVl5dHpjV3g2YUhWYWJXTXJjVUZNZWxoclQyaHphSGhKY21VMVZHZGtkMUZvYVdneWRXc3ZPV1JLVlc1bWRrMVZOMjAzWTNOVk9YbG9iR3hLTjJSSmVuSmhVRWxxY0dSRmJYQnFSSGhuUWs0elpHVjFiaTlYSzA1YWVqSmllamh1TVVoSVpHMW1VRlJHTVRGcWRVZDRRbEZ3WmtsTVdWUlpSVWxaTUZGa1ZFcGhiMFp4UkhaemJ6UTRNV1Z0YVcwNWNEVmhVbXhQZVZrd01YSjBWV3BZU2tGbVNWUmpZbVJDWTIxb1VVWlhiREk0TjNkRmVsWnpaRmRWY1ZGSkwyVlBUVWhIVG5aTVJraFVWRkpoU1doQlZqUmFkbEZRYVU0d0x5OVlObWhhV0ZCclNESmxkbW96SzFoMVFXZFNkbE5oWjA1elZUbDBNRmxRUVZORVFrNW5aR2RsY0UxS1VWY3dhSEZrWkVkQ1UwSTFZekIzUVVWbGFIQTJNa2xsTDJ4RFFucGtlSFl4T0ZKSVVtUjNjV0ZvYm5aTlkwRnllazEyWlZOVlJHbG9NMWs1WkZaR1lXWTFVVVZLYUZOaWVXRXphblo0VkRaV1pGcG9SbE0xS3paeldqTjBUamRJUjI1d1FUVm1OMkZEUW5saFoxbzVXSEI2UTNOQ1duTm9jSGgzVm5RMllXSXhNMUp2ZUN0YVZXUTJiRlZMWWsxclExUkJTa1ZVVldsWU9VZFNSbXRJV0dOSk1UaDFWR0l3YkdRNFFVazVRVlJ1YmxCeU5ISXZhMnB6S3pkVVZUVTBWa1oyWm1Ga2VXZzBTbE5JTTNOU2RtSllORlF6WWtOcFJYSk5iRTgwZUVoUFVIaG5jMGROZVRBNFVGcFhSV2hFYUdKUVZWWmFWRlpyTUVWblEwc3dPRTl5TmxsR1FtUTJOR1ZDYWxWaFZrazBVbWN4UlhBeFF6bHpaRTR6Vlc1aE9YbFdPVmRHUjBVek1sSkxZbmwyUjI4NU4yZFZlSFZUTVVWYVpFTlZka3BrU1VSdldVdDVUMDFQWnk5RFVqZDBTV2hsY2paaFNqRnNlSFUwWlVRNFowWXZTVTAwUkRWSE0xZGhXa3BIWTNrd1dubDJPR1JqWnpablMwVjBhSEZvZDJZelpUQlViRGRyVGtKNFFtWTBURGhGZG5sYU1uSmFOWGxaY1RGT1NGTXZVRFJzYUhoclZqaFBOa2h0VWpWNlJGSmxaRkZvUWxkUE1EVkpWVEJTYUVaeWRrVlpaRlIwYXk5Q2NYQldUQzlXVlRoclRFWlFPRkZpTVVWYWQyUlJVRkl4WTJ0dmFIaHlSU3RqTkdrNGVWcHVUaTlYTldKR1ZXaFNNR3BDTDNCVFNGVkRjbEZHV1VkNEwyNXBNbUUwYTNodlZ6RmljVWRGWlRsT2NHNWplVGxFUVZKM1dtOU1TblZSVGpCSVRGazJkR05JZDJJelpVOU9iWGxrU1d4QlRHWmhkVzl5WlVKdWJ5czRTa2Q0UjBkT2RWbEhaM0pLVlhOWWRrSlRiMDVoVldkc01pOUpVV28yTDA5MVNqZFhTMFZwVGt0VFFWWlVhbFYyTml0UE9WRTFSSEZ5WTFKbFowNDJjVEZPTjNGd1dEWnpkRzVDVEhaUmVHVkpWelpwVEhKUmIyYzJNblptYVVkYWRqZEdVVEJYVDBGWk0xRlFMME5oVnpWUE5WTnFjM04zV0M5VVJtbFFTa1JOUVdJd1JVSlROVWR4VEV4cGJERTBUMkUyUTFkWFRuazBWakZ1UzFKdldIbHJVR2t4ZEhOUFYyWjFTWHBQUnpab09FWlZPVlZ2T0V4blNuVnBVelEyVXpWM1VEaExkV1V3YVhOWEwxRkJiamd6ZEhKNVdUWk1WU3RQTUVzeVVEYzFjbVZxZEVwdGQzWjFSM2MxYjNSU2MxVktjMVpPVFROb1luVmxOR0pJVFhZeWVHMVJWVVJqY1U1RFNtUXhNVXhoZVRoM2VqQkNiRmRSVG05VWJGUTRORFUyZUVSQ2JWQTJhMHh6WVVnMlRESXlVRlIxZEVGUU5tMXBTV3hKV0U5aGRUaFNjVXBNV2xOcGJXUnFiVTR3T1RKc1FscDFaV1ZzY21OMWRsSkpWMVZoUjA1bGFWZDBUMnBKTkNzcldHeFZha1k1UW1zNWNIaGthVE5TUnpKSFVGQTJVV2g0VVRScWRteHBORTlVYjFsdFdtODRlRk5DZUVwUE5VUktObHAxV1ZNeFFXTmFkbkJDVm1sU1VGRjVjR2t2UzJsYVJEVnpXbE5wWm05c1VEaHhVWEI0TWtndk5XcFliV2xWUlU5UWRHZDZZMGhSUVV0Q2JtNVRNV3B5Um1SNE9GVnBWMHhKZUVoT01sbElZVEU0UVhKMVprdE5kMk0yZVZGS1dFRmxaRVpYTUdwaFUwMW5LMDl6Y3pSVFlXZGhVamsyZEdKRVJGY3Jaa0p4ZVdKWVZIbzNTbHBVY3pCeFozSmhTekZIZDB0M1IyRjJOSGgyTjFjd1duY3JhSFpwYzFoeFVqUnJTREp0WkdOMFNEaEllVW80VEZkak5TOUZNRk5DT1d0VmVHNUROVXg0UlhsNVptWnlWU3MyVVcxeWNWQkpjazVhTjBkRldFdHFOU3RITkhSRGVITlBiME5EVFVsNGFteG9XRTFsS3k5aGVIQnJURWhIU1RFMmVtYzBXbXBMWjBNeU5sQm9UeXRwVDJkWmVrTm1PVUp3ZUZSVFMyVXdZM0pHTXpsRVpXOUpOMEYwTDBWV1QzTlplbkZNVjFWUk1rRkhjRnBzVFdsbVMzVTRjMGx5UWpSVFpsSnRRMnBKTHpKWVoyRXdMMk5YVms0MVdUaEpaRkpRYm5KcVRqWlRSWGxpUm1GVFNXcEdUazlzWkhkTkt6WnBiMHhJZVNzMGFsTTFRVzVCVm5oT0szaEtORWwxU2pacVExRmpSVko2VkhGTU9FUlBMelZJWWtKTU9WSk5OREZZY1hWcVMzTjRUV0Z1YjJwb1kzb3pMM1JvWVd4NWFHMVBaRzVwY0VGc1IxaFNUakIxUmxvMlUxWjNkbFIzUzJGVFJHY3lMMkpyZFRsdmVHWXJZMGN6VFdkSlpHMUJWMlZ2TnpoMGJFZFlNME00V2tkMUsyNVdXa2c1TmxSeFFraFJMMHBCVGxkUlNFaHJNV0pHTkZsNmNXVnVWRFoyZDJONU5GaG9ibEFyYmxGM05YWk1aVWs0ZVhZeGRHbEZlVmR1YTJSVlZHTXpORGMzZVRBMVNXWm9aa2xUVGtwblJXWmtNRkpsT0dodGRtMVNjMGRISzFSUmNsazFSbEpETWpSTk1sUkpRbmtyT1RWblJrUlpWWGwxY0hSVlowRlZUakpNTXpabGRuZ3ljekpUVEZWd1ZuWm1lVkZRYjBGd01IQlVWelJzUlRWclIwRXlWRWRCVGxvMFVWTkNZamxuY0U5bE9ETmtWVlJoU21sRGJYUjRMMmRUY3pnM1NYQm9RV2xwTVROSVVFSllOV1kxVHpOWlUxRkVRMUJ1U1ZFNU9USkVVbGhpUWxKMU5reHdiVkk0UldreU5qQTNPUzlOVVhwRk9XeHFZbXBLU2tJM2NHTjBlVnB3YzBSbGMwUlVNeTlKZW05cFNXczRUV1ZJVkZGUlRtOUxiRkEyVDFwR2IxSmxWMWcwV1V4V2MwUnVkVzkzZVdGWU5sVmFaWEV2YVhvNFNrOXFVV0ZpWW5ZMVdXSnhLekZEZVZsdVEyaEthazEzYTNaT2VtVlRhV2RVWW0xNmEwNWlaa1IyTTBwV05reG1SWGhtUW5SWEswVjNZbk5rZDB0d1FrOWFlVXhVTkdwclZrZFhPRzlxVGxoUlJXMDFWVkEwTVZCM01YSklUakEyVVhsQlJFNUlTVVV5TkhwYVp6ZHJiMlZvV0U1bVJVcEhOSGwwVFdsV2MwWlBNWGhsZEVSc05tSnBWMlJYWTBRMVpYVk5RV3d3UVVkUFVHOWlXRmN5U0d4RGQzTXpRMUp0ZFhab2FGVk1RbTkwUTFSaFIyTjRTVlJ3VDBKclZFOUdOeXQxVTFkWFdrczRiVmg1U1M5eFN6UjZhSGRSVldsUVFUSnFNMjVHU1ZGdk1GVkRZMVptV0VWSVVDdG1NR0o1SzFwdlRscHlObWMxVVM5eGFIaEhUakZ5YVc5YWJqWnhZV1ZFUVRORlRESk5hMHBTYzNkb1dXWk1kalJ1Y2xKUldIazRiRzAxVTNrNE0zVkxTVTlNYUVSUmJIaElSelV4V21SVU9YZHdUbVJYUTBKSFNFRkNVM0Z6YVVOblYxSjFlVGN4TTFaNlpFaDVRVlZIU0dvMU1DOUlhemxYZUhCeVpXSlpaV3R4ZVRSblMyRjVZMkpwU0hwc1JXdFVNVTFNUkRVcmRVWnRiR0ZEYjBKck5FVnRSbVJSYW5aWE1VSjBhR2NyUm5BclVWTnBjaXRNYWs5NWRISlBXV3B2THk4clpDc3ZUR0pPYmxjMGVIZG9PWE01V0doS1QzZEZhMll3VTNwSlF6ZFZVMWd6VmswM1pWcG5WMk5TYVVsS1ZWZFZXRWR6TWxZck1HUlpZamRQUTJwWGFVTlpXWGxFU1dzeFVsb3lNMEUwTkRWMWMzUmpOV1J1V0VOVk1ubHhOVGhWUmxKSVIyMXhjVXhTTldsTmRrTldaQ3MwUTFobFdHMHpSbVJOV1dSYU5VOHhjRFpGYjFVcmNGRlhaVkkzVUZFd1JuZEVhRTlWWlZWUlJWVTJkRGhWTUhNME9VODBla2t6WlhGQ09VRmpPRnAxZVV4WlVuSmxiREZuYlhBclJVWXdjMDVFTWtVeldWUkxORkJNVGtzelZsTnJSbFZWZEdoQ1ptUktUVzVxY2tVeFlrVjZhSFpsZWtWWVNGVlRaRTlqVlRkclFsaGxVamxGUWswNVJrbHRlblZ0UlZkTE56VkZTalZLZG1oMWNEUlFjRWxRVFVGV2JDOWpiMUpSY25OUmVHaHZWMlYwV1ROSU0yOXNjRkJ1ZVZsMFFubFJVR2RXWVdSQk5pdEJlV1V2YlU5bFNXcHFiVFF2TUhSak0xTTNNRGQ1VGs4M2NIZEZTSGRJWnpKRmNIVXdNSGMwZEVWME9IbFFObEV6TjBrMWJrMW5ZbHBWYUhGYVJFNHJSVlpoWWxaQllUVlNOQzlNUlhWeVJGUlliMlUwYzNWSmR6YzROMWxGU0dOM2VHRlBjRXRQVldOTldIRTVTSFY2YlVkVlN5OW1PSGxFVFdwSlkyOW1jVU14Um1admJHRktjbTVpVjBwNlZIVjFlbGxCVWtOc1Jtd3lOWFIwZFhWWWFGQlFVemQxVERKNVVIbGpVVmg0WjJwbFJVUllORTFDVDJjMVJtcEtWWE5KYUVzdldtMTJXbXhwZUdKSFEyaHpkMFJMZVRkS01rUk1TRkI0Y2pCcGNUWmFhQzlqZUVkclNDOVhRMUpuVEdSRmFIZHhPVkJDU21WaFJHSXZTbU01TkZnM2FWSnNUblJVYTFCUEx6VnRTak14VURVdlIzZHJSR3QzYzNkcmEwaENPU3RPY21velIxZFhTREY1Ukc5UlQwOVZPQ3N4UWt4YVJtTkRNRWxMZUZSVWRFRTBNR3BJTWpWaWJEWlhObVZ0UWtKTWRVRlRkMmhIT0dwelRreFBja0ZTWlVSc2NUTmtTUzg0VUdFM1lqbEVibWxtUTBnMFNFMVRWa3BsYzNNM1dpdFVjRVV4T0M5dVpFZFpNVFo2U2xoWVpWZ3dkV3hOUm1FeVlWaExNVEZoWXpSb1RHSlFiV1p3YUdWTVFsZHpUQ3RRYUdORVZpdHlTRXRhTjB0Tk5HMVRVRzlNZUVrNFRrMXVWMDFNUVhOVWMyeG9RV2xMWW04emFESkVSazluUVdGbWFFRjRSRmhPVFZsWllWTjBObTByUkdoV0syVldVR2xSUWtNMEwxQnFUekJ6UjAxQlR6ZEVNM2xHSzBkVmQzTjFaQ3RNYlZZMlJWaEpVelJUTVVvM2NHRm9jaXRZUVZweVRqQXJNblV4VFVkM1RFeERZV0pLVjFseGMwcFNkelJsWldoSVRucFJOak55WTBsQlJUbE9PV1IzV1dWdGNGbG5OMFZHVVdsNFdVSlZjVFJZVUhsSmNYVnJRbUZvWlV0c2REazBXR0UxV1U5MldEaDZUVXMwYzFZemRGZzJibGxLUW5OMVlsTkdMMVZETlVvdlEwbDBkV3BHT0N0eFZXSk1TVXQzVHpVdlV6ZFZiM0JKYjBkVVoxUndheko2YTBOemNrUkpZazAxYlRkRU5qWlhMMk5MYW1Fdk9FeHZXVWRzVjIxQloyZEJjM0ZRYlhaU00xaEVlSE4xTmtNd2RtcGtjRTVEY3pFd09VcEJSRUptYzBrMFNsSk5NQ3RJU2xCc1JXOUZieTlzYUhWMWEySm5XRnBOUkZGWWJsTllWbEJyZFc1MVN6ZzJVV0puYVdKNU5HUlFRVkpaVG0xUWF6aFhRMVIwTlVKWmVWRlZZWGs0U2tvMFFWUXlPRmgyUlRkRlFrbDVhRGRhV1Vsa1RtSXJObFl6Y2k5Q1FqUmhVMnQxUjJveE9FdHRNbkZVVVdaalVtUlJlWGRCY0dkTU4xYzNLMVJrU0RaNlZtTm1hMjU0T1RWWmNrSlZiSFEwUTIxdldWWlpTWEptTUVKNkt6ZERNRk56ZFdOdGREazNZbW9yTDNweFowTm5aM2x6TVhSaVVtOWFVbVpGV25OSmNGSnNNMHAyWVdGcVNtWjJaRlpNVUhSUlptOWhSeXMxVjFsbFdtbG5MekF5U25BM2ExaDRhSFV4YlZScVdHbHBRMFJFUlZoRGJWQk1iSFUxVDNNM1ZWcHlkbkkxTWl0ak9USm1aMDUzVURWVk5GRm5kMHRVWWxoNE1qQm1ZV0kyUkV0RFJVSm9ibXBTUjNCRVdtWmlVVThyVkRoV1ZEWnFWVmRFYUVZNGNHTkVhMk56TlU1VlJrOUZRME5QZVc4eVFqVXdkVlp4V0V4T1VtYzRLellyTkdWMk55dEJWazlrUmpaV05GZ3ZVRXA1V0doRGMxSjNkSEp0ZVhCVmR6RkljMUJvWnpad1ZqWlpRVkZNU2xacVFtUjVVMGxQYkRWeFRGa3dUemRvV1U1WFUwWm1hVlpXTkRNd1MybFVNRU5pYlRWelNFZFFlblU0VW1jd1ZGZ3dUR2cyVkVaVGFtUnpTbGR4YjBOd1FXcFhZV0pqZDBvd1Rsa3pjMHBSTlRSRE1UQnlhVVJaV2xkSlpYSjFjMFpPTkVweWF6Y3pWMnhuT1dvemFrNXlSbk5uYlhsMFZrOXZMMkpKUVM4ck5tUk5lRzlPVTAxalkxWjVMMFZZV1c1dU5WbHVVRkpRYkdodVdsVTRORFZCZWtkMVFVWkVLMFExSzNNelZVWTJlVU5QV0VKT1pUZDFOVzFyVlV0MlpWVXJhR3BGZVZFMFMwOUVUSEpIZVRsbmIzRkhSVmxTWkVRNWJtVlplbUozU25sclNFRm9iVXhtYkhWV01YaHRielZNUVdOQ2VreExiMkZPT0ZrMmRHMDBZV2xsYlhsNU5XVXlOa2RtTlVoQ2IzVTBja3cxTVRSUFNtUnhUM2x1WTNOVlJIcEJZV0ZaVEhSamVsbzNVM3A1V1VOWFdFZzVVV1Y0WmxNMmExSnpWbnB2V0ZoMk9FTkZXazUzWlZwQllUWm5OaTlDUmtGcWRsSmtNbWxwY1RGV2JUVjBRMk5JZDAwM2FsZGFaMkZSY1dob0sxUlhTMHB3UzI5NlVHOVZURU5FV2k5b1VEWlhUSGxEU21aVFkwbHdTbmh6YXk5U1pteHBhVGxSYUVoQ1pUQlNVVGR2TlZkMFVuWkRjR3gxV0dOUVlrTnpjekZ2Y1habGIzTnhia3d5ZFZGNlJFUXdlSE5NYlZkRVkybFhiRlo1TlVaSFNHWXhabmhVVmpVeFVuazJiamMzTlhsU1dtRkdUWGxLYVVVMFltc3djVWgwTVM4MVQwbEdha3hrY1hoS1ZYVmpjSHBKZG14M1VtWnJiVEpCWjAxeGJXZElWM1FyYjJObVRWZFJXak5xYVZSUVZrazVOR2N4WkRCNFkwcHVjMnB6ZWxKb1lrNXBiMk16YVhSYVFXc3dOMUZ6UkVJNE9WQTJXaXN4WlhGR09UbGtTRmhpYnl0M2NtWnRhQzlvYTNGMWVFUjRTakY1ZFU4dlRYVlBSMWxpYTFnMGQzWkRaRlowYzFNNE5USmtkbVpQTmtGTWFXTkNNbFl4YW14SlUxVkpTaTh2V1RRelduVkhXSFo2TlZWaFZEZHFZbEJDVkdacGNGbHVVSE5oYkZwMGFtWjZSVzUwTDAxWlRHeHBWblkyTTNVNVVWUTVWRWhWT0hGdVIzUmtUVlYwZFdjeGVVZHdUR2g2Um5GTWJGVnVRMmh6TVRsdVZub3pkVzlCYTNwM05UTklhV3BsTldJNWRYcE9NRkZtVG1zdmNXcFljbEZFYkd4c1JXbFVNaXRTZDFoeWVteGlNRmxYVld0U1UxTlhjbmh5VlRBcmN6VlZWRk5oVERkWk0xSlJMM0JXUVZjdmIyVlZOV2xaZDIxWlpIVkhWRTlwY0dOblYwcDRkSFZvY1VwMk5YZExlR1pYU1U1WFZVaHZZV3hPYmxOMU1XUnlTVzV3UzFSUkt6TlFSWEpGZWt0eFR5dE5iemRMYUVaTE9UVmhZMVptVUZsWU0zaDZlWEF5YzBKNmJtTk5USHBNV1hJd2RVeFdRMGhwYTFvMmRUTTFWRk5tVlV0c09VZ3ZlVWRuTTBGSlNtb3lOR0p1TkZwMWRXMW5RblZ0VFVOcVV6SlRkMVV5VDNwelUzUTRWMDkxVGpBNFlrOTVjV1Y0WVVoNEwzTkJOV0ZPYzJzNFlYTnBTM1ZyYldSb01saG1Ublo0Vm5kVFowTlJUR0ZKU0U1NFIxUnJLM1JXWTNkbVpVZHRaSEpRSzFreGVVNWFMMEZWTmtsU01XdDBRM2t6UlN0VGRpOXdPVUl2WVhGTk5YUmFZVGhuVFZNNGNHeGlNelIzTW1WSmRXb3dPWGRvYkhsVWJVRmFSSEE0UkRCR1pVMDVOMHhCU1dwdmVWTm5lV2hyWWxwbFVrdFRWMkZZWVVaTFQyaFdPRnBhWWtaT1lucHVVRlk1ZVdOTFQweFFaazFtWW5Kd1ZtNVZUU3RxWkhGb04zUkxTR0ZLWTFCNlMzaFBkMnhQTTFvM2FuRjJTVmw1TkRoTldqaFpTM2M1TWxrMFFqVkhVVlJyWWtWSmNVcHVjbmREWjJwWU0xaHJVVWRIUmtod1JUbEZTSGw0YWxCbFpGVm1aVlF5ZFZocGFYb3dWRWhGY0V4Q2VscHFWbWhwT0VOdlpFVm5ZWEJEWjNkMVEwSlRRakpZWkdnM1dFMHhWRXh6VFRZdlYwOVlUa1JYUVRCNGJucEVkaXRpUlhRMlVHMVBaMFptYTJKaEwxQnZhWEJDUm1aR1IwUm1kRnBGTTNkdGNrRlRTRUZ5TmtScVIxRjZTamhMYlZFNWMzbGhTMUZuZURKS1EwNUJVblUyVWtRdlVYQXlNR1Z3UmtWS1FraE9hRWxaTDFCU09GUldkMG8wU3poV2FGcEtjVkpFVVVSd05tc3dUbk5MTVdad1RGWlNlSGRyT1dKb2VHTnRVMmhhYkRjelRYZFBjaXQ0ZUc1VE5GbHliR051Wm01bE5rRlBWelpaUzI4eFpWZzBka3BKVGpGMksxTnpWbWxLT0hoU2RFbHlSVU5YVEVkallsUnNXVGxMWTNrMVdEbEdjVk5sYVVkQlJsSlBVbWh5WkZGeGFrSjJkR2hGU1VKa1R6ZzBiMG81TjBGU1kyWmpUMXBqU25jclYyNUNXVzFOYTFKbFVrOHlaa1ZhVTNwb1FtcGxTa3M0WTNBNE1YSklWV2wxY1hSV2MyWlpSSHBQVkdOck1GYzFWRlpNU3pGak0xbEJabTlXYzA1eGRsbDBRMjV6V0U1dFIzQlBibEZKVG5CQllVSkRRamxZTkc4dlJYUlJjM2hQZHpoNk1tcGpPSFpFWWpkWFdqWm5OV2MyUVM4NFFWSXlVa2t2VWs5aFJtbzVTbTk0WldGaE5GSjFVaXRrWlROdFExRmxPWEYwYnpZNFNWbEpWVGhVUkZkVFluTnBSRFpzYW5aR1VWVjJhbU13VkdVNWEybERPRTF4VERSWFRVeE9SVUpPV0Zsbk1uUlJWRVJTUVZFeWNrOTNjbEZDZG13MlRUVm9aRzVxUWxVdldtMTRhWEJOVDJkMlZWUXdTMjl3UW5aalJIbENNSFZDWkVjdlFtZE5jMGxSZGxnekwyMU1jSFpDZFhScmFVRnVaWFprVURKVVdHMXplbVExU1ZoM1RHaHVSVVp4UXpVeldtc3ZlbFF3V2tNMVMzQm9OR3RyVkVkaFVWb3ZhR3RLY21GMWVqaHJXVVJ0ZERaMldtNXhXR2t6Vm5wV1RHeGlZa2QwWkRsTE56SkZSalZsU0hKeVlUSXJlR2RVVmk4MGFtaEpSakJNZEcxQksxVldNa05XWnpCTE0xSnBWMFp6Tm5WT2JrdGFjVTF4VG5BdlNXcERSekJKTm5obVFtRjJWakZoU2pKdmMxRnFRVTFLU2swd2MyVmpjMkpTVVVsRlZsUjVUVFJ4T1ZZeWNFVXZVMmhtVXpkMlMxSkRWblIyU1Zwa1pIWnJlazlNZDNkQ1FsbzFjamR6YVhWSlFtZEllVlkzVEdsNlFXTnJPRGRuUVc1b1RFeFJhMWRwVVN0blMwNVZaWFpVYlcwNU5WVldaVFV3VEdwR1ZVRm9aM0JXVGxGalIyUjJWSFZNVG5kcWNFZGhiVVpxU1c4MGRHcEpUbUZKYUdoa2RXbHVPV1owVkhaeFUwWktRelpUWm1WQ1dETTJTbGxQYm1GNE1GVndhVTAzVGl0NVNEVkxRM2hHWkdSS1JUSkxhR1prZUVSUGVVdzVZekEyTWpWdFVraFRNVW80Wm1GSE9HTjVjMHRLZDJGelUxRmFjSE56TW1aa09EaG9UVkUxUmpKdk5EUmpZMG8wZEhsa1IzVmhaR1ZhYTJwNGJ6aFFaMFl3ZFdoWlNYbG5jVFUyZUZnck4wVjBWVWswUzJGTlFURlpiVkJ2YTBzMFYwMVNhMk55YkhGVmFYVnRjRGhFYVM5QmVEWjNSV3g0TWtaNVYyTjZTbFExUW1wdmEwOXpZazVwYldod2VITllNM0Y2Y0hkNFNrVkRUWGRhUjBoRFJHeEZkVmx4YjNGemJtRlhWbkJCY1U5VlVscG5SV2d5VVRGUVRFdzNNMGQwY2pOUk5tMVJZaTgwT1U5a09FOXhTSE13YzBwc2N6RmlhbkJqU1hCelZuaFNWR0pDU1VWb04zaFhNVmhGU1RGWlNIUmpSa013ZDFaeGFHZGFiVk5YVjNGNFpreHBkV0pwYVRKRU5qRlFlVGhvUlRsbVpVbE9VRW80VmxSVlpVeHhibEpUWm1ONk9WWndabVZvYlZkME4wUmFSMDVFVUZGMVQxUXlaMG81WldaWmNEUTBNRmhxV2k4NFNHWkxRazVOYmxSVGJHdDJiWGh6Wlc5U2VITkRVV1p2Y20wclltWnVlRVpRUjNabFFrVXpiMlZqU21kMlJXcDZOelJOVFhCYVFXMXpMMjByU1RsNFJ5c3dhRVozV2pCbU9WRkllRkY2WVZvNVRDOHlWWEJLUjFoSVZsZHpkSGRhY21SS1pHdElWRk01WlNzNVNWSTFOR3BFUVc5dE1HbEdSV1ZZTjFKcFVUSXlRaTlMVFc1bVVHSTViMjlGWldkRVZGWk5SVmgwY0RCS1JqbDRXRGd5TVM5M1FuSkRORVJJYTJKNVJIcEhPR1l5YkhONU0xSmlaakpVTTNCWVZsTndlbmx0V1VKWllqZDNUV3BuUzBsak5ISm5UbUZSWVU5clNHRjZTVzFTTDA5V2RHY3ZSa00yVmt0T1dURkphVzlPZVZKWWJFcHdjRUZVTlZSNFMwbFZPR0Z0YjAwd1FtOWpRbEZ6WVZRd1dGZzRjamt2T0UxblRtaFBhVE5zZG5scFMzbGhjVVpWY1d0NFVWZGtiVXhHTVVaeGNDc3phMjVQZEdaS0szRlJUbmQzZUhjM1NWaGxVVTlvTTJzeFNHMUNORFpYTDNsVk0waExlR3AyVFhCTFdHUlFWbmMzVmpKSlZWb3laR2RoVDAxNE1IZDFka3h1V2tweU9FVkhWRTVNU1hVMlkyb3dZM2d4YW5sQlpHaDRiQ3Q0UkhWUWJWcGlOakZWZVhOQ1ltcEVkbEIwVEZKR1RHOUtZVFl4ZFV4elFWWnNTRU5qUlRCdmJYaEliM1JsV1RKWWEyaGxTR2x4ZVVKdU4xWnRkRlowUlZOaWIzSnVlalJsWW5FdlRHNXRkbXh4VTB0TGNrdHphVzlGTUZrNE56TTFXa1JMVG1wSVFscG1lVlZhTnk5NEx6RkJTbTU1UkhsQllrRXpSMUIxWkV4RU15OUJkMnhEV25OWVZqbG1OMUJNTm1sdmNrUk9TSGN5YVU5T2VWaEZkbUZ3UkVJNFdYcGhUelUzWjBJNEsxRTBRM0p3VVVRM2JXbEROMUJFT0cwNU1uZ3JkQ3RrWW5aWWMyWXlOQ3R0THpZNVRESTVUVWQzWXpOck1uQnJZWGx6VjFocVdYTTFOMFJsUjJWblFqUnpia1ZaTDFKc1NqWnVPWFp0Y210cmJ6aG9NVkExVm5aeFRubFNLelZQT1ZaT1JIRlZlRU41VW5oREszUndjbkYyYlRZeWRXUjBWMUZwTlVrd1dUaHRiR1ZuU0hsaVRITnRRWFkxYjBwV2ExTlJZVkpIUVRWVU1VRlpTemxPY2xOU01GWmFWVTV6YVd4T1VFMUdjak5EU21odGVIcEVka2gzVkZwaGRVNVJkRVoyV1VoU2RUazVPRXhxT1ZSTmMzUkpSamd3VnpCaE9FczBOa015Y3pORGVtUnBUa3RrTlc1bVFVVmFSR0ozVVVsMEswTkNTR3BzV0ZWblRXVk5XVlpsYVVkSVJFWktjVzlOYTNCRGNreHRibkJ2UzNwTWEyWnRZM1F3U1daS2RrUXpMek5QUnpGdWIxaG5Rbk1yUW5OcGVHZHhVa3BMUlZGRE5tVnVPSElyT1VZeU4wa3ZXV1ozYWpSWlIyd3pSMjlsTVU1aksxaHNNRWhZTlRsRE1HUnBRaXR1U2tSUU9UTTVMMmQ0Ymtwc1FYVlpabGRwVlN0UmRVSkpjbmx1YTNGNVVYWnVXREJCWlhWR1VHaENNbWxvT1hOUGVVVlhlbE5CYTNGNVNrNWhZVkJMUkVWbGFWWklSR3BwUzBRMVluTTVSR3QwU2xwdVNYaFJaVlJhUzNKR2JXcDFTRlp2Y1RSaGNGSTNTWFo1YUVSR1VrNW9XRTV6WmpGdVpHcHVWa0owTjBNMWJGSnpUMEZVV1VKbU5tWm5SMVZKTjJZNVNqQkhOVTh3VmtwNmQzQktaR0ZoZFhkbmRFaG1OeXQzTTJaVlUyMXJSMlZxUzBkWkwxUnNRbmhaZW1GQ05pODJRbGxDYTBKb2JsaGllVWszVjBkbVRVeFRaelp6TldZMFpUWnlWVnAxTDNGYU5FOTFhMFY2TUZOdFlYVlhWMDh2VkhCbmQyZGFPVEJxVlRVNE1rcFFRMFpwZVVKaFZrOU1kSFYxWlhOS09ETkhRV2N6YWxjNU1GcHBXamMxU1ZscmNsaEdhbU5ZZHpFMFNHY3JTalpzVFVSTE1ERjNNazF0YVRkQmEwNUdhWE0zUkdOdE1YaFpiRzlYVTJVM1MzSnhkRlZCVmxNeFJXRTNlV3hyTkVoQ1p6WXhNbGh0YUd4c1pEaERZWGd6YTNveVJUSm9iWGxUZUdnNVRsTnNibnBYYkZabFkwNWFOblJoYjJJeGFrSkhWbFp0TkZWSFJUZFRWelJ1VEdSV1VITm1UelJoTlROcFltMHhiRFJSYm5GVk4zWjRjRkpTWTJabVNuTmtUMFZ6WTFoblNHbEdabEZ4TDJKQ2RUYzBRakZ5V1doaFMwVmtRV1pNTVRCMVRWVlRRVU0zZWk5S01ETnlSVlZvWnpRdmFIRjROV2Q1YnpWeFUwMXJNV0ZIZVhVM2VFOW1hMWxVYjAwMFQxa3paWGRWWjJob01YQlNSalJSTjBSclp6WlJTMjAxWWpkNE1uaHpXRk5FYWtGeVJUa3JkMnRwUkZOWkwxSnBhRU0yY0UxNlUxbE1OSEYyTUVacVFWUmlhRXRQWlZoM056VlNTelZIZFZkM1RtUk5WMGxTTmtwblJWVkJXbk5NV2tsaFpVc3lRMjQ1ZFhWTVlqZzJZVTgyYVdKaGMxRm1TbFFyZFdoMU5tNWpOR0ZSUFNJc0ltMWhZeUk2SWpsbE9USTFaR1F5TWpkaU1tTTRaVE0yWVRkallUVmlOR014WW1abVlqZGhNamhqT1RSak5EazFZVEl6WkdSaE56bG1OemhoWldObE1tTmhaR014TmpRaUxDSjBZV2NpT2lJaWZRPT0=', 1787068835);
INSERT INTO `sessions` VALUES ('DpuDhmSfBxfv97NJZyYR6SarzVXHZIV3boH4xQGu', NULL, '10.200.11.1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', 'ZXlKcGRpSTZJbWtyUjJNNWNrUnNOMDFsTVZVNU9EQlZNbEV5ZFhjOVBTSXNJblpoYkhWbElqb2lXRUpWUVVOb1FUSnpaemx3TDFsVEszSnNSa0ZCWnpscWEwZGxkRUUwYVc1VmJtRlFPRGROTWtwMVVteG5ZVlo0TW1KclkwWlpiVTlNVTNoelQycHZVekI0YjFVeVZsSndiM2dyV0VwdWFUaHJUVWszYW1rNGRrdEJPVUV3ZVZGWmNGZzNUakpWY0VReWJYUnhWVXhSTVhwRmRVY3lVRTV2Y1VRMU1tNTNWMGRMZW1aRVFXWktjVEZFUkZaalZFeEhkWFZHTTFOU04zZFpRalphTkVSTFlrc3haWFp2WVd4eE9VRm5UM0ZqVUU4eFlrMWlTSGxNZEVwVmVsUmlkRmxyZEZSWVJpOW1XRzFuTTJWRGJ6WXdRa2gyV2sxSVVFbEZhVkIxVGtOcVkyTkNNbXRhVDNvM01sbEpSbFZtUlVOVGRUaEtjQzlhYlhSc1JrbFVhek5oTkRkaFYxaFphRWR2VTNsT2FrUjZZMnA1Y1dSMlNsRkNUM2x5U1ZSdGNUUkViMVJzU1RsQlVqUkNXakE5SWl3aWJXRmpJam9pTmpZd01ERmtORFUyTVRNME1XTXhNRFJtT0RsbU1qSmxOREprT0RObFpUWXdZMll5TWpoaE1tTmtOR1l6WkdZeE1qZzJNR00zTW1SbVpXVTVZamM1TWlJc0luUmhaeUk2SWlKOQ==', 1787065027);
INSERT INTO `sessions` VALUES ('NhroV5Dkan2rwsPHKMcG8nEZnBiAtndmkaavkHpp', NULL, '10.200.11.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', 'ZXlKcGRpSTZJakJtVkc5eE16SlFSR0paWnk5WUwwa3hRVlJ3Um5jOVBTSXNJblpoYkhWbElqb2lRMVZSTUhCUWVVNVdWMDVVTTBWTFJuTmFaWGcxY1ZOTVFXZzBWVzVYSzNKek5DOHhkRVUxUVdOdldtcGtlRlJ5UldwalJqRlFLM2h3YTIxb2FGVmFTVzlRYVV0eE9IQm5aM2N3SzJ0emIzQkhXVEpySzJOTlJUbHNaVVpOVFRrNGMySjZXVEJYTUU1VE1ERTFSRGRsYUdwbE1XNURhM0YwVG5SUGQydFJiVE41VFVGTVYwVkNWRWczTWxWTWNEVkZPVlF5TTFCMFNrY3daVlJKVW1kU0wxaDJPRTAwU1ZrMGFVNVVOMVU0TDNGVFVGWlFRakYwTVVwWGNHY3dSRTlIWVdSYVpsTnRRMmxaUVhwTFJuTXhjMHBYZFRSbVEyaFdUM0E1UjNKblpISlpOMDFWY0hSUVRDdE9NRXBhTW5WTVVuQldWbEY2ZDFGNFIzVkhNMUpyVTBaYVUyMW1NRGhGZEhobFpqQlhTMFpWWkhobE4yMTBRVll3ZG1KcFlrUTJRVWRWSzBSMlpsaFpVWGM5SWl3aWJXRmpJam9pTUdRME4yRTNaR1poWm1ZNFltWTNZV0k1Wm1Wa1pUWmxOR1l6WmpJMFlUWTFZalV3WVRVd1ltRmtNbVJqWTJNek9UTm1ORFZoTVRFeFlUbGtPVE0xTWlJc0luUmhaeUk2SWlKOQ==', 1787065107);
INSERT INTO `sessions` VALUES ('ufYpQTFGnTUzNNTCGYWFqzQVDaRHm2MmdnTy1c4o', NULL, '10.200.11.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', 'ZXlKcGRpSTZJa3hpU0RKc1IwVjJja012V205WmVDOWlVSGxVWVdjOVBTSXNJblpoYkhWbElqb2lOSEYwTTBaRFZqbHhSelJTY1VRdlQyRkdRMGxzWnpaTWFDdHRNVkJOVUVsTVQxUXpZa2huVlU5cGFEQjJUVEp4VTNkck9FUmxSbEZqVkcwM1RqRkhTVE5qWm1Zek5rRXhWVXhpVTI4M1pETnpkVTFVZVhkVlFWRkRlR3RHVlU5NmFVZFBVWGxYYlZWalNuSkJUekpwYlZoUU5rTlNNelZ4UjBOUFl6SnBiRWxwWmxOemRHdFllbWRKT0ZWa1NYTlZWa3RLZWt0UE0yZzJVaXRXZW1ZeU0xVmFiMmRCUkVNMFNUWTFTbEJtTlZsR1VrMVFNRVZhVjBWV05WZE5WeTlhUVdaTU1GaGxRWEpWZVhKa1F6azRVemRqUldOalFqVnphVmhXYldKTk9ITjNkbmh1YkdkSFVsZEpTSGxFVUVobGVsSldRemc0T1VaNFozUTRNRU41YUhkeVRIZHZiMlpzY2tOMFZsZFFkV1pLVVVSRlRYVm5MMUpQYUdoUFdFVkdXVUozYmpreWNISmhja2s5SWl3aWJXRmpJam9pTlRBNU1XWmxZemRtWmpJMU1qaGlZV0l6Wldaa01HUmpZamswTjJVMk9UWTRNRFUwWm1SaVpUZGpNV0kwWWpsbE5qTTBaREUwWlRCalpXWXdOVFkwT1NJc0luUmhaeUk2SWlKOQ==', 1787065076);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `house_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_email_unique`(`email` ASC) USING BTREE,
  UNIQUE INDEX `users_username_unique`(`username` ASC) USING BTREE,
  UNIQUE INDEX `users_house_code_unique`(`house_code` ASC) USING BTREE,
  INDEX `users_is_active_index`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, NULL, 'Ketua RT 20', 'admin@admin.com', '2026-08-18 20:26:31', '$2y$12$KxFAOkjacXKDME2PFsWVJOqNGrDZO/6oywuqR91nFYxpRm.8T7P.u', 'doqMFD0GcorP2Ecc6IGdPOil5Ob5MH4ITVc6c00RwXbfCFhnVOd5QbWxxXe6', '2026-08-18 20:26:31', '2026-08-18 22:57:02', 'ketuart20', NULL, NULL, NULL, 1);

SET FOREIGN_KEY_CHECKS = 1;
