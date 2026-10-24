<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\City;
use App\Models\Country;
use App\Models\Neighborhood;
use Illuminate\Http\Request;

class CityAdminController extends Controller
{
    /**
     * Display all Kuwait governorates & areas
     */
    public function index(Request $request)
    {
        $kuwait = Country::where('code', 'KW')->first();
        $countryId = $kuwait ? $kuwait->id : 1;

        $cities = City::where('country_id', $countryId)
            ->with(['neighborhoods'])
            ->withCount('ads')
            ->orderBy('pos')
            ->paginate(30);

        return view('admin.cities.index', compact('cities', 'countryId'));
    }

    /**
     * Store a new Kuwait location/area
     */
    public function store(Request $request)
    {
        $kuwait = Country::where('code', 'KW')->first();
        $countryId = $kuwait ? $kuwait->id : 1;

        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'pos' => 'nullable|integer',
            'is_active' => 'nullable|boolean',
        ]);

        $validated['country_id'] = $countryId;
        $validated['is_active'] = $request->boolean('is_active', true);
        $validated['pos'] = $validated['pos'] ?? ((int) City::where('country_id', $countryId)->max('pos') + 1);

        City::create($validated);

        return redirect()->route('admin.cities.index')
            ->with('success', 'Kuwait area added successfully! (تمت إضافة المنطقة بنجاح)');
    }

    /**
     * Update an existing Kuwait location
     */
    public function update(Request $request, int $id)
    {
        $city = City::findOrFail($id);
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'pos' => 'nullable|integer',
            'is_active' => 'nullable|boolean',
        ]);

        $validated['is_active'] = $request->boolean('is_active', true);
        $city->update($validated);

        return redirect()->route('admin.cities.index')
            ->with('success', 'Kuwait area updated successfully! (تم تحديث المنطقة بنجاح)');
    }

    /**
     * Delete an area
     */
    public function destroy(int $id)
    {
        $city = City::findOrFail($id);
        $city->delete();

        return redirect()->route('admin.cities.index')
            ->with('success', 'Location deleted successfully.');
    }
}
