<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UserAdminController extends Controller
{
    public function index(Request $request)
    {
        $users = User::withCount('ads')->latest()->paginate(20);
        return view('admin.users.index', compact('users'));
    }

    public function toggleVerified(int $id)
    {
        $user = User::findOrFail($id);
        $user->is_verified = !$user->is_verified;
        $user->save();

        return back()->with('success', $user->is_verified ? 'Verified badge granted to ' . $user->name : 'Verification badge revoked.');
    }

    public function toggleAdmin(int $id)
    {
        $user = User::findOrFail($id);
        if ($user->id === auth()->id()) {
            return back()->with('error', 'You cannot change your own admin status.');
        }

        $user->is_admin = !$user->is_admin;
        $user->save();

        return back()->with('success', 'Admin status updated.');
    }

    public function addCredits(Request $request, int $id)
    {
        $user = User::findOrFail($id);
        $request->validate([
            'listing_credits' => 'nullable|integer|min:0',
            'vas_credits' => 'nullable|integer|min:0',
        ]);

        if ($request->filled('listing_credits')) {
            $user->increment('listing_credits', $request->listing_credits);
        }
        if ($request->filled('vas_credits')) {
            $user->increment('vas_credits', $request->vas_credits);
        }

        return back()->with('success', 'Credits added successfully!');
    }
}
