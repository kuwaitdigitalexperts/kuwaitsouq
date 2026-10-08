# KuwaitSouq (الكويت سوق)

Modern Classifieds & Marketplace Platform for Kuwait and the Gulf Countries (GCC). Built with **Laravel 12 / 13**, Blade, Tailwind CSS, and Sanctum REST API.

---

## 🌟 Highlights & Features Matching Provided Screenshots

1. **Multi-Country & Multi-City Engine (Gulf Countries):**
   - Pre-seeded with all 6 Gulf Countries:
     - 🇰🇼 **Kuwait** (`KWD` / `د.ك`, `+965`) - *Default*
     - 🇸🇦 **Saudi Arabia** (`SAR` / `ر.س`, `+966`)
     - 🇦🇪 **United Arab Emirates** (`AED` / `د.إ`, `+971`)
     - 🇶🇦 **Qatar** (`QAR` / `ر.ق`, `+974`)
     - 🇧🇭 **Bahrain** (`BHD` / `د.ب`, `+973`)
     - 🇴🇲 **Oman** (`OMR` / `ر.ع`, `+968`)
   - Dynamically filters listings, currencies, telephone codes, and city dropdowns per country.
   - Admin can add new countries and cities dynamically from the dashboard.

2. **Category Screen (Screenshot 1):**
   - Header with search, share, and notification badge.
   - City selector (`📍 All Cities ▾`), Sort (`⇅`), and Filters.
   - 2-Column rounded subcategory quick cards with custom icons (*Cars For Sale, Vehicle Accessories, Autos for Rent, Heavy Machinery, Vehicle Spare Parts, Plate Numbers*).
   - Seller Stories carousel with gradient rings and `+` add story button.
   - Feed listings preview with photo/video count badges `[📷 17] [📹 1]`, rocket boost badge `🚀`, red price, condition tag, location, Call button, WhatsApp button, and favorite heart.

3. **Subcategory & Dynamic Filters Screen (Screenshot 2):**
   - Horizontal filter pills (*Condition ▾, Car Make ▾, Model ▾, Transmission ▾, Year ▾*).
   - **Save Search** card with alert toggle switch.
   - **Visual Brand / Make Grid** with quick search input and brand buttons (*Toyota, Ford, Chevrolet, MG, Hyundai, Kia, Nissan, Haval, Mercedes, BMW, Lexus*).
   - Sponsored banner ad (*Kayishha style*).

4. **Ad Details Screen (Screenshots 4, 5, 6, 7):**
   - Sticky top bar on scroll with quick Call and WhatsApp buttons.
   - Top image slider with photo/video overlay badges `[📷 17] [📹 1]`, pagination dots, and rocket boost badge `🚀`.
   - Red bold price + **"Notify me if price drops"** alert link.
   - Full width Blue Call button, White WhatsApp/Chat button, `Favourite (3)` button, and `Share` button.
   - Key attributes specs table (*Condition, Listing ID, Published Date, Category, Subcategory, Neighborhood, City*).
   - Full rich text Description card.
   - **Similar Listings** list (Screenshot 6).
   - **Lister Profile Card** with Member Rating (`0.0 ⭐ (0) >`), Member Since (`17-08-2016`), and *"View all listings >"*.
   - **General Safety Tips** card.
   - **"Ask the Lister"** interactive box with quick chips (*"I'm interested"*, *"Can you lower the price"*, *"Where can we meet"*, *"You do delivery"*) + direct text input and instant AJAX send.

5. **Listings Tab (Screenshot 12):**
   - 4-Card Summary Grid:
     1. `My Listings` (count in blue)
     2. `Views` (count in blue)
     3. `Add New Listing` (camera icon)
     4. `Rating` (star icon)
   - Menu navigation list: *Draft Listings, Favorite Listings, Saved Searches, Recently Viewed, Recent Searches, Following Listings, Job Applications*.

6. **Account Tab (Screenshots 8, 9, 10, 11):**
   - **Get Verified User Badge** promo card.
   - User profile with Guest state OR Logged-in Seller state (*Al Ghanim global, Logo, Member ID with copy, Type: Free Member, Quota: Limit of live listings: 20*).
   - **Share My Account and Listings** with social sharing icons (*SMS, WhatsApp, Email, X/Twitter, Facebook, More*).
   - **Wallet** card (*Listing Credits, VAS Credits for Rocket boost, "+ Add Credit"*).
   - **"My CV" Job Portal** card with completeness meter, views, applications, and *"Manage CV"*.
   - **Stats** card (*Member Views, Listing Views*).
   - **Car reports** CarFax banner (*"Buy Now >"*).
   - **Help & Support** (*Contact Us, Sales Team, Request Feature*).
   - App version (*12.6.04*) and About link.

7. **Universal Phone & 1-Click Demo Login (No SMS Barriers!):**
   - Supports all Gulf codes (+965, +966, +971, +974, +973, +968) and global numbers (+1, +44, +91, +92, etc.).
   - Includes **Instant 1-Click Role Switcher** in the top navigation bar to test as:
     - `Guest`
     - `Al Ghanim global` (Verified Seller)
     - `Abu Fahad` (Standard Member)
     - `KuwaitSouq Admin` (Super Administrator)

8. **Admin Control Panel (`/admin`):**
   - Dedicated dashboard with Gulf breakdown and live metrics.
   - Full CRUD for Countries, Cities, and Neighborhoods.
   - Full CRUD for Categories and Subcategories with custom icons.
   - Full CRUD for Dynamic Category Filters and brand quick cards.
   - Ads Moderation & Rocket Boost 🚀 toggle.
   - User Management with Verified Badge toggle and Wallet credit grants.

9. **RESTful API (`/api/v1`):**
   - `/api/v1/countries`
   - `/api/v1/countries/{id}/cities`
   - `/api/v1/categories`
   - `/api/v1/categories/{slug}/filters`
   - `/api/v1/ads`
   - `/api/v1/ads/{id}`
   - `/api/v1/stories`
   - `/api/v1/auth/login` (Laravel Sanctum Bearer tokens)

---

## 🚀 Running the Project

```bash
cd /Users/uzair/kuwait_projects/KuwaitSouq

# Start the PHP server
php artisan serve
```

Visit in your browser:
- **Public Portal:** `http://127.0.0.1:8000`
- **Category View:** `http://127.0.0.1:8000/category/autos`
- **Subcategory & Filters:** `http://127.0.0.1:8000/category/cars-for-sale`
- **Ad Details:** `http://127.0.0.1:8000/ads/1`
- **Listings Tab:** `http://127.0.0.1:8000/listings`
- **Account Tab:** `http://127.0.0.1:8000/account`
- **Admin Panel:** `http://127.0.0.1:8000/admin` (Email: `admin@kuwaitsouq.com`, Password: `password123`)
