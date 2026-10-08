@extends('layouts.app')

@section('title', $category->display_name . ' (' . $totalCount . ')')

@section('content')
<!-- Mobile Top Blue Bar (Visible on mobile only, hidden on desktop) -->
<div class="md:hidden bg-blue-600 text-white px-3 pt-3.5 pb-3 sticky top-7 z-30 shadow-md">
    <div class="flex items-center gap-2.5">
        <!-- Back Button -->
        <a href="{{ $category->parent ? route('category.show', $category->parent->slug) : route('home') }}" class="text-white hover:text-blue-100 p-1.5 transition">
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-arrow-right' : 'fa-arrow-left' }} text-lg"></i>
        </a>

        <!-- Search in Category Input -->
        <form action="{{ route('category.show', $category->slug) }}" method="GET" class="flex-1 relative">
            <div class="relative flex items-center">
                <i class="fa-solid fa-magnifying-glass absolute {{ ($isRtl ?? true) ? 'right-3' : 'left-3' }} text-slate-400 text-sm"></i>
                <input type="text" name="q" value="{{ request('q') }}" placeholder="{{ ($isRtl ?? true) ? 'ابحث في ' . $category->display_name : 'Search in ' . $category->display_name }}"
                    class="w-full bg-white text-slate-800 {{ ($isRtl ?? true) ? 'pr-9 pl-3' : 'pl-9 pr-3' }} py-2 rounded-xl text-xs placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-300 shadow-inner">
            </div>
        </form>

        @if($isSubcategory)
            <!-- Save Search Heart Icon -->
            <button type="button" onclick="document.getElementById('saveSearchSection')?.scrollIntoView({behavior: 'smooth'})" class="text-white hover:text-blue-100 p-1.5 transition">
                <i class="fa-solid fa-heart-circle-bolt text-lg"></i>
            </button>
        @endif

        <!-- Share Icon -->
        <button type="button" onclick="navigator.share ? navigator.share({title: '{{ $category->display_name }}', url: window.location.href}) : alert('Link copied!')" class="text-white hover:text-blue-100 p-1.5 transition">
            <i class="fa-solid fa-share-nodes text-lg"></i>
        </button>

        <!-- Notification Bell -->
        <div class="relative">
            <button type="button" class="text-white hover:text-blue-100 p-1.5 transition">
                <i class="fa-solid fa-bell text-lg"></i>
            </button>
            <span class="absolute 0 top-0.5 {{ ($isRtl ?? true) ? 'left-0.5' : 'right-0.5' }} bg-red-500 text-white text-[10px] font-bold rounded-full w-4 h-4 flex items-center justify-center border-2 border-blue-600">1</span>
        </div>
    </div>
</div>

