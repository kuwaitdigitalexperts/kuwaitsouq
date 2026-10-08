<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\City;
use App\Models\Country;
use App\Models\Neighborhood;
use Illuminate\Http\Request;

class CityAdminController extends Controller
{
    public function index(Request $request)
    {
        $countryId = $request->query('country_id');
        $query = City::with(['country', 'neighborhoods'])->withCount('ads');

        if ($countryId) {
            $query->where('country_id', $countryId);
        }

        $cities = $query->orderBy('pos')->paginate(20)->withQueryString();
        $countries = Country::orderBy('pos')->get();

        return view('admin.cities.index', compact('cities', 'countries', 'countryId'));
    }

    public function create()
    {
        $countries = Country::orderBy('pos')->get();
        return view('admin.cities.create', compact('countries'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'country_id' => 'required|exists:countries,id',
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'pos' => 'nullable|integer',
            'is_active' => 'nullable|boolean',
        ]);

        $validated['is_active'] = $request->boolean('is_active', true);
        City::create($validated);

        return redirect()->route('admin.cities.index', ['country_id' => $validated['country_id']])
            ->with('success', 'City added successfully!');
    }

    public function edit(int $id)
    {
        $city = City::with('neighborhoods')->findOrFail($id);
        $countries = Country::orderBy('pos')->get();
        return view('admin.cities.edit', compact('city', 'countries'));
    }

    public function update(Request $request, int $id)
    {
        $city = City::findOrFail($id);
        $validated = $request->validate([
            'country_id' => 'required|exists:countries,id',
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'pos' => 'nullable|integer',
            'is_active' => 'nullable|boolean',
        ]);

        $validated['is_active'] = $request->boolean('is_active', true);
        $city->update($validated);

        return redirect()->route('admin.cities.index', ['country_id' => $validated['country_id']])
            ->with('success', 'City updated successfully!');
    }

    public function destroy(int $id)
    {
        $city = City::findOrFail($id);
        $countryId = $city->country_id;
        $city->delete();

        return redirect()->route('admin.cities.index', ['country_id' => $countryId])
            ->with('success', 'City deleted.');
    }
}
