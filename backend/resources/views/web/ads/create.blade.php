@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'أضف إعلانك الجديد' : 'Post New Listing')

@section('content')
<div class="bg-blue-600 text-white px-4 pt-4 pb-3 flex items-center justify-between sticky top-7 z-30 shadow-md">
    <div class="flex items-center gap-3">
        <a href="javascript:history.back()" class="text-white hover:text-blue-100 p-1">
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-arrow-right' : 'fa-arrow-left' }} text-lg"></i>
        </a>
        <h1 class="text-base font-black">{{ ($isRtl ?? true) ? 'أضف إعلان جديد' : 'Post New Listing' }}</h1>
    </div>
</div>

<div class="p-4">
    <form action="{{ route('ads.store') }}" method="POST" class="space-y-4">
        @csrf

        <!-- Country & City Selection -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs space-y-3">
            <h2 class="text-xs font-black text-slate-800 flex items-center gap-2">
                <i class="fa-solid fa-location-dot text-rose-500"></i>
                <span>{{ ($isRtl ?? true) ? 'الموقع الجغرافي (الدولة والمدينة)' : 'Location' }}</span>
            </h2>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'الدولة' : 'Country' }}</label>
                    <select name="country_id" id="countrySelect" onchange="loadCities(this.value)" required class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-2.5 text-xs font-semibold text-slate-800 focus:ring-2 focus:ring-blue-400">
                        @foreach($countries as $c)
                            <option value="{{ $c->id }}" {{ ($currentCountry->id ?? null) === $c->id ? 'selected' : '' }}>
                                {{ $c->flag }} {{ $c->display_name }} ({{ $c->display_currency }})
                            </option>
                        @endforeach
                    </select>
                </div>

                <div>
                    <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'المدينة' : 'City' }}</label>
                    <select name="city_id" id="citySelect" required class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-2.5 text-xs font-semibold text-slate-800 focus:ring-2 focus:ring-blue-400">
                        <!-- Populated by JS -->
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'الحي / المنطقة' : 'Neighborhood' }}</label>
                <input type="text" name="neighborhood_name" placeholder="{{ ($isRtl ?? true) ? 'مثال: المنسية، السالمية، الشويخ' : 'e.g. Al Munsiyah' }}"
                    class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400">
            </div>
        </div>

        <!-- Category & Subcategory -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs space-y-3">
            <h2 class="text-xs font-black text-slate-800 flex items-center gap-2">
                <i class="fa-solid fa-layer-group text-blue-600"></i>
                <span>{{ ($isRtl ?? true) ? 'القسم والتصنيف' : 'Category & Subcategory' }}</span>
            </h2>

            <div>
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'القسم الرئيسي' : 'Main Category' }}</label>
                <select name="category_id" id="categorySelect" onchange="updateSubcategories(this)" required class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-2.5 text-xs font-semibold text-slate-800 focus:ring-2 focus:ring-blue-400">
                    <option value="">{{ ($isRtl ?? true) ? '-- اختر القسم --' : '-- Select Category --' }}</option>
                    @foreach($categories as $cat)
                        <option value="{{ $cat->id }}" data-subs='@json($cat->subcategories)'>
                            {{ $cat->display_name }}
                        </option>
                    @endforeach
                </select>
            </div>

            <div id="subCategoryGroup" class="hidden">
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'القسم الفرعي' : 'Subcategory' }}</label>
                <select name="sub_category_id" id="subCategorySelect" class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-2.5 text-xs font-semibold text-slate-800 focus:ring-2 focus:ring-blue-400">
                    <!-- Populated dynamically -->
                </select>
            </div>

            <div>
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'الحالة' : 'Condition' }}</label>
                <div class="grid grid-cols-2 gap-3">
                    <label class="flex items-center gap-2 p-2.5 rounded-xl border border-slate-200 cursor-pointer hover:bg-blue-50">
                        <input type="radio" name="condition" value="used" checked class="text-blue-600">
                        <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'مستعمل' : 'Used' }}</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-xl border border-slate-200 cursor-pointer hover:bg-blue-50">
                        <input type="radio" name="condition" value="new" class="text-blue-600">
                        <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'جديد' : 'New' }}</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Ad Details -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs space-y-3">
            <h2 class="text-xs font-black text-slate-800 flex items-center gap-2">
                <i class="fa-solid fa-pen text-amber-500"></i>
                <span>{{ ($isRtl ?? true) ? 'تفاصيل الإعلان' : 'Listing Details' }}</span>
            </h2>

            <div>
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'عنوان الإعلان' : 'Title' }} *</label>
                <input type="text" name="title" required placeholder="{{ ($isRtl ?? true) ? 'مثال: ميني جولف سكوتر رباعي' : 'e.g. Mini Golf 4-Wheel Scooter' }}"
                    class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400">
            </div>

            <div>
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'السعر' : 'Price' }} *</label>
                <div class="relative">
                    <input type="number" step="0.01" name="price" required placeholder="3800"
                        class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs font-black text-slate-800 focus:ring-2 focus:ring-blue-400">
                    <span id="currencyBadge" class="absolute {{ ($isRtl ?? true) ? 'left-3' : 'right-3' }} top-2 text-xs font-black text-rose-600">{{ $currentCountry->display_currency ?? 'SAR' }}</span>
                </div>
            </div>

            <div>
                <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'تفاصيل الوصف' : 'Description' }} *</label>
                <textarea name="description" rows="4" required placeholder="{{ ($isRtl ?? true) ? 'اكتب تفاصيل ومواصفات المعروض للبيع بالتفصيل...' : 'Enter listing details...' }}"
                    class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400"></textarea>
            </div>
        </div>

        <!-- Photos -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs space-y-3">
            <h2 class="text-xs font-black text-slate-800 flex items-center gap-2">
                <i class="fa-solid fa-camera text-blue-600"></i>
                <span>{{ ($isRtl ?? true) ? 'الصور' : 'Photos' }}</span>
            </h2>

            <div class="space-y-2">
                <input type="text" name="photos[]" value="https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800"
                    placeholder="Photo URL 1 (Cover)" class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-700">
                <input type="text" name="photos[]" value="https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800"
                    placeholder="Photo URL 2" class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-700">
            </div>
        </div>

        <!-- Contact Information -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs space-y-3">
            <h2 class="text-xs font-black text-slate-800 flex items-center gap-2">
                <i class="fa-solid fa-phone text-emerald-500"></i>
                <span>{{ ($isRtl ?? true) ? 'معلومات الاتصال' : 'Contact Information' }}</span>
            </h2>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'رقم الهاتف' : 'Phone' }} *</label>
                    <input type="text" name="phone" value="{{ $user->phone ?? '0504880922' }}" required
                        class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs font-bold text-slate-800">
                </div>
                <div>
                    <label class="block text-[11px] font-bold text-slate-600 mb-1">{{ ($isRtl ?? true) ? 'رقم الواتساب' : 'WhatsApp' }}</label>
                    <input type="text" name="whatsapp" value="{{ $user->whatsapp ?? '+966504880922' }}"
                        class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs font-bold text-slate-800">
                </div>
            </div>
        </div>

        <!-- Rocket Boost Upgrade (Screenshot 3 & 4) -->
        <div class="bg-gradient-to-tr from-amber-50 to-orange-50 border border-amber-300 rounded-2xl p-4 shadow-xs">
            <label class="flex items-center justify-between cursor-pointer">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-white shadow-xs flex items-center justify-center text-rose-500 text-xl border border-amber-200">
                        🚀
                    </div>
                    <div>
                        <div class="text-xs font-black text-slate-900">{{ ($isRtl ?? true) ? 'تمييز الإعلان (صاروخ الرفع 🚀)' : 'Rocket Boost Listing 🚀' }}</div>
                        <div class="text-[10px] text-slate-500">{{ ($isRtl ?? true) ? 'يظهر إعلانك في أعلى نتائج البحث ويجذب 5 أضعاف المشاهدات' : 'Get up to 5x more views' }}</div>
                    </div>
                </div>
                <input type="checkbox" name="is_boosted" value="1" checked class="w-5 h-5 text-amber-500 rounded focus:ring-0">
            </label>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-extrabold py-3.5 px-4 rounded-xl text-sm shadow-md transition active:scale-98">
            {{ ($isRtl ?? true) ? 'نشر الإعلان الآن' : 'Publish Listing' }}
        </button>
    </form>
