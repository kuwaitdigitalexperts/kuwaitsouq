@extends('layouts.admin')

@section('title', 'Manage Ads & Moderation')

@section('content')
<div class="mb-6 flex flex-wrap items-center justify-between gap-3">
    <div>
        <h1 class="text-xl font-black text-white">Ads Moderation & Rocket Boost</h1>
        <p class="text-xs text-slate-400 mt-0.5">Manage live listings, boost priority, and moderate content</p>
    </div>

    <!-- Filter by Status -->
    <div class="flex items-center gap-2">
        <a href="{{ route('admin.ads.index') }}" class="px-3 py-1.5 rounded-xl text-xs font-bold {{ !$status ? 'bg-blue-600 text-white' : 'bg-slate-950 text-slate-400' }}">All</a>
        <a href="{{ route('admin.ads.index', ['status' => 'active']) }}" class="px-3 py-1.5 rounded-xl text-xs font-bold {{ $status === 'active' ? 'bg-blue-600 text-white' : 'bg-slate-950 text-slate-400' }}">Active</a>
        <a href="{{ route('admin.ads.index', ['status' => 'pending']) }}" class="px-3 py-1.5 rounded-xl text-xs font-bold {{ $status === 'pending' ? 'bg-blue-600 text-white' : 'bg-slate-950 text-slate-400' }}">Pending</a>
    </div>
</div>

<div class="bg-slate-950 rounded-2xl border border-slate-800 overflow-hidden">
    <table class="w-full text-left text-xs text-slate-300">
        <thead class="bg-slate-900 text-slate-400 font-bold uppercase text-[10px] tracking-wider border-b border-slate-800">
            <tr>
                <th class="p-3.5">Listing</th>
                <th class="p-3.5">Price</th>
                <th class="p-3.5">Location</th>
                <th class="p-3.5">Seller / User</th>
                <th class="p-3.5">Boost Status</th>
                <th class="p-3.5">Status</th>
                <th class="p-3.5">Actions</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-800/60 font-medium">
            @forelse($ads as $ad)
                <tr class="hover:bg-slate-900/60 transition">
                    <td class="p-3.5 flex items-center gap-3">
                        <img src="{{ $ad->media->first()?->file_path ?? 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=200' }}" class="w-12 h-12 rounded-xl object-cover border border-slate-800">
                        <div>
                            <a href="{{ route('ads.show', $ad->id) }}" target="_blank" class="font-bold text-white text-sm hover:underline line-clamp-1">
                                {{ $ad->title }}
                            </a>
                            <div class="text-[10px] text-slate-400 font-['Cairo'] line-clamp-1">{{ $ad->title_ar }}</div>
                            <div class="text-[10px] text-slate-500 mt-0.5">ID: #{{ $ad->id }} • {{ $ad->time_ago }}</div>
                        </div>
                    </td>
                    <td class="p-3.5">
                        <span class="font-black text-rose-400 text-sm">{{ $ad->formatted_price }}</span>
                    </td>
                    <td class="p-3.5">
                        <div class="text-xs font-bold text-white">{{ $ad->country->flag ?? '' }} {{ $ad->city->name ?? 'City' }}</div>
                        <div class="text-[10px] text-slate-400">{{ $ad->neighborhood_name ?? '' }}</div>
                    </td>
                    <td class="p-3.5">
                        <div class="text-xs font-bold text-slate-200">{{ $ad->user->name ?? 'User' }}</div>
                        <div class="text-[10px] text-slate-400">{{ $ad->phone }}</div>
                    </td>
                    <td class="p-3.5">
                        <form action="{{ route('admin.ads.toggleBoost', $ad->id) }}" method="POST">
                            @csrf
                            <button type="submit" class="px-2.5 py-1 rounded-lg text-[10px] font-black tracking-wide transition {{ $ad->is_boosted ? 'bg-rose-950 text-rose-300 border border-rose-700/60 shadow-xs' : 'bg-slate-900 text-slate-500 hover:text-white' }}">
                                🚀 {{ $ad->is_boosted ? 'Active Boost' : 'Boost Off' }}
                            </button>
                        </form>
                    </td>
                    <td class="p-3.5">
                        <span class="px-2 py-0.5 rounded text-[10px] font-bold {{ $ad->status === 'active' ? 'bg-emerald-950 text-emerald-400' : 'bg-amber-950 text-amber-400' }}">
                            {{ ucfirst($ad->status) }}
                        </span>
                    </td>
                    <td class="p-3.5 flex items-center gap-2">
                        <a href="{{ route('ads.show', $ad->id) }}" target="_blank" class="p-1.5 rounded-lg bg-slate-900 hover:bg-slate-800 text-blue-400 font-bold" title="View">
                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                        </a>

                        <form action="{{ route('admin.ads.destroy', $ad->id) }}" method="POST" onsubmit="return confirm('Delete this listing permanently?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="p-1.5 rounded-lg bg-slate-900 hover:bg-rose-950 text-rose-400 font-bold" title="Delete">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" class="p-6 text-center text-slate-500">No listings found.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>

@if($ads->hasPages())
    <div class="mt-4">
        {{ $ads->links() }}
    </div>
@endif
@endsection
