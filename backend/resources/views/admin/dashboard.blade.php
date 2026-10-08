@extends('layouts.admin')

@section('title', 'Platform Dashboard')

@section('content')
<div class="mb-6 flex items-center justify-between">
    <div>
        <h1 class="text-xl font-black text-white">KuwaitSouq Dashboard</h1>
        <p class="text-xs text-slate-400 mt-0.5">Overview of Gulf countries, listings, filters, and sellers</p>
    </div>

    <div class="flex items-center gap-2">
        <a href="{{ route('admin.ads.index') }}" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-3.5 py-2 rounded-xl transition shadow">
            Manage Ads
        </a>
    </div>
</div>

<!-- Metrics Overview Cards -->
<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
    <div class="bg-slate-950 p-4 rounded-2xl border border-slate-800">
        <div class="flex items-center justify-between text-slate-400 text-xs mb-2">
            <span>Total Listings</span>
            <i class="fa-solid fa-newspaper text-blue-500"></i>
        </div>
        <div class="text-2xl font-black text-white">{{ $stats['total_ads'] }}</div>
        <div class="text-[11px] text-emerald-400 mt-1">{{ $stats['active_ads'] }} Active</div>
    </div>

    <div class="bg-slate-950 p-4 rounded-2xl border border-slate-800">
        <div class="flex items-center justify-between text-slate-400 text-xs mb-2">
            <span>Rocket Boosted</span>
            <i class="fa-solid fa-rocket text-rose-500"></i>
        </div>
        <div class="text-2xl font-black text-rose-400">{{ $stats['boosted_ads'] }}</div>
        <div class="text-[11px] text-slate-400 mt-1">High visibility ads</div>
    </div>

    <div class="bg-slate-950 p-4 rounded-2xl border border-slate-800">
        <div class="flex items-center justify-between text-slate-400 text-xs mb-2">
            <span>Users & Sellers</span>
            <i class="fa-solid fa-users text-amber-500"></i>
        </div>
        <div class="text-2xl font-black text-white">{{ $stats['total_users'] }}</div>
        <div class="text-[11px] text-amber-400 mt-1">{{ $stats['verified_sellers'] }} Verified Badges</div>
    </div>

    <div class="bg-slate-950 p-4 rounded-2xl border border-slate-800">
        <div class="flex items-center justify-between text-slate-400 text-xs mb-2">
            <span>Gulf Countries</span>
            <i class="fa-solid fa-earth-americas text-emerald-500"></i>
        </div>
        <div class="text-2xl font-black text-white">{{ $stats['total_countries'] }}</div>
        <div class="text-[11px] text-slate-400 mt-1">{{ $stats['total_cities'] }} Active Cities</div>
    </div>
</div>

<!-- Gulf Countries Breakdown -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
    <div class="bg-slate-950 p-5 rounded-2xl border border-slate-800">
        <div class="flex items-center justify-between mb-4">
            <h2 class="text-sm font-extrabold text-white flex items-center gap-2">
                <i class="fa-solid fa-globe text-blue-500"></i>
                <span>Gulf Coverage & Breakdown</span>
            </h2>
            <a href="{{ route('admin.countries.index') }}" class="text-xs text-blue-400 hover:underline">Manage All &rarr;</a>
        </div>

        <div class="space-y-3">
            @foreach($countryStats as $cs)
                <div class="flex items-center justify-between p-3 rounded-xl bg-slate-900 border border-slate-800/80">
                    <div class="flex items-center gap-3">
                        <span class="text-2xl">{{ $cs->flag }}</span>
                        <div>
                            <div class="text-xs font-bold text-white">{{ $cs->name }} ({{ $cs->name_ar }})</div>
                            <div class="text-[10px] text-slate-400">{{ $cs->currency }} • {{ $cs->phone_code }}</div>
                        </div>
                    </div>
                    <div class="flex items-center gap-3 text-xs">
                        <span class="px-2 py-1 rounded bg-slate-800 text-slate-300 font-medium">{{ $cs->cities_count }} Cities</span>
                        <span class="px-2 py-1 rounded bg-blue-950 text-blue-400 font-bold">{{ $cs->ads_count }} Ads</span>
                    </div>
                </div>
            @endforeach
        </div>
    </div>

    <!-- Recent Listings for Moderation -->
    <div class="bg-slate-950 p-5 rounded-2xl border border-slate-800">
        <div class="flex items-center justify-between mb-4">
            <h2 class="text-sm font-extrabold text-white flex items-center gap-2">
                <i class="fa-solid fa-newspaper text-emerald-500"></i>
                <span>Recent Ads</span>
            </h2>
            <a href="{{ route('admin.ads.index') }}" class="text-xs text-blue-400 hover:underline">All Ads &rarr;</a>
        </div>

        <div class="space-y-3">
            @forelse($recentAds as $rad)
                <div class="flex items-center justify-between p-3 rounded-xl bg-slate-900 border border-slate-800/80">
                    <div class="min-w-0 flex-1">
                        <div class="flex items-center gap-2">
                            <span class="text-xs font-bold text-white truncate">{{ $rad->title }}</span>
                            @if($rad->is_boosted)
                                <span class="text-[10px] bg-rose-950 text-rose-300 px-1.5 py-0.5 rounded font-black">🚀 Boost</span>
                            @endif
                        </div>
                        <div class="text-[10px] text-slate-400 mt-0.5">
                            {{ $rad->country->flag ?? '' }} {{ $rad->city->name ?? '' }} • <span class="text-rose-400 font-bold">{{ $rad->formatted_price }}</span> • By {{ $rad->user->name ?? 'User' }}
                        </div>
                    </div>
                    <div class="flex items-center gap-2">
                        <form action="{{ route('admin.ads.toggleBoost', $rad->id) }}" method="POST">
                            @csrf
                            <button type="submit" class="px-2 py-1 text-[10px] font-bold rounded bg-slate-800 hover:bg-slate-700 text-slate-200">
                                {{ $rad->is_boosted ? 'Unboost' : '🚀 Boost' }}
                            </button>
                        </form>
                    </div>
                </div>
            @empty
                <div class="text-center py-6 text-xs text-slate-500">No ads posted yet.</div>
            @endforelse
        </div>
    </div>
</div>
@endsection