<!-- Category Title & City Bar -->
<div class="bg-white px-4 py-3 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="flex items-center justify-between mb-2 flex-wrap gap-2">
        <h1 class="text-lg md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
            <span>{{ $category->display_name }}</span>
            <span class="text-xs md:text-sm text-slate-400 font-semibold">({{ number_format($totalCount) }})</span>
        </h1>

        <!-- City Dropdown & Actions -->
        <div class="flex items-center gap-2">
            <!-- City Dropdown -->
            <div class="relative">
                <select onchange="window.location.href='{{ route('category.show', $category->slug) }}?city_id=' + this.value" class="appearance-none bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-semibold py-2 {{ ($isRtl ?? true) ? 'pr-7 pl-3' : 'pl-7 pr-3' }} rounded-xl border-0 cursor-pointer focus:ring-0">
                    <option value="">{{ ($isRtl ?? true) ? 'كل المدن' : 'All Cities' }}</option>
                    @foreach($cities as $city)
                        <option value="{{ $city->id }}" {{ request('city_id') == $city->id ? 'selected' : '' }}>
                            {{ $city->display_name }}
                        </option>
                    @endforeach
                </select>
                <i class="fa-solid fa-location-dot absolute {{ ($isRtl ?? true) ? 'right-2.5' : 'left-2.5' }} top-3 text-slate-500 text-xs pointer-events-none"></i>
            </div>

            <!-- Sort Toggle -->
            <a href="{{ route('category.show', array_merge(['slug' => $category->slug], request()->all(), ['sort' => request('sort') === 'price_asc' ? 'price_desc' : 'price_asc'])) }}" class="p-2 text-slate-600 hover:text-slate-900 bg-slate-100 rounded-xl text-xs" title="Sort">
                <i class="fa-solid fa-arrow-down-up-across-line"></i>
            </a>
        </div>
    </div>

    <!-- Dynamic Filter Dropdown Pills (Horizontal chips) -->
    <div id="filtersContainer" class="flex items-center gap-2 overflow-x-auto hide-scrollbar pt-2 pb-1">
        @foreach($filters as $filter)
            <div class="relative flex-shrink-0">
                <select onchange="window.location.href='{{ route('category.show', $category->slug) }}?{{ $filter->filter_key }}=' + this.value"
                    class="appearance-none bg-slate-50 border {{ request($filter->filter_key) ? 'border-blue-500 bg-blue-50 text-blue-700 font-bold' : 'border-slate-200 text-slate-700' }} text-xs py-1.5 {{ ($isRtl ?? true) ? 'pr-3 pl-7' : 'pl-3 pr-7' }} rounded-xl cursor-pointer">
                    <option value="">{{ $filter->display_name }}</option>
                    @foreach($filter->options as $opt)
                        <option value="{{ $opt->value }}" {{ request($filter->filter_key) == $opt->value ? 'selected' : '' }}>
                            {{ $opt->display_label }}
                        </option>
                    @endforeach
                </select>
                <i class="fa-solid fa-chevron-down absolute {{ ($isRtl ?? true) ? 'left-2.5' : 'right-2.5' }} top-2.5 text-[10px] text-slate-400 pointer-events-none"></i>
            </div>
        @endforeach

        @if(request()->hasAny(['car_make', 'condition', 'model', 'transmission', 'city_id']))
            <a href="{{ route('category.show', $category->slug) }}" class="text-[11px] text-rose-500 font-bold whitespace-nowrap px-2 py-1 bg-rose-50 rounded-lg">
                {{ ($isRtl ?? true) ? 'إعادة ضبط' : 'Clear' }}
            </a>
        @endif
    </div>
</div>

<!-- If Main Category: Subcategories Grid (2 cols on mobile, 4 on desktop) -->
@if(!$isSubcategory && $subcategories->isNotEmpty())
<div class="bg-white p-4 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
        @foreach($subcategories as $sub)
            <a href="{{ route('category.show', $sub->slug) }}" class="flex flex-col sm:flex-row items-center gap-3 p-3 bg-slate-50 hover:bg-blue-50 border border-slate-200/80 hover:border-blue-300 rounded-2xl transition group text-center sm:text-start">
                <div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center text-blue-600 text-lg border border-slate-100 group-hover:scale-105 transition flex-shrink-0">
                    @if(Str::contains($sub->slug, 'cars-for-sale'))
                        <i class="fa-solid fa-car"></i>
                    @elseif(Str::contains($sub->slug, 'accessories'))
                        <i class="fa-solid fa-car-burst"></i>
                    @elseif(Str::contains($sub->slug, 'rent'))
                        <i class="fa-solid fa-key"></i>
                    @elseif(Str::contains($sub->slug, 'heavy'))
                        <i class="fa-solid fa-truck-monster"></i>
                    @elseif(Str::contains($sub->slug, 'spare'))
                        <i class="fa-solid fa-gear"></i>
                    @elseif(Str::contains($sub->slug, 'plate'))
                        <i class="fa-solid fa-id-card"></i>
                    @else
                        <i class="fa-solid fa-motorcycle"></i>
                    @endif
                </div>
                <div class="flex-1 min-w-0">
                    <span class="text-xs font-bold text-slate-800 block truncate group-hover:text-blue-600">{{ $sub->display_name }}</span>
                    <span class="text-[10px] text-slate-400 block">{{ $sub->ads_count ?? $sub->ads()->count() }} {{ ($isRtl ?? true) ? 'إعلان' : 'ads' }}</span>
                </div>
            </a>
        @endforeach
    </div>
</div>
@endif

