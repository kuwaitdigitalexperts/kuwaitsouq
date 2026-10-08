<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Web\HomeController;
use App\Http\Controllers\Web\CategoryWebController;
use App\Http\Controllers\Web\AdWebController;
use App\Http\Controllers\Web\ListingWebController;
use App\Http\Controllers\Web\AccountWebController;
use App\Http\Controllers\Web\ChatWebController;
use App\Http\Controllers\Web\CountryWebController;
use App\Http\Controllers\Web\AuthWebController;

use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\DashboardAdminController;
use App\Http\Controllers\Admin\CountryAdminController;
use App\Http\Controllers\Admin\CityAdminController;
use App\Http\Controllers\Admin\CategoryAdminController;
use App\Http\Controllers\Admin\FilterAdminController;
use App\Http\Controllers\Admin\AdAdminController;
use App\Http\Controllers\Admin\UserAdminController;

/*
|--------------------------------------------------------------------------
| Web Routes for KuwaitSouq
|--------------------------------------------------------------------------
*/

// 1. Language & Country Switching
Route::get('/lang/{locale}', [CountryWebController::class, 'switchLocale'])->name('lang.switch');
Route::get('/country/switch/{id}', [CountryWebController::class, 'switchCountry'])->name('country.switch');
Route::get('/country/{id}/cities', [CountryWebController::class, 'getCities'])->name('country.cities');

// 2. Demo Login Switcher (resolves any login barrier!)
Route::get('/demo-login/{role}', [AuthWebController::class, 'demoLogin'])->name('demo.login');

// 3. User Authentication
Route::get('/login', [AuthWebController::class, 'showLogin'])->name('login');
Route::post('/login', [AuthWebController::class, 'login'])->name('login.post');
Route::get('/register', [AuthWebController::class, 'showRegister'])->name('register');
Route::post('/register', [AuthWebController::class, 'register'])->name('register.post');
Route::post('/logout', [AuthWebController::class, 'logout'])->name('logout');

// 4. Main App & Web Portal
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::get('/category/{slug}', [CategoryWebController::class, 'show'])->name('category.show');
Route::get('/ads/{id}', [AdWebController::class, 'show'])->name('ads.show');
Route::post('/ads/{id}/favorite', [AdWebController::class, 'toggleFavorite'])->name('ads.favorite');
Route::post('/ads/{id}/price-drop', [AdWebController::class, 'togglePriceDrop'])->name('ads.price-drop');
Route::post('/ads/{id}/quick-message', [AdWebController::class, 'sendQuickMessage'])->name('ads.quick-message');

// 5. Listings Tab (Screenshot 12)
Route::get('/listings', [ListingWebController::class, 'index'])->name('listings');

// 6. Account Tab (Screenshots 8, 9, 10, 11)
Route::get('/account', [AccountWebController::class, 'index'])->name('account');
Route::post('/account/add-credit', [AccountWebController::class, 'addCredit'])->name('account.add-credit');
Route::post('/account/update-cv', [AccountWebController::class, 'updateCv'])->name('account.update-cv');

// 7. Chats Tab
Route::get('/chats', [ChatWebController::class, 'index'])->name('chats');
Route::get('/chats/{userId}', [ChatWebController::class, 'show'])->name('chats.show');
Route::post('/chats/{userId}', [ChatWebController::class, 'send'])->name('chats.send');

// 8. Add Listing Tab (Center Camera Button)
Route::get('/add-listing', [AdWebController::class, 'create'])->name('ads.create');
Route::post('/add-listing', [AdWebController::class, 'store'])->name('ads.store');

// 9. Admin Control Panel
Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/login', [AdminAuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AdminAuthController::class, 'login'])->name('login.post');

    Route::middleware(['admin'])->group(function () {
        Route::post('/logout', [AdminAuthController::class, 'logout'])->name('logout');
        Route::get('/', [DashboardAdminController::class, 'index'])->name('dashboard');

        // Countries
        Route::resource('countries', CountryAdminController::class);

        // Cities
        Route::resource('cities', CityAdminController::class);

        // Categories & Subcategories
        Route::resource('categories', CategoryAdminController::class);

        // Dynamic Filters
        Route::resource('filters', FilterAdminController::class);
        Route::post('/filters/{id}/options', [FilterAdminController::class, 'addOption'])->name('filters.addOption');
        Route::delete('/filters/options/{id}', [FilterAdminController::class, 'deleteOption'])->name('filters.deleteOption');

        // Ads Moderation & Rocket Boost
        Route::get('/ads', [AdAdminController::class, 'index'])->name('ads.index');
        Route::post('/ads/{id}/boost', [AdAdminController::class, 'toggleBoost'])->name('ads.toggleBoost');
        Route::post('/ads/{id}/featured', [AdAdminController::class, 'toggleFeatured'])->name('ads.toggleFeatured');
        Route::post('/ads/{id}/status', [AdAdminController::class, 'updateStatus'])->name('ads.updateStatus');
        Route::delete('/ads/{id}', [AdAdminController::class, 'destroy'])->name('ads.destroy');

        // Users & Verified Badges
        Route::get('/users', [UserAdminController::class, 'index'])->name('users.index');
        Route::post('/users/{id}/toggle-verified', [UserAdminController::class, 'toggleVerified'])->name('users.toggleVerified');
        Route::post('/users/{id}/toggle-admin', [UserAdminController::class, 'toggleAdmin'])->name('users.toggleAdmin');
        Route::post('/users/{id}/credits', [UserAdminController::class, 'addCredits'])->name('users.addCredits');
    });
});

// Direct Storage Asset Serving (Guaranteed fallback for cPanel/Namecheap shared hosting)
Route::get('/storage/{path}', function (string $path) {
    $fullPath = storage_path('app/public/' . $path);
    if (!file_exists($fullPath)) {
        abort(404);
    }
    return response()->file($fullPath);
})->where('path', '.*');

