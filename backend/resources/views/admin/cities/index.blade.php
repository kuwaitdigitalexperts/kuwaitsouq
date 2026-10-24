@extends('layouts.admin')

@section('title', 'Kuwait Locations & Areas (مناطق الكويت)')

@section('content')
<div class="mb-6 flex flex-wrap items-center justify-between gap-3">
    <div>
        <h1 class="text-xl font-black text-white flex items-center gap-2">
            <span>🇰🇼</span>
            <span>Kuwait Locations & Governorates (مناطق الكويت)</span>
        </h1>
        <p class="text-xs text-slate-400 mt-0.5">Manage all active areas & governorates across Kuwait for the Mobile App & Website</p>
    </div>

    <button onclick="document.getElementById('addCityModal').classList.remove('hidden')" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-4 py-2.5 rounded-xl transition shadow flex items-center gap-2">
        <i class="fa-solid fa-plus"></i>
        <span>Add New Area / إضافة منطقة</span>
    </button>
</div>

@if(session('success'))
    <div class="mb-4 p-3 bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 rounded-xl text-xs flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check"></i>
            <span>{{ session('success') }}</span>
        </div>
        <button type="button" onclick="this.parentElement.remove()" class="text-emerald-400 hover:text-white">&times;</button>
    </div>
@endif

<div class="mb-4 flex items-center justify-between gap-3">
    <div class="relative flex-1 max-w-sm">
        <i class="fa-solid fa-magnifying-glass absolute left-3 top-2.5 text-slate-500 text-xs"></i>
        <input type="text" id="areaSearchInput" onkeyup="filterAreas()" placeholder="Search areas (e.g. Salmiya, حولي, الشويخ)..." class="w-full bg-slate-950 border border-slate-800 rounded-xl pl-8 pr-3 py-2 text-xs text-white placeholder-slate-500 outline-none focus:border-blue-500 transition">
    </div>
    <div class="text-xs text-slate-400 font-medium">
        Total: <span class="font-bold text-white">{{ $cities->total() }}</span> Kuwait Areas
    </div>
</div>

<div class="bg-slate-950 rounded-2xl border border-slate-800 overflow-hidden shadow-sm">
    <table class="w-full text-left text-xs text-slate-300">
        <thead class="bg-slate-900 text-slate-400 font-bold uppercase text-[10px] tracking-wider border-b border-slate-800">
            <tr>
                <th class="p-3.5"># Pos</th>
                <th class="p-3.5">Area Name (EN)</th>
                <th class="p-3.5 text-right font-['Cairo']">اسم المنطقة (عربي)</th>
                <th class="p-3.5">Total Ads</th>
                <th class="p-3.5">Status</th>
                <th class="p-3.5 text-right">Actions</th>
            </tr>
        </thead>
        <tbody id="areasTableBody" class="divide-y divide-slate-800/60 font-medium">
            @forelse($cities as $city)
                <tr class="hover:bg-slate-900/60 transition">
                    <td class="p-3.5 text-slate-500 text-xs font-mono font-bold">{{ $city->pos }}</td>
                    <td class="p-3.5 font-bold text-white text-sm">{{ $city->name }}</td>
                    <td class="p-3.5 text-right font-['Cairo'] font-bold text-slate-200 text-sm">{{ $city->name_ar }}</td>
                    <td class="p-3.5 font-bold text-blue-400">{{ $city->ads_count }} ads</td>
                    <td class="p-3.5">
                        @if($city->is_active)
                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">Active</span>
                        @else
                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-800 text-slate-500">Disabled</span>
                        @endif
                    </td>
                    <td class="p-3.5 text-right space-x-2">
                        <button onclick="openEditModal({{ $city->id }}, '{{ addslashes($city->name) }}', '{{ addslashes($city->name_ar) }}', {{ $city->pos }}, {{ $city->is_active ? 1 : 0 }})" class="text-blue-400 hover:text-blue-300 font-semibold text-xs transition">
                            Edit
                        </button>
                        <form action="{{ route('admin.cities.destroy', $city->id) }}" method="POST" class="inline" onsubmit="return confirm('Delete {{ addslashes($city->name) }}?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-rose-400 hover:text-rose-300 font-semibold text-xs transition ml-2">Delete</button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" class="p-8 text-center text-slate-500">No Kuwait locations added yet. Click "+ Add New Area" to get started.</td>
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
            <h2 class="text-sm font-bold text-white flex items-center gap-2">
                <span>🇰🇼</span>
                <span>+ Add Kuwait Area / إضافة منطقة</span>
            </h2>
            <button onclick="document.getElementById('addCityModal').classList.add('hidden')" class="text-slate-400 hover:text-white text-lg">&times;</button>
        </div>

        <form action="{{ route('admin.cities.store') }}" method="POST" class="space-y-3.5 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 mb-1 font-semibold">Area Name in English (e.g. Shuwaikh)</label>
                <input type="text" name="name" required placeholder="e.g. Shuwaikh, Salmiya, Hawally" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white placeholder-slate-600 focus:border-blue-500 outline-none">
            </div>

            <div>
                <label class="block text-slate-400 mb-1 font-semibold font-['Cairo']">اسم المنطقة بالعربي (مثال: الشويخ)</label>
                <input type="text" name="name_ar" required placeholder="مثال: الشويخ، السالمية، حولي" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white placeholder-slate-600 font-['Cairo'] focus:border-blue-500 outline-none">
            </div>

            <div>
                <label class="block text-slate-400 mb-1 font-semibold">Display Order (الترتيب)</label>
                <input type="number" name="pos" value="1" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>

            <div class="flex items-center gap-2 pt-2">
                <input type="checkbox" name="is_active" value="1" id="is_active_chk" checked class="rounded border-slate-800 text-blue-600">
                <label for="is_active_chk" class="text-slate-300 font-medium">Active (مفعل في التطبيق والموقع)</label>
            </div>

            <div class="flex justify-end gap-2 pt-3 border-t border-slate-800 mt-4">
                <button type="button" onclick="document.getElementById('addCityModal').classList.add('hidden')" class="px-3.5 py-2 text-slate-400 hover:text-white">Cancel</button>
                <button type="submit" class="bg-blue-600 hover:bg-blue-500 text-white font-bold px-4 py-2 rounded-xl transition">Save Location</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit City Modal -->
