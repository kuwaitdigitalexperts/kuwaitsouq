# KuwaitSouq - Namecheap Deployment Guide (cPanel & VPS)

This guide walks you through deploying the **KuwaitSouq Laravel API & Web Backend** to **Namecheap Hosting** (Shared Stellar / Stellar Plus / Business cPanel, or Namecheap VPS) and connecting the Flutter mobile app to it.

---

## 1. Prerequisites on Namecheap cPanel

1. **PHP Version**:
   - Open cPanel -> **MultiPHP Manager**
   - Select PHP **8.2** or **8.3** for your domain or subdomain.
2. **PHP Extensions** (Enabled by default on Namecheap):
   - `pdo_mysql`, `mbstring`, `openssl`, `tokenizer`, `xml`, `ctype`, `json`, `bcmath`, `fileinfo`.

---

## 2. Step 1: Create MySQL Database

1. In cPanel, open **MySQL Database Wizard**.
2. **Step 1: Create Database**
   - Name: `kuwaitsouq` (Full name: `username_kuwaitsouq`).
3. **Step 2: Create Database User**
   - Username: `kuwaituser` (Full name: `username_kuwaituser`).
   - Password: Click *Password Generator* (copy the password safely).
4. **Step 3: Add User to Database**
   - Check **ALL PRIVILEGES** -> Click **Make Changes**.

---

## 3. Step 2: Upload Backend Files

### Option A (Recommended for Domain or Subdomain, e.g., `api.kuwaitsouq.com`):
1. In cPanel **Domains** (or **Subdomains**), set the **Document Root** to:
   ```
   kuwaitsouq/public
   ```
2. Upload the `backend` folder contents into `/home/username/kuwaitsouq/`.

### Option B (Main Domain `public_html` root):
1. Upload the entire `backend` directory contents directly into `public_html/`.
2. The included root `.htaccess` will **automatically forward all traffic** into `/public/` and block any public access to `.env`, `composer.json`, and sensitive directories.

---

## 4. Step 3: Configure Environment (`.env`)

1. In cPanel **File Manager** (ensure *Show Hidden Files* is enabled in Settings):
2. Rename or copy `.env.production.example` to `.env`.
3. Update the following lines with your domain and database credentials:

```ini
APP_NAME="KuwaitSouq"
APP_ENV=production
APP_KEY=base64:JqYHeWCHutPzPDLj6Oj/haNW4LdCVaVugzBW64Idouw=
APP_DEBUG=false
APP_URL=https://yourdomain.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=username_kuwaitsouq
DB_USERNAME=username_kuwaituser
DB_PASSWORD=your_generated_password

FILESYSTEM_DISK=public
SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database
```

---

## 5. Step 4: Import Database (Two Easy Ways)

### Method 1: Instant phpMyAdmin Import (No SSH required)
1. In cPanel, click **phpMyAdmin**.
2. Select your newly created database (`username_kuwaitsouq`) on the left panel.
3. Click the **Import** tab at the top.
4. Click **Choose File** -> select `backend/database/kuwaitsouq_full_mysql_import.sql`.
5. Scroll down and click **Import**.
   - *All tables, foreign keys, countries, cities, categories, dynamic filters, and live ads will be created and populated immediately.*

### Method 2: Via cPanel Terminal or SSH
If you have Terminal access in cPanel:
```bash
cd kuwaitsouq   # or public_html
php artisan migrate --force
php artisan db:seed --force
php artisan storage:link
```

---

## 6. Step 5: PHP Upload Limits & File Size Tuning (.user.ini)

The project includes pre-configured `.user.ini` files in both the project root and `public/` directory with:
```ini
upload_max_filesize = 64M
post_max_size = 64M
memory_limit = 256M
max_execution_time = 300
```
This guarantees that high-resolution ad photos (up to 64MB) and videos can be uploaded without encountering cPanel's default `2M` upload restriction.

---

## 7. Step 6: Setup Scheduled Tasks (cPanel Cron Jobs)

To automate cleanup, story expirations, and background notifications:
1. In cPanel, navigate to **Cron Jobs**.
2. Under **Add New Cron Job**, set the interval to **Once Per Minute** (`* * * * *`).
3. Enter the following command (replace `/home/username/public_html` with your actual path):
   ```bash
   /usr/local/bin/php /home/username/public_html/artisan schedule:run >> /dev/null 2>&1
   ```
4. Click **Add New Cron Job**.

---

## 8. Step 7: Connect the Flutter Mobile App

In the Flutter project (`/app`):
1. Open [`lib/core/api/api_client.dart`](file:///Users/uzair/kuwait_projects/KuwaitSouq/app/lib/core/api/api_client.dart):
2. Set `liveBaseUrl` to your Namecheap domain API path:
   ```dart
   static const String liveBaseUrl = 'https://yourdomain.com/api/v1';
   ```
3. When building the APK or iOS IPA, you can also pass it dynamically via build flag:
   ```bash
   flutter build apk --release --dart-define=API_URL=https://yourdomain.com/api/v1
   ```

---

## 9. Built-in Safeguards for Namecheap Shared Hosting

| Potential Shared Hosting Issue | Built-in Solution in KuwaitSouq |
|---|---|
| **FastCGI strips Bearer Tokens** | Both `public/.htaccess` and root `.htaccess` include `HTTP_AUTHORIZATION` preservation rules. |
| **Symlink function disabled** | `routes/web.php` has a native `/storage/{path}` fallback route, ensuring uploaded ad images never 404 even without symlinks. |
| **CORS errors on mobile/web** | `config/cors.php` is pre-configured with `allowed_origins => ['*']` and Sanctum headers allowed. |
| **Arabic text encoding** | MySQL connection and import dump are pre-configured with `utf8mb4` and `utf8mb4_unicode_ci`. |
| **Low upload limits (2MB default)** | Both root and `public/` include `.user.ini` raising upload limit to 64MB and memory to 256MB. |
| **Sensitive files exposure** | Root `.htaccess` strictly blocks `.env`, `composer.json`, `.user.ini`, `artisan`, and dot-files from web access. |
