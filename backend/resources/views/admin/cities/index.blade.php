@extends('layouts.admin')

@section('title', 'Manage Cities & Neighborhoods')

@section('content')
<div class="mb-6 flex flex-wrap items-center justify-between gap-3">
    <div>
        <h1 class="text-xl font-black text-white">Cities & Neighborhoods</h1>
        <p class="text-xs text-slate-400 mt-0.5">Manage cities in each Gulf country</p>
    </div>

    <!-- Country Selector Filter -->
    <div class="flex items-center gap-2">
        <select onchange="window.location.href='{{ route('admin.cities.index') }}?country_id=' + this.value" class="bg-slate-950 border border-slate-800 text-slate-300 text-xs rounded-xl px-3 py-2 font-medium">
            <option value="">All Countries</option>
            @foreach($countries as $c)
                <option value="{{ $c->id }}" {{ $countryId == $c->id ? 'selected' : '' }}>
                    {{ $c->flag }} {{ $c->name }}
                </option>
            @endforeach
        </select>

        <button onclick="document.getElementById('addCityModal').classList.remove('hidden')" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-3.5 py-2 rounded-xl transition shadow">
            + Add City
        </button>
    </div>
</div>

<div class="bg-slate-950 rounded-2xl border border-slate-800 overflow-hidden">
    <table class="w-full text-left text-xs text-slate-300">
        <thead class="bg-slate-900 text-slate-400 font-bold uppercase text-[10px] tracking-wider border-b border-slate-800">
            <tr>
                <th class="p-3.5">City Name (EN)</th>
                <th class="p-3.5">City Name (AR)</th>
                <th class="p-3.5">Country</th>
                <th class="p-3.5">Neighborhoods / Districts</th>
                <th class="p-3.5">Total Ads</th>
                <th class="p-3.5">Actions</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-800/60 font-medium">
            @forelse($cities as $city)
                <tr class="hover:bg-slate-900/60 transition">
                    <td class="p-3.5 font-bold text-white text-sm">{{ $city->name }}</td>
                    <td class="p-3.5 text-slate-300 font-['Cairo'] text-sm">{{ $city->name_ar }}</td>
                    <td class="p-3.5">
                        <span class="inline-flex items-center gap-1.5 px-2 py-0.5 rounded bg-slate-900 text-slate-300 font-bold">
                            <span>{{ $city->country->flag ?? '' }}</span>
                            <span>{{ $city->country->name ?? '' }}</span>
                        </span>
                    </td>
                    <td class="p-3.5">
                        <div class="flex flex-wrap gap-1 max-w-xs">
                            @forelse($city->neighborhoods as $nh)
                                <span class="px-2 py-0.5 rounded bg-slate-900 text-slate-400 text-[10px]">{{ $nh->name }}</span>
                            @empty
                                <span class="text-slate-600 text-[10px]">No areas</span>
                            @endforelse
                        </div>
                    </td>
                    <td class="p-3.5 font-bold text-white">{{ $city->ads_count }}</td>
                    <td class="p-3.5">
                        <form action="{{ route('admin.cities.destroy', $city->id) }}" method="POST" onsubmit="return confirm('Delete this city?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-rose-400 hover:text-rose-300 font-semibold text-[11px]">Delete</button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" class="p-6 text-center text-slate-500">No cities found.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>

@if($cities->hasPages())
    <div class="mt-4">
        {{ $cities->links() }}
    </div>
@endif

<!-- Add City Modal -->
<div id="addCityModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
    <div class="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-5 shadow-2xl">
        <div class="flex items-center justify-between pb-3 border-b border-slate-800 mb-4">
            <h2 class="text-sm font-bold text-white">+ Add New City</h2>
            <button onclick="document.getElementById('addCityModal').classList.add('hidden')" class="text-slate-400 hover:text-white">&times;</button>
        </div>

        <form action="{{ route('admin.cities.store') }}" method="POST" class="space-y-3 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 mb-1">Country</label>
                <select name="country_id" required class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                    @foreach($countries as $c)
                        <option value="{{ $c->id }}" {{ $countryId == $c->id ? 'selected' : '' }}>
                            {{ $c->flag }} {{ $c->name }}
                        </option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="block text-slate-400 mb-1">City Name (English)</label>
                <input type="text" name="name" required placeholder="e.g. Al Ahmadi" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">City Name (Arabic)</label>
                <input type="text" name="name_ar" required placeholder="e.g. الأحمدي" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>

            <div class="pt-3">
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-2.5 rounded-xl shadow">Save City</button>
            </div>
        </form>
    </div>
</div>
@endsection
