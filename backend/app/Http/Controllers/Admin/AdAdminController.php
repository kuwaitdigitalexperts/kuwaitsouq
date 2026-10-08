<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Ad;
use Illuminate\Http\Request;

class AdAdminController extends Controller
{
    public function index(Request $request)
    {
        $status = $request->query('status');
        $query = Ad::with(['user', 'category', 'country', 'city', 'media']);

        if ($status) {
            $query->where('status', $status);
        }

        $ads = $query->latest()->paginate(15)->withQueryString();

        return view('admin.ads.index', compact('ads', 'status'));
    }

    public function toggleBoost(int $id)
    {
        $ad = Ad::findOrFail($id);
        $ad->is_boosted = !$ad->is_boosted;
        $ad->save();

        return back()->with('success', $ad->is_boosted ? 'Rocket boost activated for ad!' : 'Rocket boost removed.');
    }

    public function toggleFeatured(int $id)
    {
        $ad = Ad::findOrFail($id);
        $ad->is_featured = !$ad->is_featured;
        $ad->save();

        return back()->with('success', $ad->is_featured ? 'Ad marked as featured!' : 'Ad unfeatured.');
    }

    public function updateStatus(Request $request, int $id)
    {
        $ad = Ad::findOrFail($id);
        $status = $request->input('status', 'active');
        $ad->status = $status;
        $ad->save();

        return back()->with('success', 'Ad status changed to ' . $status);
    }

    public function destroy(int $id)
    {
        $ad = Ad::findOrFail($id);
        $ad->delete();

        return back()->with('success', 'Ad deleted.');
    }
}
