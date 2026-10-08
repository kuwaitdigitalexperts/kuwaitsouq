@extends('layouts.admin')

@section('title', 'Manage Categories & Subcategories')

@section('content')
<div class="mb-6 flex items-center justify-between">
    <div>
        <h1 class="text-xl font-black text-white">Categories & Subcategories</h1>
        <p class="text-xs text-slate-400 mt-0.5">Manage hierarchical categories, subcategories, and icons</p>
    </div>

    <button onclick="document.getElementById('addCatModal').classList.remove('hidden')" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-3.5 py-2 rounded-xl transition shadow">
        + Add Category / Subcategory
    </button>
</div>

<div class="space-y-4">
    @foreach($categories as $cat)
        <div class="bg-slate-950 rounded-2xl border border-slate-800 p-4">
            <div class="flex items-center justify-between pb-3 border-b border-slate-800/80 mb-3">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-blue-950 text-blue-400 flex items-center justify-center text-lg border border-blue-800/50">
                        <i class="fa-solid fa-shapes"></i>
                    </div>
                    <div>
                        <div class="text-sm font-extrabold text-white flex items-center gap-2">
                            <span>{{ $cat->name }}</span>
                            <span class="text-slate-400 font-['Cairo']">({{ $cat->name_ar }})</span>
                        </div>
                        <div class="text-[10px] text-slate-500 font-mono">slug: /category/{{ $cat->slug }} • {{ $cat->ads_count }} listings</div>
                    </div>
                </div>

                <div class="flex items-center gap-2">
                    <a href="{{ route('category.show', $cat->slug) }}" target="_blank" class="px-2.5 py-1 text-[11px] font-bold rounded-lg bg-slate-900 hover:bg-slate-800 text-slate-300">
                        View Live &rarr;
                    </a>
                </div>
            </div>

            <!-- Subcategories Chips Grid -->
            <div>
                <span class="text-[10px] uppercase tracking-wider text-slate-400 font-bold block mb-2">Subcategories:</span>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
                    @forelse($cat->subcategories as $sub)
                        <div class="p-2.5 bg-slate-900 border border-slate-800/80 rounded-xl flex items-center justify-between">
                            <div>
                                <div class="text-xs font-bold text-slate-200">{{ $sub->name }}</div>
                                <div class="text-[10px] text-slate-500 font-['Cairo']">{{ $sub->name_ar }}</div>
                            </div>
                            <span class="text-[10px] bg-slate-800 text-slate-400 px-1.5 py-0.5 rounded font-bold">{{ $sub->ads_count }}</span>
                        </div>
                    @empty
                        <span class="text-xs text-slate-500">No subcategories</span>
                    @endforelse
                </div>
            </div>
        </div>
    @endforeach
</div>

<!-- Add Category Modal -->
<div id="addCatModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
    <div class="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-5 shadow-2xl">
        <div class="flex items-center justify-between pb-3 border-b border-slate-800 mb-4">
            <h2 class="text-sm font-bold text-white">+ Add Category</h2>
            <button onclick="document.getElementById('addCatModal').classList.add('hidden')" class="text-slate-400 hover:text-white">&times;</button>
        </div>

        <form action="{{ route('admin.categories.store') }}" method="POST" class="space-y-3 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 mb-1">Parent Category (Leave empty if main)</label>
                <select name="parent_id" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                    <option value="">-- Main Category --</option>
                    @foreach($categories as $c)
                        <option value="{{ $c->id }}">{{ $c->name }} ({{ $c->name_ar }})</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Name (English)</label>
                <input type="text" name="name" required placeholder="e.g. Quad Bikes" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Name (Arabic)</label>
                <input type="text" name="name_ar" required placeholder="e.g. دبابات وسكوترات" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Slug (Optional)</label>
                <input type="text" name="slug" placeholder="e.g. quad-bikes" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>

            <div class="pt-3">
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-2.5 rounded-xl shadow">Save Category</button>
            </div>
        </form>
    </div>
</div>
@endsection
