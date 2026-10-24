<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Models\Country;
use App\Models\City;
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
            $locale = 'ar'; // Default to Arabic for Kuwait
            session(['locale' => $locale]);
        }
        App::setLocale($locale);

        // 2. Kuwait-Only Country handling
        $currentCountry = Country::where('code', 'KW')->first()
            ?? Country::where('is_active', true)->first();

        if ($currentCountry) {
            session(['country_id' => $currentCountry->id]);
        }

        // Active Kuwait areas/cities for navigation and filters
        $allCities = City::where('country_id', $currentCountry->id ?? 1)
            ->where('is_active', true)
            ->orderBy('pos')
            ->get();

        // Share globally with all Blade views
        View::share('currentLocale', $locale);
        View::share('isRtl', $locale === 'ar');
        View::share('currentCountry', $currentCountry);
        View::share('allCountries', collect([$currentCountry]));
        View::share('allCities', $allCities);

        return $next($request);
    }
}
