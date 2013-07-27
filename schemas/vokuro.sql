/*
SQLite Data Transfer

Source Server         : vokurosqlite
Source Server Version : 30706
Source Host           : :0

Target Server Type    : SQLite
Target Server Version : 30706
File Encoding         : 65001

Date: 2013-07-25 10:42:47
*/

PRAGMA foreign_keys = OFF;

-- ----------------------------
-- Table structure for "email_confirmations"
-- ----------------------------
DROP TABLE IF EXISTS "email_confirmations";
CREATE TABLE "email_confirmations" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"usersId"  INTEGER NOT NULL,
"code"  TEXT(32) NOT NULL,
"createdAt"  INTEGER NOT NULL,
"modifiedAt"  INTEGER,
"confirmed"  TEXT(1) DEFAULT "N"
);

-- ----------------------------
-- Records of email_confirmations
-- ----------------------------
INSERT INTO "email_confirmations" VALUES (1, 14, 'FK9AlsO6RRsiqmux0PI9EKfzHoFRR2a7', 1366990529, 1366992523, 'Y');
INSERT INTO "email_confirmations" VALUES (2, 15, 'nOLpYKwCFqPYm8fXZ6osjkKUKNaVahp', 1367473328, 1367505447, 'Y');
INSERT INTO "email_confirmations" VALUES (3, 16, 'xMb8ZxTpJv2E3FPKod6OYJ7kDbw9hOLJ', 1367509740, 1367509761, 'Y');

-- ----------------------------
-- Table structure for "failed_logins"
-- ----------------------------
DROP TABLE IF EXISTS "failed_logins";
CREATE TABLE "failed_logins" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"usersId"  INTEGER,
"ipAddress"  TEXT(15) NOT NULL,
"attempted"  INTEGER NOT NULL
);

CREATE INDEX "idx_failed_logins_usersId" ON "failed_logins" ("usersId");

-- ----------------------------
-- Records of failed_logins
-- ----------------------------
INSERT INTO "failed_logins" VALUES (1, 2, '::1', 1366995290);
INSERT INTO "failed_logins" VALUES (2, 2, '::1', 1366995304);
INSERT INTO "failed_logins" VALUES (3, 2, '::1', 1366995309);
INSERT INTO "failed_logins" VALUES (4, 0, '::1', 1366995331);
INSERT INTO "failed_logins" VALUES (5, 2, '::1', 1366995342);
INSERT INTO "failed_logins" VALUES (6, 14, '::1', 1366995687);
INSERT INTO "failed_logins" VALUES (7, 14, '::1', 1366995825);
INSERT INTO "failed_logins" VALUES (8, 14, '::1', 1366996310);
INSERT INTO "failed_logins" VALUES (9, 2, '::1', 1366996324);
INSERT INTO "failed_logins" VALUES (10, 2, '127.0.0.1', 1367000208);
INSERT INTO "failed_logins" VALUES (11, 14, '127.0.0.1', 1367012708);
INSERT INTO "failed_logins" VALUES (12, 2, '::1', 1367014700);
INSERT INTO "failed_logins" VALUES (13, 14, '::1', 1367014714);
INSERT INTO "failed_logins" VALUES (14, 14, '::1', 1367014724);
INSERT INTO "failed_logins" VALUES (15, 14, '::1', 1367014830);
INSERT INTO "failed_logins" VALUES (16, 14, '::1', 1367014843);
INSERT INTO "failed_logins" VALUES (17, 2, '::1', 1367014916);
INSERT INTO "failed_logins" VALUES (18, 2, '::1', 1367014926);
INSERT INTO "failed_logins" VALUES (19, 2, '::1', 1367015303);
INSERT INTO "failed_logins" VALUES (20, 14, '::1', 1367015786);
INSERT INTO "failed_logins" VALUES (21, 2, '127.0.0.1', 1367099996);

-- ----------------------------
-- Table structure for "password_changes"
-- ----------------------------
DROP TABLE IF EXISTS "password_changes";
CREATE TABLE "password_changes" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"usersId"  INTEGER NOT NULL,
"ipAddress"  TEXT(15) NOT NULL,
"userAgent"  TEXT(48) NOT NULL,
"createdAt"  INTEGER NOT NULL
);