</div>

@push('scripts')
<script>
    function loadCities(countryId) {
        fetch(`/api/countries/${countryId}/cities`)
            .then(res => res.json())
            .then(data => {
                const select = document.getElementById('citySelect');
                select.innerHTML = '';
                data.cities.forEach(c => {
                    const opt = document.createElement('option');
                    opt.value = c.id;
                    opt.textContent = c.display_name;
                    select.appendChild(opt);
                });
                document.getElementById('currencyBadge').textContent = data.country.currency;
            });
    }

    function updateSubcategories(select) {
        const selected = select.options[select.selectedIndex];
        const subsData = selected.getAttribute('data-subs');
        const subGroup = document.getElementById('subCategoryGroup');
        const subSelect = document.getElementById('subCategorySelect');

        if (subsData) {
            const subs = JSON.parse(subsData);
            if (subs.length > 0) {
                subSelect.innerHTML = '<option value="">-- {{ ($isRtl ?? true) ? "اختر القسم الفرعي" : "Select Subcategory" }} --</option>';
                subs.forEach(s => {
                    const opt = document.createElement('option');
                    opt.value = s.id;
                    opt.textContent = s.name_ar || s.name;
                    subSelect.appendChild(opt);
                });
                subGroup.classList.remove('hidden');
                return;
            }
        }
        subGroup.classList.add('hidden');
    }

    // Initial load
    const initialCountry = document.getElementById('countrySelect').value;
    if (initialCountry) {
        loadCities(initialCountry);
    }
</script>
@endpush
@endsection
