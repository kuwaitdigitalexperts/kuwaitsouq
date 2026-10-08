<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Ad;
use App\Models\Category;
use App\Models\Country;
use App\Models\City;
use App\Models\User;
use App\Models\CategoryFilter;

class DashboardAdminController extends Controller
{
    public function index()
    {
        $stats = [
            'total_ads' => Ad::count(),
            'active_ads' => Ad::where('status', 'active')->count(),
            'boosted_ads' => Ad::where('is_boosted', true)->count(),
            'total_users' => User::count(),
            'verified_sellers' => User::where('is_verified', true)->count(),
            'total_categories' => Category::count(),
            'total_filters' => CategoryFilter::count(),
            'total_countries' => Country::count(),
            'total_cities' => City::count(),
        ];

        // Country breakdown
        $countryStats = Country::withCount(['ads', 'cities'])->orderBy('pos')->get();

        // Recent ads
        $recentAds = Ad::with(['user', 'category', 'country', 'city'])->latest()->take(6)->get();

        return view('admin.dashboard', compact('stats', 'countryStats', 'recentAds'));
    }
}
