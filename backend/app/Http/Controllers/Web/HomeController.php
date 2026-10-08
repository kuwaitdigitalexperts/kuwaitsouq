<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Ad;
use App\Models\SellerStory;
use App\Models\Country;
use App\Models\City;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index(Request $request)
    {
        $countryId = session('country_id');
        $currentCountry = $countryId ? Country::find($countryId) : Country::where('is_default', true)->first();
        if (!$currentCountry) {
            $currentCountry = Country::first();
        }

        // Parent Categories
        $categories = Category::whereNull('parent_id')
            ->where('is_active', true)
            ->withCount('ads')
            ->orderBy('pos')
            ->get();

        // Active stories
        $stories = SellerStory::where('is_active', true)
            ->where(function ($q) {
                $q->whereNull('expires_at')->orWhere('expires_at', '>', now());
            })
            ->with('user')
            ->latest()
            ->take(15)
            ->get();

        // Cities in current country
        $cities = $currentCountry ? $currentCountry->cities()->where('is_active', true)->get() : collect();

        // Ads Query
        $adsQuery = Ad::where('status', 'active')
            ->with(['category', 'subCategory', 'city', 'neighborhood', 'media', 'user']);

        if ($currentCountry) {
            $adsQuery->where('country_id', $currentCountry->id);
        }

        if ($request->filled('city_id')) {
            $adsQuery->where('city_id', $request->city_id);
        }

        if ($request->filled('q')) {
            $q = $request->q;
            $adsQuery->where(function ($query) use ($q) {
                $query->where('title', 'like', "%{$q}%")
                      ->orWhere('title_ar', 'like', "%{$q}%")
                      ->orWhere('description', 'like', "%{$q}%")
                      ->orWhere('description_ar', 'like', "%{$q}%");
            });
        }

        // Sorting
        $sort = $request->input('sort', 'latest');
        if ($sort === 'price_asc') {
            $adsQuery->orderBy('price', 'asc');
        } elseif ($sort === 'price_desc') {
            $adsQuery->orderBy('price', 'desc');
        } else {
            // Prioritize boosted / featured ads first, then latest
            $adsQuery->orderBy('is_boosted', 'desc')
                     ->orderBy('is_featured', 'desc')
                     ->orderBy('created_at', 'desc');
        }

        $ads = $adsQuery->paginate(12)->withQueryString();

        return view('web.home', compact('categories', 'stories', 'cities', 'ads', 'currentCountry'));
    }
}
