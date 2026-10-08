@extends('layouts.admin')

@section('title', 'Manage Gulf Countries')

@section('content')
<div class="mb-6 flex items-center justify-between">
    <div>
        <h1 class="text-xl font-black text-white">Gulf Countries</h1>
        <p class="text-xs text-slate-400 mt-0.5">Manage countries, currencies, telephone codes, and active status</p>
    </div>

    <!-- Quick Add Modal Toggle / Form -->
    <button onclick="document.getElementById('addCountryModal').classList.remove('hidden')" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-3.5 py-2 rounded-xl transition shadow">
        + Add Country
    </button>
</div>

<div class="bg-slate-950 rounded-2xl border border-slate-800 overflow-hidden">
    <table class="w-full text-left text-xs text-slate-300">
        <thead class="bg-slate-900 text-slate-400 font-bold uppercase text-[10px] tracking-wider border-b border-slate-800">
            <tr>
                <th class="p-3.5">Country</th>
                <th class="p-3.5">ISO Code</th>
                <th class="p-3.5">Phone Prefix</th>
                <th class="p-3.5">Currency</th>
                <th class="p-3.5">Cities Count</th>
                <th class="p-3.5">Ads Count</th>
                <th class="p-3.5">Status</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-800/60 font-medium">
            @foreach($countries as $c)
                <tr class="hover:bg-slate-900/60 transition">
                    <td class="p-3.5 flex items-center gap-3">
                        <span class="text-2xl">{{ $c->flag }}</span>
                        <div>
                            <div class="font-bold text-white text-sm">{{ $c->name }}</div>
                            <div class="text-[11px] text-slate-400 font-['Cairo']">{{ $c->name_ar }}</div>
                        </div>
                    </td>
                    <td class="p-3.5 font-mono text-slate-300">{{ $c->code }}</td>
                    <td class="p-3.5 font-mono text-emerald-400 font-bold">{{ $c->phone_code }}</td>
                    <td class="p-3.5">
                        <span class="px-2 py-1 rounded bg-slate-800 font-bold text-amber-300">{{ $c->currency }} ({{ $c->currency_ar }})</span>
                    </td>
                    <td class="p-3.5">
                        <a href="{{ route('admin.cities.index', ['country_id' => $c->id]) }}" class="text-blue-400 hover:underline font-bold">
                            {{ $c->cities_count }} Cities &rarr;
                        </a>
                    </td>
                    <td class="p-3.5 font-bold text-white">{{ $c->ads_count }}</td>
                    <td class="p-3.5">
                        <span class="px-2 py-0.5 rounded text-[10px] font-bold {{ $c->is_active ? 'bg-emerald-950 text-emerald-400' : 'bg-rose-950 text-rose-400' }}">
                            {{ $c->is_active ? 'Active' : 'Disabled' }}
                        </span>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>

<!-- Add Country Modal -->
<div id="addCountryModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
    <div class="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-5 shadow-2xl">
        <div class="flex items-center justify-between pb-3 border-b border-slate-800 mb-4">
            <h2 class="text-sm font-bold text-white">+ Add New Country</h2>
            <button onclick="document.getElementById('addCountryModal').classList.add('hidden')" class="text-slate-400 hover:text-white">&times;</button>
        </div>

        <form action="{{ route('admin.countries.store') }}" method="POST" class="space-y-3 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 mb-1">Country Name (English)</label>
                <input type="text" name="name" required placeholder="e.g. Jordan" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div>
                <label class="block text-slate-400 mb-1">Country Name (Arabic)</label>
                <input type="text" name="name_ar" required placeholder="e.g. الأردن" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>
            <div class="grid grid-cols-2 gap-2">
                <div>
                    <label class="block text-slate-400 mb-1">ISO Code</label>
                    <input type="text" name="code" required placeholder="JO" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white uppercase">
                </div>
                <div>
                    <label class="block text-slate-400 mb-1">Phone Prefix</label>
                    <input type="text" name="phone_code" required placeholder="+962" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                </div>
            </div>
            <div class="grid grid-cols-3 gap-2">
                <div>
                    <label class="block text-slate-400 mb-1">Currency Code</label>
                    <input type="text" name="currency" required placeholder="JOD" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                </div>
                <div>
                    <label class="block text-slate-400 mb-1">Currency (AR)</label>
                    <input type="text" name="currency_ar" required placeholder="د.أ" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                </div>
                <div>
                    <label class="block text-slate-400 mb-1">Flag Emoji</label>
                    <input type="text" name="flag" required placeholder="🇯🇴" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
                </div>
            </div>

            <div class="pt-3">
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-2.5 rounded-xl shadow">Save Country</button>
            </div>
        </form>
    </div>
</div>
@endsection
