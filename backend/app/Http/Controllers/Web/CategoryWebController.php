<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\CategoryFilter;
use App\Models\Ad;
use App\Models\SellerStory;
use App\Models\Country;
use Illuminate\Http\Request;

class CategoryWebController extends Controller
{
    /**
     * Show Category / Subcategory view matching Screenshots 1 & 2
     */
    public function show(Request $request, string $slug)
    {
        $countryId = session('country_id');
        $currentCountry = $countryId ? Country::find($countryId) : Country::where('is_default', true)->first();

        $category = Category::where('slug', $slug)
            ->with(['subcategories', 'filters.options'])
            ->firstOrFail();

        // Check if this category has a parent or if it is a main category
        $mainCategory = $category->parent ? $category->parent : $category;
        $isSubcategory = (bool) $category->parent_id;

        // Subcategories to show in 2-column grid (Screenshot 1)
        $subcategories = $category->subcategories()->orderBy('pos')->get();

        // Filters to show (from main category or current subcategory)
        $filters = CategoryFilter::where(function ($q) use ($category, $mainCategory) {
            $q->where('category_id', $category->id)
              ->orWhere('category_id', $mainCategory->id);
        })
        ->with('options')
        ->orderBy('pos')
        ->get();

        // Quick brand cards (like Toyota, Ford, etc. in Screenshot 2)
        $brandFilter = $filters->where('filter_key', 'car_make')->first();
        $brandOptions = $brandFilter ? $brandFilter->options()->where('is_quick_card', true)->get() : collect();

        // Stories carousel
        $stories = SellerStory::where('is_active', true)
            ->with('user')
            ->latest()
            ->take(12)
            ->get();

        // Query Ads
        $adsQuery = Ad::where('status', 'active')
            ->with(['category', 'subCategory', 'city', 'neighborhood', 'media', 'user']);

        if ($currentCountry) {
            $adsQuery->where('country_id', $currentCountry->id);
        }

        if ($isSubcategory) {
            $adsQuery->where('sub_category_id', $category->id);
        } else {
            $adsQuery->where(function ($q) use ($category) {
                $q->where('category_id', $category->id)
                  ->orWhere('sub_category_id', $category->id);
            });
        }

        // Filter by city
        if ($request->filled('city_id')) {
            $adsQuery->where('city_id', $request->city_id);
        }

        // Search query
        if ($request->filled('q')) {
            $q = $request->q;
            $adsQuery->where(function ($query) use ($q) {
                $query->where('title', 'like', "%{$q}%")
                      ->orWhere('title_ar', 'like', "%{$q}%")
                      ->orWhere('description', 'like', "%{$q}%")
                      ->orWhere('description_ar', 'like', "%{$q}%");
            });
        }

        // Dynamic attribute filters (e.g. condition, car_make, model, transmission)
        foreach (['condition', 'car_make', 'model', 'transmission'] as $filterKey) {
            if ($request->filled($filterKey)) {
                $val = $request->input($filterKey);
                if ($filterKey === 'condition') {
                    $adsQuery->where('condition', $val);
                } else {
                    $adsQuery->where("attributes->{$filterKey}", $val);
                }
            }
        }

        // Sorting
        $sort = $request->input('sort', 'latest');
        if ($sort === 'price_asc') {
            $adsQuery->orderBy('price', 'asc');
        } elseif ($sort === 'price_desc') {
            $adsQuery->orderBy('price', 'desc');
        } else {
            $adsQuery->orderBy('is_boosted', 'desc')
                     ->orderBy('is_featured', 'desc')
                     ->orderBy('created_at', 'desc');
        }

        $totalCount = (clone $adsQuery)->count();
        $ads = $adsQuery->paginate(12)->withQueryString();

        $cities = $currentCountry ? $currentCountry->cities()->where('is_active', true)->get() : collect();

        return view('web.category', compact(
            'category',
            'mainCategory',
            'isSubcategory',
            'subcategories',
            'filters',
            'brandOptions',
            'stories',
            'ads',
            'totalCount',
            'cities',
            'currentCountry'
        ));
    }
}
