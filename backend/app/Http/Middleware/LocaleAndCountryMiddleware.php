<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Models\Country;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\View;

class LocaleAndCountryMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        // 1. Locale handling
        $locale = session('locale');
        if (!$locale) {
            $locale = 'ar'; // Default to Arabic for Gulf countries
            session(['locale' => $locale]);
        }
        App::setLocale($locale);

        // 2. Country handling
        $countryId = session('country_id');
        $currentCountry = null;

        if ($countryId) {
            $currentCountry = Country::where('is_active', true)->find($countryId);
        }

        if (!$currentCountry) {
            // Default to Saudi Arabia if URL has SA or default to Kuwait
            $currentCountry = Country::where('is_active', true)->where('is_default', true)->first()
                ?? Country::where('is_active', true)->first();
            if ($currentCountry) {
                session(['country_id' => $currentCountry->id]);
            }
        }

        $allCountries = Country::where('is_active', true)->orderBy('pos')->get();

        // Share globally with all Blade views
        View::share('currentLocale', $locale);
        View::share('isRtl', $locale === 'ar');
        View::share('currentCountry', $currentCountry);
        View::share('allCountries', $allCountries);

        return $next($request);
    }
}
