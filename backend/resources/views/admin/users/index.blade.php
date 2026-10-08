@extends('layouts.admin')

@section('title', 'Manage Users & Sellers')

@section('content')
<div class="mb-6 flex items-center justify-between">
    <div>
        <h1 class="text-xl font-black text-white">Users & Sellers</h1>
        <p class="text-xs text-slate-400 mt-0.5">Manage user credentials, verified badges, quotas, and wallet credits</p>
    </div>
</div>

<div class="bg-slate-950 rounded-2xl border border-slate-800 overflow-hidden">
    <table class="w-full text-left text-xs text-slate-300">
        <thead class="bg-slate-900 text-slate-400 font-bold uppercase text-[10px] tracking-wider border-b border-slate-800">
            <tr>
                <th class="p-3.5">User / Business</th>
                <th class="p-3.5">Contact Details</th>
                <th class="p-3.5">Member Type & Quota</th>
                <th class="p-3.5">Wallet Credits</th>
                <th class="p-3.5">Verified Badge</th>
                <th class="p-3.5">Role</th>
                <th class="p-3.5">Add Credits</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-800/60 font-medium">
            @foreach($users as $u)
                <tr class="hover:bg-slate-900/60 transition">
                    <td class="p-3.5">
                        <div class="flex items-center gap-2">
                            <span class="font-bold text-white text-sm">{{ $u->name }}</span>
                            @if($u->is_verified)
                                <span class="text-blue-400 text-xs" title="Verified Badge"><i class="fa-solid fa-circle-check"></i></span>
                            @endif
                        </div>
                        <div class="text-[10px] text-slate-500 font-mono mt-0.5">ID: {{ $u->member_id_number ?? $u->id }} • {{ $u->ads_count }} Ads</div>
                    </td>
                    <td class="p-3.5">
                        <div class="font-mono text-emerald-400 font-bold">{{ $u->phone_code }} {{ $u->phone }}</div>
                        <div class="text-[10px] text-slate-400">{{ $u->email }}</div>
                    </td>
                    <td class="p-3.5">
                        <span class="px-2 py-0.5 rounded bg-slate-900 text-amber-300 font-bold text-[11px]">{{ $u->member_type }}</span>
                        <div class="text-[10px] text-slate-400 mt-0.5">Quota: {{ $u->live_listings_limit }} live ads</div>
                    </td>
                    <td class="p-3.5">
                        <div class="flex items-center gap-2 text-[11px]">
                            <span class="px-2 py-0.5 bg-blue-950 text-blue-300 rounded font-bold">{{ $u->listing_credits }} Listing</span>
                            <span class="px-2 py-0.5 bg-rose-950 text-rose-300 rounded font-bold">{{ $u->vas_credits }} VAS</span>
                        </div>
                    </td>
                    <td class="p-3.5">
                        <form action="{{ route('admin.users.toggleVerified', $u->id) }}" method="POST">
                            @csrf
                            <button type="submit" class="px-2.5 py-1 rounded-lg text-[10px] font-black transition {{ $u->is_verified ? 'bg-blue-950 text-blue-300 border border-blue-700/60' : 'bg-slate-900 text-slate-500 hover:text-white' }}">
                                {{ $u->is_verified ? '✓ Verified' : '+ Verify' }}
                            </button>
                        </form>
                    </td>
                    <td class="p-3.5">
                        <form action="{{ route('admin.users.toggleAdmin', $u->id) }}" method="POST">
                            @csrf
                            <button type="submit" class="px-2 py-0.5 rounded text-[10px] font-bold {{ $u->is_admin ? 'bg-purple-950 text-purple-300' : 'bg-slate-900 text-slate-400' }}">
                                {{ $u->is_admin ? 'Admin' : 'Member' }}
                            </button>
                        </form>
                    </td>
                    <td class="p-3.5">
                        <form action="{{ route('admin.users.addCredits', $u->id) }}" method="POST" class="flex items-center gap-1">
                            @csrf
                            <input type="hidden" name="listing_credits" value="5">
                            <input type="hidden" name="vas_credits" value="2">
                            <button type="submit" class="px-2 py-1 bg-slate-900 hover:bg-slate-800 text-emerald-400 rounded text-[10px] font-bold">
                                +5 Credits
                            </button>
                        </form>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>

@if($users->hasPages())
    <div class="mt-4">
        {{ $users->links() }}
    </div>
@endif
@endsection