<div id="editCityModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
    <div class="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-5 shadow-2xl">
        <div class="flex items-center justify-between pb-3 border-b border-slate-800 mb-4">
            <h2 class="text-sm font-bold text-white flex items-center gap-2">
                <span>✏️</span>
                <span>Edit Kuwait Area / تعديل المنطقة</span>
            </h2>
            <button onclick="document.getElementById('editCityModal').classList.add('hidden')" class="text-slate-400 hover:text-white text-lg">&times;</button>
        </div>

        <form id="editCityForm" method="POST" class="space-y-3.5 text-xs">
            @csrf
            @method('PUT')
            <div>
                <label class="block text-slate-400 mb-1 font-semibold">Area Name in English</label>
                <input type="text" name="name" id="edit_name" required class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white focus:border-blue-500 outline-none">
            </div>

            <div>
                <label class="block text-slate-400 mb-1 font-semibold font-['Cairo']">اسم المنطقة بالعربي</label>
                <input type="text" name="name_ar" id="edit_name_ar" required class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white font-['Cairo'] focus:border-blue-500 outline-none">
            </div>

            <div>
                <label class="block text-slate-400 mb-1 font-semibold">Display Order (الترتيب)</label>
                <input type="number" name="pos" id="edit_pos" class="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white">
            </div>

            <div class="flex items-center gap-2 pt-2">
                <input type="checkbox" name="is_active" value="1" id="edit_is_active" class="rounded border-slate-800 text-blue-600">
                <label for="edit_is_active" class="text-slate-300 font-medium">Active (مفعل في التطبيق والموقع)</label>
            </div>

            <div class="flex justify-end gap-2 pt-3 border-t border-slate-800 mt-4">
                <button type="button" onclick="document.getElementById('editCityModal').classList.add('hidden')" class="px-3.5 py-2 text-slate-400 hover:text-white">Cancel</button>
                <button type="submit" class="bg-blue-600 hover:bg-blue-500 text-white font-bold px-4 py-2 rounded-xl transition">Update Location</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, name, nameAr, pos, isActive) {
        document.getElementById('editCityForm').action = '/admin/cities/' + id;
        document.getElementById('edit_name').value = name;
        document.getElementById('edit_name_ar').value = nameAr;
        document.getElementById('edit_pos').value = pos;
        document.getElementById('edit_is_active').checked = isActive === 1;
        document.getElementById('editCityModal').classList.remove('hidden');
    }

    function filterAreas() {
        const query = document.getElementById('areaSearchInput').value.toLowerCase().trim();
        const rows = document.querySelectorAll('#areasTableBody tr');
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    }
</script>
@endsection
