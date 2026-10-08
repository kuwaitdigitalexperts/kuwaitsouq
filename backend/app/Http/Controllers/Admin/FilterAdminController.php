<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\CategoryFilter;
use App\Models\CategoryFilterOption;
use Illuminate\Http\Request;

class FilterAdminController extends Controller
{
    public function index(Request $request)
    {
        $categoryId = $request->query('category_id');
        $query = CategoryFilter::with(['category', 'options']);

        if ($categoryId) {
            $query->where('category_id', $categoryId);
        }

        $filters = $query->orderBy('pos')->get();
        $categories = Category::orderBy('pos')->get();

        return view('admin.filters.index', compact('filters', 'categories', 'categoryId'));
    }

    public function create()
    {
        $categories = Category::orderBy('pos')->get();
        return view('admin.filters.create', compact('categories'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:100',
            'name_ar' => 'nullable|string|max:100',
            'filter_key' => 'required|string|max:50',
            'type' => 'required|in:select,pills,brands_grid,range,checkbox',
            'is_pinned' => 'nullable|boolean',
            'pos' => 'nullable|integer',
        ]);

        $validated['is_pinned'] = $request->boolean('is_pinned', true);
        $filter = CategoryFilter::create($validated);

        // Process options if provided
        if ($request->filled('options_text')) {
            $lines = explode("\n", str_replace("\r", "", $request->options_text));
            foreach ($lines as $idx => $line) {
                $line = trim($line);
                if (!empty($line)) {
                    $parts = array_map('trim', explode('|', $line));
                    $label = $parts[0];
                    $labelAr = $parts[1] ?? $label;
                    $value = $parts[2] ?? strtolower(str_replace(' ', '_', $label));
                    $isQuickCard = isset($parts[3]) && in_array($parts[3], ['1', 'true', 'yes']);

                    $filter->options()->create([
                        'label' => $label,
                        'label_ar' => $labelAr,
                        'value' => $value,
                        'is_quick_card' => $isQuickCard,
                        'pos' => $idx + 1,
                    ]);
                }
            }
        }

        return redirect()->route('admin.filters.index', ['category_id' => $validated['category_id']])
            ->with('success', 'Filter created successfully!');
    }

    public function edit(int $id)
    {
        $filter = CategoryFilter::with('options')->findOrFail($id);
        $categories = Category::orderBy('pos')->get();
        return view('admin.filters.edit', compact('filter', 'categories'));
    }

    public function update(Request $request, int $id)
    {
        $filter = CategoryFilter::findOrFail($id);
        $validated = $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:100',
            'name_ar' => 'nullable|string|max:100',
            'filter_key' => 'required|string|max:50',
            'type' => 'required|in:select,pills,brands_grid,range,checkbox',
            'is_pinned' => 'nullable|boolean',
            'pos' => 'nullable|integer',
        ]);

        $validated['is_pinned'] = $request->boolean('is_pinned', true);
        $filter->update($validated);

        return redirect()->route('admin.filters.index', ['category_id' => $validated['category_id']])
            ->with('success', 'Filter updated successfully!');
    }

    public function addOption(Request $request, int $filterId)
    {
        $filter = CategoryFilter::findOrFail($filterId);
        $validated = $request->validate([
            'label' => 'required|string|max:100',
            'label_ar' => 'nullable|string|max:100',
            'value' => 'required|string|max:100',
            'is_quick_card' => 'nullable|boolean',
            'icon' => 'nullable|string|max:255',
        ]);

        $validated['is_quick_card'] = $request->boolean('is_quick_card');
        $validated['pos'] = $filter->options()->count() + 1;

        $filter->options()->create($validated);

        return back()->with('success', 'Option added!');
    }

    public function deleteOption(int $optionId)
    {
        $opt = CategoryFilterOption::findOrFail($optionId);
        $opt->delete();

        return back()->with('success', 'Option deleted.');
    }

    public function destroy(int $id)
    {
        $filter = CategoryFilter::findOrFail($id);
        $filter->delete();

        return redirect()->route('admin.filters.index')->with('success', 'Filter deleted.');
    }
}
