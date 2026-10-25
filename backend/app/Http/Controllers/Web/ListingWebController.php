<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Ad;
use App\Models\Favorite;
use App\Models\SavedSearch;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ListingWebController extends Controller
{
    /**
     * Listings tab screen (Screenshot 12)
     */
    public function index(Request $request)
    {
        if (!Auth::check()) {
            return redirect()->route('login')->with('info', 'يرجى تسجيل الدخول للوصول إلى إعلاناتك.');
        }

        $user = Auth::user();

        // Stats for authenticated user
        $myListingsCount = $user->ads()->where('status', 'active')->count();
        $totalViews = $user->ads()->sum('views_count');
        $userRating = $user->rating ?? 0.0;
        $draftCount = $user->ads()->where('status', 'draft')->count();
        $favoriteCount = $user->favorites()->count();
        $savedSearchesCount = $user->savedSearches()->count();
        $jobAppsCount = $user->job_applications_count ?? 0;

        // If specific subview requested e.g. "my-ads" or "favorites"
        $tab = $request->query('tab', 'overview');
        $ads = collect();

        if ($tab === 'my_ads' && $user) {
            $ads = $user->ads()->with('media', 'city')->latest()->paginate(10);
        } elseif ($tab === 'favorites' && $user) {
            $ads = Ad::whereIn('id', $user->favorites()->pluck('ad_id'))
                ->with('media', 'city')
                ->latest()
                ->paginate(10);
        }

        return view('web.listings.index', compact(
            'user',
            'myListingsCount',
            'totalViews',
            'userRating',
            'draftCount',
            'favoriteCount',
            'savedSearchesCount',
            'jobAppsCount',
            'tab',
            'ads'
        ));
    }
}
