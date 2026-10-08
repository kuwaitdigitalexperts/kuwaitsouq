<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Country;
use Illuminate\Http\Request;

class CountryAdminController extends Controller
{
    public function index()
    {
        $countries = Country::withCount(['cities', 'ads'])->orderBy('pos')->get();
        return view('admin.countries.index', compact('countries'));
    }

    public function create()
    {
        return view('admin.countries.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'code' => 'required|string|max:5|unique:countries,code',
            'phone_code' => 'required|string|max:10',
            'currency' => 'required|string|max:10',
            'currency_ar' => 'required|string|max:10',
            'flag' => 'required|string|max:10',
            'is_active' => 'nullable|boolean',
            'pos' => 'nullable|integer',
        ]);

        $validated['is_active'] = $request->boolean('is_active');
        $validated['pos'] = $validated['pos'] ?? 0;

        Country::create($validated);

        return redirect()->route('admin.countries.index')->with('success', 'Country created successfully!');
    }

    public function edit(int $id)
    {
        $country = Country::findOrFail($id);
        return view('admin.countries.edit', compact('country'));
    }

    public function update(Request $request, int $id)
    {
        $country = Country::findOrFail($id);
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'code' => 'required|string|max:5|unique:countries,code,' . $country->id,
            'phone_code' => 'required|string|max:10',
            'currency' => 'required|string|max:10',
            'currency_ar' => 'required|string|max:10',
            'flag' => 'required|string|max:10',
            'is_active' => 'nullable|boolean',
            'pos' => 'nullable|integer',
        ]);

        $validated['is_active'] = $request->boolean('is_active');
        $country->update($validated);

        return redirect()->route('admin.countries.index')->with('success', 'Country updated successfully!');
    }

    public function destroy(int $id)
    {
        $country = Country::findOrFail($id);
        $country->delete();

        return redirect()->route('admin.countries.index')->with('success', 'Country deleted.');
    }
}
