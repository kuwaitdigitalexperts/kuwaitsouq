<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Ad;
use App\Models\Category;
use App\Models\Country;
use App\Models\City;
use App\Models\Neighborhood;
use App\Models\CategoryFilter;
use App\Models\Favorite;
use App\Models\PriceDropAlert;
use App\Models\Message;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class AdWebController extends Controller
{
    /**
     * Show Ad details (Screenshots 4, 5, 6, 7)
     */
    public function show(int $id)
    {
        $ad = Ad::with([
            'category',
            'subCategory',
            'country',
            'city',
            'neighborhood',
            'media',
            'user.ads' => function ($q) {
                $q->where('status', 'active');
            }
        ])->findOrFail($id);

        // Increment view count
        $ad->increment('views_count');
        if ($ad->user) {
            $ad->user->increment('member_views');
        }

        // Similar Ads (Screenshot 6)
        $similarAds = Ad::where('id', '!=', $ad->id)
            ->where('status', 'active')
            ->where(function ($q) use ($ad) {
                $q->where('category_id', $ad->category_id)
                  ->orWhere('sub_category_id', $ad->sub_category_id)
                  ->orWhere('city_id', $ad->city_id);
            })
            ->with(['media', 'city'])
            ->latest()
            ->take(6)
            ->get();

        $isFavorited = false;
        $hasPriceAlert = false;
        if (Auth::check()) {
            $isFavorited = Favorite::where('user_id', Auth::id())->where('ad_id', $ad->id)->exists();
            $hasPriceAlert = PriceDropAlert::where('user_id', Auth::id())->where('ad_id', $ad->id)->exists();
        }

        return view('web.ads.show', compact('ad', 'similarAds', 'isFavorited', 'hasPriceAlert'));
    }

    /**
     * Toggle Favorite
     */
    public function toggleFavorite(int $id)
    {
        if (!Auth::check()) {
            return response()->json([
                'success' => false,
                'require_auth' => true,
                'message' => 'Please login to save this listing.',
            ], 401);
        }

        $ad = Ad::findOrFail($id);
        $fav = Favorite::where('user_id', Auth::id())->where('ad_id', $ad->id)->first();

        if ($fav) {
            $fav->delete();
            $ad->decrement('favorites_count');
            $favorited = false;
            $msg = 'Removed from favorites';
        } else {
            Favorite::create([
                'user_id' => Auth::id(),
                'ad_id' => $ad->id,
            ]);
            $ad->increment('favorites_count');
            $favorited = true;
            $msg = 'Saved to favorites';
        }

        return response()->json([
            'success' => true,
            'favorited' => $favorited,
            'count' => $ad->fresh()->favorites_count,
            'message' => $msg,
        ]);
    }

    /**
     * Toggle Price Drop Alert
     */
    public function togglePriceDrop(int $id)
    {
        if (!Auth::check()) {
            return response()->json([
                'success' => false,
                'require_auth' => true,
                'message' => 'Please login to enable price alerts.',
            ], 401);
        }

        $ad = Ad::findOrFail($id);
        $alert = PriceDropAlert::where('user_id', Auth::id())->where('ad_id', $ad->id)->first();

        if ($alert) {
            $alert->delete();
            $enabled = false;
            $msg = 'Price alert turned off';
        } else {
            PriceDropAlert::create([
                'user_id' => Auth::id(),
                'ad_id' => $ad->id,
                'target_price' => $ad->price,
            ]);
            $enabled = true;
            $msg = 'You will be notified if the price drops!';
        }

        return response()->json([
            'success' => true,
            'enabled' => $enabled,
            'message' => $msg,
        ]);
    }

    /**
     * Quick message send from "Ask the Lister" box (Screenshot 7)
     */
    public function sendQuickMessage(Request $request, int $id)
    {
        $request->validate([
            'message' => 'required|string|max:1000',
        ]);

        if (!Auth::check()) {
            return response()->json([
                'success' => false,
                'require_auth' => true,
                'message' => 'Please login to message the seller.',
            ], 401);
        }

        $ad = Ad::findOrFail($id);
        if ($ad->user_id === Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'You cannot send a message to yourself.',
            ], 422);
        }

        Message::create([
            'ad_id' => $ad->id,
            'sender_id' => Auth::id(),
            'receiver_id' => $ad->user_id,
            'message' => $request->message,
            'is_read' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Message sent to seller!',
        ]);
    }

    /**
     * Add Listing Page (Create)
     */
    public function create()
    {
        if (!Auth::check()) {
            return redirect()->route('login')->with('info', 'Please login to post a listing.');
        }

        $countries = Country::where('is_active', true)->orderBy('pos')->get();
        $categories = Category::whereNull('parent_id')->where('is_active', true)->with('subcategories')->get();
        $user = Auth::user();

        return view('web.ads.create', compact('countries', 'categories', 'user'));
    }

    /**
     * Store Listing
     */
    public function store(Request $request)
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'title_ar' => 'nullable|string|max:255',
            'description' => 'required|string',
            'description_ar' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'country_id' => 'required|exists:countries,id',
            'city_id' => 'required|exists:cities,id',
            'neighborhood_name' => 'nullable|string|max:100',
            'category_id' => 'required|exists:categories,id',
            'sub_category_id' => 'nullable|exists:categories,id',
            'condition' => 'required|in:used,new',
            'phone' => 'required|string|max:20',
            'whatsapp' => 'nullable|string|max:20',
            'is_boosted' => 'nullable|boolean',
            'photos' => 'nullable|array',
            'photos.*' => 'string', // URL or uploaded image path
        ]);

        $country = Country::findOrFail($validated['country_id']);

        $attributes = [];
        if ($request->has('attributes') && is_array($request->attributes)) {
            $attributes = $request->attributes;
        }

        $ad = Ad::create([
            'user_id' => Auth::id(),
            'category_id' => $validated['category_id'],
            'sub_category_id' => $validated['sub_category_id'] ?? null,
            'country_id' => $validated['country_id'],
            'city_id' => $validated['city_id'],
            'neighborhood_name' => $validated['neighborhood_name'] ?? null,
            'title' => $validated['title'],
            'title_ar' => $validated['title_ar'] ?: $validated['title'],
            'description' => $validated['description'],
            'description_ar' => $validated['description_ar'] ?: $validated['description'],
            'price' => $validated['price'],
            'currency' => $country->currency,
            'condition' => $validated['condition'],
            'attributes' => $attributes,
            'phone' => $validated['phone'],
            'whatsapp' => $validated['whatsapp'] ?: $validated['phone'],
            'is_boosted' => $request->boolean('is_boosted'),
            'is_featured' => $request->boolean('is_boosted'),
            'status' => 'active',
            'published_at' => Carbon::now(),
        ]);

        // Handle photos
        $photos = $request->input('photos', []);
        if (empty($photos)) {
            // Default placeholder image
            $ad->media()->create([
                'type' => 'image',
                'file_path' => 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800',
                'is_primary' => true,
                'pos' => 1,
            ]);
        } else {
            foreach ($photos as $idx => $photoUrl) {
                if (!empty($photoUrl)) {
                    $ad->media()->create([
                        'type' => 'image',
                        'file_path' => $photoUrl,
                        'is_primary' => $idx === 0,
                        'pos' => $idx + 1,
                    ]);
                }
            }
        }

        return redirect()->route('ads.show', $ad->id)->with('success', 'Your listing has been posted successfully!');
    }
}
