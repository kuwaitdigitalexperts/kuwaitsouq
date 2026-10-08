@extends('layouts.admin')

@section('title', 'Manage Dynamic Filters & Brands')

@section('content')
<div class="mb-6 flex flex-wrap items-center justify-between gap-3">
    <div>
        <h1 class="text-xl font-black text-white">Dynamic Filters Engine</h1>
        <p class="text-xs text-slate-400 mt-0.5">Control category-specific filter pills, quick card logos (e.g. Car Makes), and options</p>
    </div>

    <div class="flex items-center gap-2">
        <select onchange="window.location.href='{{ route('admin.filters.index') }}?category_id=' + this.value" class="bg-slate-950 border border-slate-800 text-slate-300 text-xs rounded-xl px-3 py-2 font-medium">
            <option value="">All Categories</option>
            @foreach($categories as $c)
                <option value="{{ $c->id }}" {{ $categoryId == $c->id ? 'selected' : '' }}>
                    {{ $c->name }}
                </option>
            @endforeach
        </select>

        <button onclick="document.getElementById('addFilterModal').classList.remove('hidden')" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-3.5 py-2 rounded-xl transition shadow">
            + Add Filter
        </button>
    </div>
</div>

<div class="space-y-4">
    @forelse($filters as $filter)
        <div class="bg-slate-950 rounded-2xl border border-slate-800 p-4">
            <div class="flex items-center justify-between pb-3 border-b border-slate-800/80 mb-3">
                <div class="flex items-center gap-3">
                    <div class="w-9 h-9 rounded-xl bg-amber-950 text-amber-400 flex items-center justify-center text-sm border border-amber-800/50">
                        <i class="fa-solid fa-sliders"></i>
                    </div>
                    <div>
                        <div class="text-sm font-extrabold text-white flex items-center gap-2">
                            <span>{{ $filter->name }}</span>
                            <span class="text-slate-400 font-['Cairo']">({{ $filter->name_ar }})</span>
                            <span class="px-2 py-0.5 rounded bg-slate-900 text-blue-400 text-[10px] font-mono font-bold">{{ $filter->filter_key }}</span>
                            <span class="px-2 py-0.5 rounded bg-slate-800 text-amber-400 text-[10px] font-bold">{{ $filter->type }}</span>
                        </div>
                        <div class="text-[10px] text-slate-500 font-medium">Category: {{ $filter->category->name ?? 'Global' }}</div>
                    </div>
                </div>

                <div class="flex items-center gap-2">
                    <button onclick="openAddOptionModal({{ $filter->id }}, '{{ $filter->name }}')" class="px-2.5 py-1 text-[11px] font-bold rounded-lg bg-blue-600 hover:bg-blue-500 text-white">
                        + Add Option / Brand
                    </button>
                </div>
            </div>

            <!-- Options / Brands Grid -->
            <div>
                <span class="text-[10px] uppercase tracking-wider text-slate-400 font-bold block mb-2">Options & Quick Cards ({{ count($filter->options) }}):</span>
                <div class="flex flex-wrap gap-2">
                    @forelse($filter->options as $opt)
                        <div class="px-3 py-1.5 rounded-xl border border-slate-800 bg-slate-900 flex items-center gap-2 text-xs">
                            <span class="font-bold text-white">{{ $opt->label }}</span>
                            <span class="text-slate-500 font-['Cairo'] text-[11px]">({{ $opt->label_ar }})</span>
                            @if($opt->is_quick_card)
                                <span class="text-[9px] bg-amber-950 text-amber-400 px-1 py-0.5 rounded font-black">Visual Card</span>
                            @endif
                            <form action="{{ route('admin.filters.deleteOption', $opt->id) }}" method="POST" class="inline" onsubmit="return confirm('Delete option?')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="text-rose-500 hover:text-rose-400 text-[10px] font-bold ml-1">&times;</button>
                            </form>
                        </div>
                    @empty
                        <span class="text-xs text-slate-600">No options configured yet.</span>
                    @endforelse
                </div>
            </div>
        </div>
    @empty
        <div class="bg-slate-950 rounded-2xl border border-slate-800 p-8 text-center text-slate-500 text-xs">
            No dynamic filters found.
        </div>
    @endforelse