<!-- If Subcategory: Save Search Card -->
@if($isSubcategory)
<div id="saveSearchSection" class="bg-white px-4 py-3 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="p-3 bg-slate-50 border border-slate-200 rounded-2xl flex items-center justify-between shadow-xs">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-rose-50 text-rose-500 flex items-center justify-center text-lg">
                <i class="fa-solid fa-magnifying-glass-chart"></i>
            </div>
            <div>
                <div class="text-xs md:text-sm font-bold text-slate-900">{{ ($isRtl ?? true) ? 'حفظ البحث' : 'Save Search' }}</div>
                <div class="text-[11px] text-slate-500">{{ ($isRtl ?? true) ? 'تنبيهي عند إضافة إعلانات جديدة في ' . $category->display_name : 'Alert me of new listings added' }}</div>
            </div>
        </div>

        <!-- Toggle Switch -->
        <label class="relative inline-flex items-center cursor-pointer">
            <input type="checkbox" checked onchange="alert('Search alert preferences updated!')" class="sr-only peer">
            <div class="w-11 h-6 bg-slate-300 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
        </label>
    </div>
</div>

<!-- Visual Brand / Make Grid -->
@if($brandOptions->isNotEmpty())
<div class="bg-white p-4 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="flex items-center justify-between mb-3">
        <h3 class="text-xs font-extrabold text-slate-900">{{ ($isRtl ?? true) ? 'تصفية سريعة بالماركة / الشركة' : 'Filter by Brand' }}</h3>
        <!-- Brand search bar inside grid -->
        <div class="relative w-48 sm:w-64">
            <i class="fa-solid fa-magnifying-glass absolute {{ ($isRtl ?? true) ? 'right-3' : 'left-3' }} top-2 text-slate-400 text-xs"></i>
            <input type="text" id="brandFilterInput" onkeyup="filterBrands(this.value)" placeholder="{{ ($isRtl ?? true) ? 'بحث عن ماركة...' : 'filter by car make...' }}"
                class="w-full bg-slate-100 text-slate-800 {{ ($isRtl ?? true) ? 'pr-8 pl-3' : 'pl-8 pr-3' }} py-1.5 rounded-xl text-xs placeholder-slate-400 border-0 focus:ring-1 focus:ring-blue-400">
        </div>
    </div>

    <!-- Brands Grid with Logo Buttons -->
    <div id="brandsGrid" class="grid grid-cols-4 sm:grid-cols-6 lg:grid-cols-11 gap-2">
        @foreach($brandOptions as $b)
            <a href="{{ route('category.show', array_merge(['slug' => $category->slug], ['car_make' => $b->value])) }}"
                data-name="{{ strtolower($b->label . ' ' . $b->label_ar) }}"
                class="brand-card p-2 rounded-xl border {{ request('car_make') === $b->value ? 'border-blue-600 bg-blue-50 text-blue-900 font-bold' : 'border-slate-200/90 bg-white hover:border-slate-300' }} flex flex-col items-center justify-center text-center transition shadow-2xs group">
                <div class="w-8 h-8 flex items-center justify-center mb-1 text-slate-700 group-hover:scale-110 transition-transform">
                    @if($b->value === 'toyota')
                        <i class="fa-solid fa-car-side text-lg text-red-600"></i>
                    @elseif($b->value === 'ford')
                        <i class="fa-solid fa-truck-pickup text-lg text-blue-700"></i>
                    @elseif($b->value === 'mercedes')
                        <i class="fa-regular fa-compass text-lg text-slate-800"></i>
                    @elseif($b->value === 'bmw')
                        <i class="fa-solid fa-circle-notch text-lg text-blue-500"></i>
                    @else
                        <i class="fa-solid fa-car text-base text-slate-600"></i>
                    @endif
                </div>
                <span class="text-[10px] font-bold truncate max-w-full">{{ $b->display_label }}</span>
            </a>
        @endforeach
    </div>
</div>
@endif
@endif