-- ----------------------------
-- Records of password_changes
-- ----------------------------
INSERT INTO "password_changes" VALUES (1, 2, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 ', 1367014804);
INSERT INTO "password_changes" VALUES (2, 2, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 ', 1367014986);
INSERT INTO "password_changes" VALUES (3, 15, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 ', 1367505457);
INSERT INTO "password_changes" VALUES (4, 2, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 ', 1367511911);

-- ----------------------------
-- Table structure for "permissions"
-- ----------------------------
DROP TABLE IF EXISTS "permissions";
CREATE TABLE "permissions" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"profilesId"  INTEGER NOT NULL,
"resource"  TEXT(16) NOT NULL,
"action"  TEXT(16) NOT NULL
);

CREATE INDEX "idx_permissions_profilesId" ON "permissions" ("profilesId");

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO "permissions" VALUES (90, 3, 'users', 'index');
INSERT INTO "permissions" VALUES (91, 3, 'users', 'search');
INSERT INTO "permissions" VALUES (92, 3, 'profiles', 'index');
INSERT INTO "permissions" VALUES (93, 3, 'profiles', 'search');
INSERT INTO "permissions" VALUES (105, 1, 'users', 'index');
INSERT INTO "permissions" VALUES (106, 1, 'users', 'search');
INSERT INTO "permissions" VALUES (107, 1, 'users', 'edit');
INSERT INTO "permissions" VALUES (108, 1, 'users', 'create');
INSERT INTO "permissions" VALUES (109, 1, 'users', 'delete');
INSERT INTO "permissions" VALUES (110, 1, 'users', 'changePassword');
INSERT INTO "permissions" VALUES (111, 1, 'profiles', 'index');
INSERT INTO "permissions" VALUES (112, 1, 'profiles', 'search');
INSERT INTO "permissions" VALUES (113, 1, 'profiles', 'edit');
INSERT INTO "permissions" VALUES (114, 1, 'profiles', 'create');
INSERT INTO "permissions" VALUES (115, 1, 'profiles', 'delete');
INSERT INTO "permissions" VALUES (116, 1, 'permissions', 'index');
INSERT INTO "permissions" VALUES (117, 2, 'users', 'index');
INSERT INTO "permissions" VALUES (118, 2, 'users', 'search');
INSERT INTO "permissions" VALUES (119, 2, 'users', 'edit');
INSERT INTO "permissions" VALUES (120, 2, 'users', 'create');
INSERT INTO "permissions" VALUES (121, 2, 'profiles', 'index');
INSERT INTO "permissions" VALUES (122, 2, 'profiles', 'search');

-- ----------------------------
-- Table structure for "profiles"
-- ----------------------------
DROP TABLE IF EXISTS "profiles";
CREATE TABLE "profiles" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"name"  TEXT(64) NOT NULL,
"active"  TEXT(1) NOT NULL
);

CREATE INDEX "idx_profiles_active" ON "profiles" ("active");

-- ----------------------------
-- Records of profiles
-- ----------------------------
INSERT INTO "profiles" VALUES (1, 'Administrators', 'Y');
INSERT INTO "profiles" VALUES (2, 'Users', 'Y');
INSERT INTO "profiles" VALUES (3, 'Read-Only', 'Y');

-- ----------------------------
-- Table structure for "remember_tokens"
-- ----------------------------
DROP TABLE IF EXISTS "remember_tokens";
CREATE TABLE "remember_tokens" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"usersId"  INTEGER NOT NULL,
"token"  TEXT(32) NOT NULL,
"userAgent"  TEXT(120) NOT NULL,
"createdAt"  INTEGER NOT NULL
);

CREATE INDEX "idx_remember_tokens_token" ON "remember_tokens" ("token");

-- ----------------------------
-- Records of remember_tokens
-- ----------------------------
INSERT INTO "remember_tokens" VALUES (1, 2, 'af4e9eeb963b78bcb14f9311e024180e', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32', 1367286980);
INSERT INTO "remember_tokens" VALUES (2, 2, 'af4e9eeb963b78bcb14f9311e024180e', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32', 1367287035);
INSERT INTO "remember_tokens" VALUES (3, 2, 'af4e9eeb963b78bcb14f9311e024180e', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32', 1367469635);

-- ----------------------------
-- Table structure for "reset_passwords"
-- ----------------------------
DROP TABLE IF EXISTS "reset_passwords";
CREATE TABLE "reset_passwords" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"usersId"  INTEGER NOT NULL,
"code"  TEXT(48) NOT NULL,
"createdAt"  INTEGER NOT NULL,
"modifiedAt"  INTEGER,
"reset"  TEXT(1) NOT NULL
);

CREATE INDEX "idx_reset_passwords_usersId" ON "reset_passwords" ("usersId");

-- ----------------------------
-- Records of reset_passwords
-- ----------------------------
INSERT INTO "reset_passwords" VALUES (1, 14, '6GNAd4EdOjeieWmM7qHzVkzRKMGqio', 1367004843, 1367005241, 'N');
INSERT INTO "reset_passwords" VALUES (2, 2, 'k2NKSEPUglk0evZcnkj6ySJTOQGLp', 1367005353, 1367005412, 'N');
INSERT INTO "reset_passwords" VALUES (3, 2, 'G8aR8g3N59oqzya1PcgfZppR0BwTrftK', 1367005359, null, 'N');
INSERT INTO "reset_passwords" VALUES (4, 2, '0BWiJtoBlU8KrCL8D8znAPlfpL0R', 1367012735, 1367012764, 'N');
INSERT INTO "reset_passwords" VALUES (5, 2, 'GAZnwnNiwagQDgko0JGyOLhckEaoVX', 1367014760, 1367014968, 'Y');

-- ----------------------------
-- Table structure for "success_logins"
-- ----------------------------
DROP TABLE IF EXISTS "success_logins";
CREATE TABLE "success_logins" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"usersId"  INTEGER NOT NULL,
"ipAddress"  TEXT(15) NOT NULL,
"userAgent"  TEXT(120) NOT NULL
);

CREATE INDEX "idx_success_logins_usersId" ON "success_logins" ("usersId");

-- ----------------------------
-- Records of success_logins
-- ----------------------------
INSERT INTO "success_logins" VALUES (48, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (49, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (50, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (51, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (52, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (53, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (54, 2, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.32 (KHTML, like Gecko) Chrome/27.0.1418.0 Safari/537.32');
INSERT INTO "success_logins" VALUES (55, 2, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31');
INSERT INTO "success_logins" VALUES (56, 15, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31');
INSERT INTO "success_logins" VALUES (57, 16, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31');
INSERT INTO "success_logins" VALUES (58, 2, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31');
INSERT INTO "success_logins" VALUES (59, 2, '::1', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31');

-- ----------------------------
-- Table structure for "users"
-- ----------------------------
DROP TABLE IF EXISTS "users";
CREATE TABLE "users" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"name"  TEXT(32) NOT NULL,
"email"  TEXT(48) NOT NULL,
"password"  TEXT(60) NOT NULL,
"mustChangePassword"  TEXT(1),
"profilesId"  INTEGER NOT NULL,
"banned"  TEXT(1) NOT NULL,
"suspended"  TEXT(1) NOT NULL,
"active"  TEXT(1),
"provider" TEXT(20),
"identifier" TEXT(200)
);

CREATE INDEX "idx_users_profilesId" ON "users" ("profilesId");

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "users" VALUES (2, 'Bob Burnquist', 'bob@phalconphp.com', '$2a$08$Lx1577KNhPa9lzFYKssadetmbhaveRtCoVaOnoXXxUIhrqlCJYWCW', 'N', 1, 'N', 'N', 'Y', '', '');
INSERT INTO "users" VALUES (14, 'Erik', 'erik@phalconphp.com', '$2a$08$f4llgFQQnhPKzpGmY1sOuuu23nYfXYM/EVOpnjjvAmbxxDxG3pbX.', 'N', 1, 'Y', 'Y', 'Y', '', '');
INSERT INTO "users" VALUES (15, 'Veronica', 'veronica@phalconphp.com', '$2a$08$NQjrh9fKdMHSdpzhMj0xcOSwJQwMfpuDMzgtRyA89ADKUbsFZ94C2', 'N', 1, 'N', 'N', 'Y', '', '');
INSERT INTO "users" VALUES (16, 'Yukimi Nagano', 'yukimi@phalconphp.com', '$2a$08$cxxpy4Jvt6Q3xGKgMWIILuf75RQDSroenvoB7L..GlXoGkVEMoSr.', 'N', 2, 'N', 'N', 'Y', '', '');