</div>

<!-- Add Filter Modal -->
<div id="addFilterModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
    <div class="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-5 shadow-2xl">
        <div class="flex items-center justify-between pb-3 border-b border-slate-800 mb-4">
            <h2 class="text-sm font-bold text-white">+ Add Dynamic Filter</h2>
            <button onclick="document.getElementById('addFilterModal').classList.add('hidden')" class="text-slate-400 hover:text-white">&times;</button>
        </div>

        <form action="{{ route('admin.filters.store') }}" method="POST" class="space-y-3 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 mb-1">Target Category</label>
                <select name="category_id" required class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                    @foreach($categories as $c)
                        <option value="{{ $c->id }}" {{ $categoryId == $c->id ? 'selected' : '' }}>{{ $c->name }}</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Filter Name (English)</label>
                <input type="text" name="name" required placeholder="e.g. Car Make" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Filter Name (Arabic)</label>
                <input type="text" name="name_ar" required placeholder="e.g. الشركة المصنعة" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div class="grid grid-cols-2 gap-2">
                <div>
                    <label class="block text-slate-400 mb-1">Filter Key</label>
                    <input type="text" name="filter_key" required placeholder="car_make" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white font-mono">
                </div>
                <div>
                    <label class="block text-slate-400 mb-1">Display Type</label>
                    <select name="type" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                        <option value="select">Dropdown Select</option>
                        <option value="pills">Pills / Chips</option>
                        <option value="brands_grid">Visual Brands Grid</option>
                        <option value="range">Range (Min/Max)</option>
                    </select>
                </div>
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Options (One per line: Label|Label_AR|Value|is_quick_card)</label>
                <textarea name="options_text" rows="3" placeholder="Toyota|تويوتا|toyota|1&#10;Ford|فورد|ford|1" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2 text-white font-mono text-[11px]"></textarea>
            </div>

            <div class="pt-3">
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-2.5 rounded-xl shadow">Save Filter</button>
            </div>
        </form>
    </div>
</div>

<!-- Add Option Modal -->
<div id="addOptModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
    <div class="bg-slate-900 border border-slate-800 rounded-2xl max-w-sm w-full p-5 shadow-2xl">
        <div class="flex items-center justify-between pb-3 border-b border-slate-800 mb-4">
            <h2 class="text-sm font-bold text-white">+ Add Option to <span id="optFilterName"></span></h2>
            <button onclick="document.getElementById('addOptModal').classList.add('hidden')" class="text-slate-400 hover:text-white">&times;</button>
        </div>

        <form id="addOptionForm" method="POST" class="space-y-3 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 mb-1">Label (English)</label>
                <input type="text" name="label" required placeholder="e.g. Porsche" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Label (Arabic)</label>
                <input type="text" name="label_ar" required placeholder="e.g. بورشه" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Value Key</label>
                <input type="text" name="value" required placeholder="porsche" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white font-mono">
            </div>
            <div class="flex items-center gap-2">
                <input type="checkbox" name="is_quick_card" value="1" id="qcCheck" class="rounded">
                <label for="qcCheck" class="text-slate-300">Show in Visual Quick Cards Grid (with logo)</label>
            </div>

            <div class="pt-3">
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-2.5 rounded-xl shadow">Add Option</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddOptionModal(filterId, filterName) {
        document.getElementById('optFilterName').textContent = filterName;
        document.getElementById('addOptionForm').action = `/admin/filters/${filterId}/options`;
        document.getElementById('addOptModal').classList.remove('hidden');
    }
</script>
@endsection
