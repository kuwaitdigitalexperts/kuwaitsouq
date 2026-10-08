<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\ApiController;

/*
|--------------------------------------------------------------------------
| API Routes for KuwaitSouq Mobile App & Backend
|--------------------------------------------------------------------------
*/

$apiRoutes = function () {
    // Countries & Locations
    Route::get('/countries', [ApiController::class, 'countries']);
    Route::get('/countries/{id}/cities', [ApiController::class, 'cities']);
    Route::get('/locations', [ApiController::class, 'countries']);

    // Categories & Filters
    Route::get('/categories', [ApiController::class, 'categories']);
    Route::get('/categories/{identifier}/filters', [ApiController::class, 'filters']);

    // Ads
    Route::get('/ads', [ApiController::class, 'ads']);
    Route::get('/ads/search', [ApiController::class, 'ads']);
    Route::get('/ads/{id}', [ApiController::class, 'adDetail']);
    Route::post('/ads', [ApiController::class, 'createAd']);
    Route::post('/ads/{id}/media', [ApiController::class, 'uploadAdMedia']);
    Route::put('/ads/{id}', [ApiController::class, 'updateAd']);
    Route::delete('/ads/{id}', [ApiController::class, 'deleteAd']);
    Route::post('/ads/{id}/boost', [ApiController::class, 'boostAd']);
    Route::post('/ads/{id}/favorite', [ApiController::class, 'toggleFavorite']);

    // Stories
    Route::get('/stories', [ApiController::class, 'stories']);

    // Auth
    Route::post('/register', [ApiController::class, 'register']);
    Route::post('/login', [ApiController::class, 'login']);
    Route::post('/auth/login', [ApiController::class, 'login']);
    Route::post('/auth/phone', [ApiController::class, 'phoneAuth']);
    Route::post('/logout', [ApiController::class, 'logout']);

    // User Profile & Account
    Route::get('/me', [ApiController::class, 'me']);
    Route::put('/me', [ApiController::class, 'updateProfile']);
    Route::put('/profile', [ApiController::class, 'updateProfile']);
    Route::delete('/account', [ApiController::class, 'deleteAccount']);
    Route::get('/user/ads', [ApiController::class, 'userAds']);

    // Favorites / Saved Ads
    Route::get('/favorites', [ApiController::class, 'favorites']);
    Route::post('/favorites/toggle', [ApiController::class, 'toggleFavorite']);

    // In-App Chat Messages
    Route::get('/messages', [ApiController::class, 'messages']);
    Route::post('/messages', [ApiController::class, 'sendMessage']);

    // Automotive Special Services
    Route::post('/reports/carfax', [ApiController::class, 'requestCarFax']);
    Route::post('/services/kayishha', [ApiController::class, 'requestKayishha']);
};

Route::prefix('v1')->group($apiRoutes);
Route::group([], $apiRoutes);
