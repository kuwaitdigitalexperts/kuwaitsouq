<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Country;
use Illuminate\Http\Request;

class CountryWebController extends Controller
{
    /**
     * Switch active country
     */
    public function switchCountry(int $id)
    {
        $country = Country::where('is_active', true)->findOrFail($id);
        session(['country_id' => $country->id]);

        return redirect()->back()->with('success', 'Country updated to ' . $country->display_name);
    }

    /**
     * Switch language (Arabic / English)
     */
    public function switchLocale(string $locale)
    {
        if (in_array($locale, ['ar', 'en'])) {
            session(['locale' => $locale]);
        }

        return redirect()->back();
    }

    /**
     * Get cities for a specific country (AJAX)
     */
    public function getCities(int $id)
    {
        $country = Country::where('is_active', true)->findOrFail($id);
        $cities = $country->cities()->where('is_active', true)->get()->map(function ($city) {
            return [
                'id' => $city->id,
                'name' => $city->name,
                'name_ar' => $city->name_ar,
                'display_name' => $city->display_name,
            ];
        });

        return response()->json([
            'country' => [
                'id' => $country->id,
                'name' => $country->display_name,
                'currency' => $country->display_currency,
                'phone_code' => $country->phone_code,
            ],
            'cities' => $cities,
        ]);
    }
}