<!-- Sponsored Ad Banner (Kayishha banner) -->
<div class="mb-4">
    <div class="bg-gradient-to-r from-amber-400 via-amber-300 to-yellow-400 sm:rounded-2xl p-4 flex items-center justify-between text-slate-900 shadow-xs border border-amber-200">
        <div class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-xl bg-white/80 backdrop-blur-sm flex items-center justify-center text-slate-900 text-2xl shadow-inner">
                <i class="fa-solid fa-car-on"></i>
            </div>
            <div>
                <div class="text-sm font-black uppercase tracking-wider">kayishha • كيشها</div>
                <div class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'بيع سيارتك فوراً وبأفضل سعر نقداً بدون تعب' : 'Sell your car instantly with cash offer' }}</div>
            </div>
        </div>
        <button class="bg-slate-900 text-white font-bold text-xs px-4 py-2 rounded-xl shadow-sm hover:bg-slate-800 transition">
            {{ ($isRtl ?? true) ? 'ابدأ الآن' : 'Start Now' }}
        </button>
    </div>
</div>

<!-- Ad Listings Grid (1 col on mobile, 2 on tablet, 3 on desktop) -->
<div class="mb-6">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-5">
        @forelse($ads as $ad)
            <div class="bg-white rounded-2xl border border-slate-200/90 overflow-hidden shadow-sm hover:shadow-md transition flex flex-col justify-between">
                <div>
                    <!-- Header: Time ago -->
                    <div class="px-4 pt-3 pb-2 text-[11px] text-slate-400 font-medium flex items-center justify-between">
                        <span>{{ $ad->time_ago }}</span>
                        @if($ad->condition)
                            <span class="px-2 py-0.5 bg-slate-100 text-slate-600 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                {{ $ad->condition === 'used' ? (($isRtl ?? true) ? 'مستعمل' : 'Used') : (($isRtl ?? true) ? 'جديد' : 'New') }}
                            </span>
                        @endif
                    </div>

                    <!-- Media Container -->
                    <div class="relative bg-slate-100 aspect-[16/10] overflow-hidden">
                        <a href="{{ route('ads.show', $ad->id) }}">
                            <img src="{{ $ad->media->first()?->file_path ?? 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800' }}" alt="{{ $ad->display_title }}" class="w-full h-full object-cover">
                        </a>

                        <!-- Media Badges: Photos & Video Counts -->
                        <div class="absolute bottom-2.5 {{ ($isRtl ?? true) ? 'right-2.5' : 'left-2.5' }} flex items-center gap-1.5">
                            <span class="bg-black/70 backdrop-blur-sm text-white text-[11px] font-bold px-2 py-1 rounded-lg flex items-center gap-1">
                                <i class="fa-solid fa-camera text-[10px]"></i>
                                <span>{{ max($ad->photos_count, 1) }}</span>
                            </span>
                            @if($ad->videos_count > 0)
                                <span class="bg-black/70 backdrop-blur-sm text-white text-[11px] font-bold px-2 py-1 rounded-lg flex items-center gap-1">
                                <i class="fa-solid fa-video text-[10px]"></i>
                                <span>{{ $ad->videos_count }}</span>
                            </span>
                            @endif
                        </div>

                        <!-- Rocket Boost Badge -->
                        @if($ad->is_boosted)
                            <div class="absolute bottom-2.5 {{ ($isRtl ?? true) ? 'left-2.5' : 'right-2.5' }}">
                                <span class="bg-white text-rose-600 w-8 h-8 rounded-full shadow-md flex items-center justify-center text-sm border border-rose-100 animate-pulse" title="Boosted Listing">
                                    🚀
                                </span>
                            </div>
                        @endif
                    </div>

                    <!-- Ad Information Body -->
                    <div class="p-4">
                        <!-- Price Highlight in Red (Bold) -->
                        <div class="text-xl font-black text-rose-600 mb-1">
                            {{ $ad->formatted_price }}
                        </div>

                        <!-- Ad Title -->
                        <a href="{{ route('ads.show', $ad->id) }}" class="block">
                            <h2 class="text-base font-bold text-slate-900 leading-snug hover:text-blue-600 transition mb-2 line-clamp-1">
                                {{ $ad->display_title }}
                            </h2>
                        </a>

                        <!-- Location & Category Breadcrumb -->
                        <div class="flex items-center gap-2 text-xs text-slate-500 mb-2 flex-wrap">
                            <span class="flex items-center gap-1 text-slate-600 font-medium">
                                <i class="fa-solid fa-location-dot text-rose-500 text-[11px]"></i>
                                <span>{{ $ad->display_location }}</span>
                            </span>
                            <span class="text-slate-300">•</span>
                            <span class="bg-slate-100 text-slate-600 px-2 py-0.5 rounded text-[11px]">
                                {{ $ad->subCategory?->display_name ?? $ad->category?->display_name }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Action CTA Buttons -->
                <div class="p-4 pt-0">
                    <div class="flex items-center gap-2 pt-2 border-t border-slate-100">
                        <!-- Call Button -->
                        <a href="tel:{{ $ad->phone }}" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs sm:text-sm shadow-sm transition active:scale-95">
                            <i class="fa-solid fa-phone text-xs"></i>
                            <span>{{ $ad->phone ?? '05048809XX' }}</span>
                        </a>

                        <!-- WhatsApp / Chat Button -->
                        <a href="{{ route('chats.show', $ad->user_id ?? 1) }}" class="flex-1 bg-white hover:bg-slate-50 border border-slate-200 text-slate-800 font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs sm:text-sm shadow-sm transition active:scale-95">
                            <i class="fa-brands fa-whatsapp text-emerald-500 text-base"></i>
                            <span>{{ ($isRtl ?? true) ? 'محادثة' : 'Chat' }}</span>
                        </a>

                        <!-- Favorite Button -->
                        <button type="button" onclick="toggleFavorite({{ $ad->id }}, this)" class="w-10 h-10 bg-white hover:bg-rose-50 border border-slate-200 text-slate-400 hover:text-rose-500 rounded-xl flex items-center justify-center transition active:scale-90 shadow-sm flex-shrink-0">
                            <i class="fa-regular fa-heart text-base"></i>
                        </button>
                    </div>
                </div>
            </div>
        @empty
            <div class="col-span-full bg-white rounded-2xl p-10 text-center border border-slate-200">
                <i class="fa-solid fa-filter text-4xl text-slate-300 mb-3"></i>
                <h3 class="font-bold text-slate-700 text-base mb-1">{{ ($isRtl ?? true) ? 'لا توجد نتائج مطابقة لهذه التصفية' : 'No listings matching these filters' }}</h3>
                <p class="text-xs text-slate-400 mb-4">{{ ($isRtl ?? true) ? 'جرب تغيير خيارات التصفية أو الدولة' : 'Try clearing your filters or changing location' }}</p>
                <a href="{{ route('category.show', $category->slug) }}" class="inline-block bg-blue-600 text-white font-bold text-xs px-5 py-2.5 rounded-xl shadow">
                    {{ ($isRtl ?? true) ? 'عرض كل إعلانات القسم' : 'View all in this category' }}
                </a>
            </div>
        @endforelse
    </div>

    <!-- Pagination -->
    @if($ads->hasPages())
        <div class="pt-6 pb-4">
            {{ $ads->links() }}
        </div>
    @endif
</div>

@push('scripts')
<script>
    function filterBrands(query) {
        query = query.toLowerCase().trim();
        document.querySelectorAll('.brand-card').forEach(card => {
            const name = card.getAttribute('data-name');
            if (name.includes(query)) {
                card.classList.remove('hidden');
            } else {
                card.classList.add('hidden');
            }
        });
    }

    function toggleFavorite(adId, btn) {
        fetch(`/ads/${adId}/favorite`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                'Accept': 'application/json'
            }
        })
        .then(res => res.json())
        .then(data => {
            if (data.require_auth) {
                window.location.href = '{{ route('login') }}';
                return;
            }
            const icon = btn.querySelector('i');
            if (data.favorited) {
                icon.classList.remove('fa-regular', 'text-slate-400');
                icon.classList.add('fa-solid', 'text-rose-500');
                btn.classList.add('border-rose-200', 'bg-rose-50');
            } else {
                icon.classList.remove('fa-solid', 'text-rose-500');
                icon.classList.add('fa-regular', 'text-slate-400');
                btn.classList.remove('border-rose-200', 'bg-rose-50');
            }
        });
    }
</script>
@endpush
@endsection
