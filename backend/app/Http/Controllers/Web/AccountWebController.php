<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class AccountWebController extends Controller
{
    /**
     * Account tab screen (Screenshots 8, 9, 10, 11)
     */
    public function index()
    {
        $user = Auth::user();

        // If guest, provide fallback values matching screenshot 8
        $isGuest = !$user;
        $profile = [
            'name' => $user ? $user->name : 'Guest',
            'member_since' => $user && $user->member_since ? $user->member_since->format('d/m/Y') : '01/05/2026',
            'rating' => $user ? $user->rating : 0.0,
            'rating_count' => $user ? $user->rating_count : 0,
            'member_id' => $user && $user->member_id_number ? $user->member_id_number : '81355485',
            'member_type' => $user ? $user->member_type : 'Free Member',
            'live_listings_limit' => $user ? $user->live_listings_limit : 20,
            'live_listings_count' => $user ? $user->ads()->where('status', 'active')->count() : 2,
            'listing_credits' => $user ? $user->listing_credits : 0,
            'vas_credits' => $user ? $user->vas_credits : 0,
            'cv_completeness' => $user ? $user->cv_completeness : 0,
            'cv_views' => $user ? $user->cv_views : 0,
            'job_applications_count' => $user ? $user->job_applications_count : 0,
            'member_views' => $user ? $user->member_views : 0,
            'listing_views' => $user ? $user->ads()->sum('views_count') : 0,
            'is_verified' => $user ? $user->is_verified : false,
        ];

        return view('web.account.index', compact('user', 'isGuest', 'profile'));
    }

    /**
     * Add wallet credit (Demo action)
     */
    public function addCredit(Request $request)
    {
        if (!Auth::check()) {
            return redirect()->route('login')->with('info', 'Please login to add wallet credits.');
        }

        $user = Auth::user();
        $type = $request->input('type', 'listing'); // listing or vas

        if ($type === 'vas') {
            $user->increment('vas_credits', 5);
            $msg = 'Added 5 VAS (Boost/Rocket) credits to your wallet!';
        } else {
            $user->increment('listing_credits', 5);
            $msg = 'Added 5 Listing credits to your wallet!';
        }

        return redirect()->route('account')->with('success', $msg);
    }

    /**
     * Update CV completeness (Demo action)
     */
    public function updateCv(Request $request)
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        $user = Auth::user();
        $user->update([
            'cv_completeness' => min(100, $user->cv_completeness + 25),
        ]);

        return redirect()->route('account')->with('success', 'CV profile updated!');
    }
}
