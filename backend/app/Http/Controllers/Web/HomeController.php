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
        $kuwait = Country::where('code', 'KW')->first() ?? Country::where('is_active', true)->first();
        $currentCountry = $kuwait;

        // Parent Categories
        $categories = Category::whereNull('parent_id')
            ->where('is_active', true)
            ->withCount('ads')
            ->orderBy('pos')
            ->get();

        // Active stories
        $stories = SellerStory::where('is_active', true)
            ->with(['user', 'ad'])
            ->latest()
            ->take(15)
            ->get();

        // If no active stories in DB, provide default stories so status/story viewer is always functional
        if ($stories->isEmpty()) {
            $defaultStories = [
                (object)[
                    'id' => 1,
                    'user' => (object)['name' => 'الغانم للسيارات', 'avatar' => 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150'],
                    'media_path' => 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=900',
                    'caption' => 'تويوتا لاندكروزر 2024 VXR بحالة الوكالة - عداد 5,000 كم',
                    'ring_color' => 'blue',
                    'price' => '24,500 د.ك',
                    'time_ago' => 'منذ ساعة',
                    'ad_id' => 1,
                ],
                (object)[
                    'id' => 2,
                    'user' => (object)['name' => 'أبو فهد', 'avatar' => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'],
                    'media_path' => 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=900',
                    'caption' => 'فيلا فاخرة للبيع في صباح الأحمد البحرية صف أول على الخور',
                    'ring_color' => 'green',
                    'price' => '380,000 د.ك',
                    'time_ago' => 'منذ ساعتين',
                    'ad_id' => 2,
                ],
                (object)[
                    'id' => 3,
                    'user' => (object)['name' => 'كويت موتورز', 'avatar' => 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=150'],
                    'media_path' => 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900',
                    'caption' => 'بورش 911 GT3 موديل 2023 وكالة بهبهاني سيرفيس منتظم',
                    'ring_color' => 'orange',
                    'price' => '62,000 د.ك',
                    'time_ago' => 'منذ 3 ساعات',
                    'ad_id' => 3,
                ],
                (object)[
                    'id' => 4,
                    'user' => (object)['name' => 'عقارات حولي', 'avatar' => 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=150'],
                    'media_path' => 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900',
                    'caption' => 'شقة ديلوكس للإيجار إطلالة بحرية 3 غرف وصالة وموقفين',
                    'ring_color' => 'blue',
                    'price' => '650 د.ك / شهر',
                    'time_ago' => 'منذ 5 ساعات',
                    'ad_id' => 4,
                ],
                (object)[
                    'id' => 5,
                    'user' => (object)['name' => 'سكوتر شوب', 'avatar' => 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=150'],
                    'media_path' => 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=900',
                    'caption' => 'دراجة نارية رياضية ياماها R1 بحالة الوكالة فحص شامل',
                    'ring_color' => 'orange',
                    'price' => '3,200 د.ك',
                    'time_ago' => 'منذ 6 ساعات',
                    'ad_id' => 5,
                ],
            ];
            $stories = collect($defaultStories);
        }

        // Cities in Kuwait
        $cities = City::where('country_id', $kuwait->id ?? 1)->where('is_active', true)->orderBy('pos')->get();

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
