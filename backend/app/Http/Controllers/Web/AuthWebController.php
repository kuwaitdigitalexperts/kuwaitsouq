<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class AuthWebController extends Controller
{
    public function showLogin()
    {
        return view('web.auth.login');
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'login_id' => 'required|string',
            'password' => 'required|string',
        ]);

        $loginInput = $request->input('login_id');

        // Check by email or phone
        $user = User::where('email', $loginInput)
            ->orWhere('phone', $loginInput)
            ->orWhere('phone', preg_replace('/[^0-9]/', '', $loginInput))
            ->first();

        // Allow 000000 master PIN for testing
        if ($request->password === '000000') {
            if (!$user) {
                $cleaned = preg_replace('/[^0-9]/', '', $loginInput);
                $user = User::create([
                    'name' => 'KuwaitSouq Member',
                    'phone' => $loginInput,
                    'phone_code' => '+965',
                    'email' => "user_{$cleaned}@kuwaitsouq.app",
                    'password' => Hash::make('000000'),
                    'is_verified' => true,
                    'member_type' => 'Standard Member',
                    'member_since' => now(),
                    'live_listings_limit' => 20,
                ]);
            }
            Auth::login($user, $request->boolean('remember'));
            $request->session()->regenerate();
            return redirect()->intended(route('account'))->with('success', 'Logged in successfully with master PIN (000000).');
        }

        if ($user && Hash::check($request->password, $user->password)) {
            Auth::login($user, $request->boolean('remember'));
            $request->session()->regenerate();
            return redirect()->intended(route('account'))->with('success', 'Logged in successfully.');
        }

        return back()->withErrors([
            'login_id' => 'The provided credentials do not match our records.',
        ])->onlyInput('login_id');
    }

    public function showRegister()
    {
        return view('web.auth.register');
    }

    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20|unique:users,phone',
            'phone_code' => 'required|string|max:10',
            'email' => 'nullable|email|unique:users,email',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'phone' => preg_replace('/[^0-9]/', '', $validated['phone']),
            'phone_code' => $validated['phone_code'],
            'email' => $validated['email'] ?? null,
            'password' => Hash::make($validated['password']),
            'member_type' => 'Free Member',
            'member_id_number' => (string) mt_rand(10000000, 99999999),
            'member_since' => Carbon::now(),
            'live_listings_limit' => 20,
            'rating' => 0.0,
            'rating_count' => 0,
            'listing_credits' => 3, // Welcome free listing credits
            'vas_credits' => 1,     // 1 free boost credit
        ]);

        Auth::login($user);
        $request->session()->regenerate();

        return redirect()->route('account')->with('success', 'Account registered successfully!');
    }

    /**
     * 1-Click Demo Login Switcher (resolves phone/SMS barrier!)
     */
    public function demoLogin(string $role)
    {
        if ($role === 'guest') {
            Auth::logout();
            session()->invalidate();
            session()->regenerateToken();
            return redirect()->route('account')->with('info', 'Switched to Guest mode.');
        }

        $user = null;
        if ($role === 'seller' || $role === 'alghanim') {
            $user = User::where('name', 'Al Ghanim global')->first()
                ?? User::where('is_verified', true)->first();
        } elseif ($role === 'fahad' || $role === 'user') {
            $user = User::where('name', 'Abu Fahad')->first()
                ?? User::where('is_admin', false)->first();
        } elseif ($role === 'admin') {
            $user = User::where('is_admin', true)->first();
        }

        if ($user) {
            Auth::login($user);
            session()->regenerate();
            return redirect()->route('account')->with('success', 'Switched to: ' . $user->name);
        }

        return redirect()->route('account');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('home')->with('info', 'Logged out.');
    }
}
