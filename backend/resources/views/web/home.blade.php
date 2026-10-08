@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'السوق المفتوح الأول في الكويت والخليج' : 'Gulf Marketplace')

@section('content')
<!-- Mobile Top Blue Bar (Visible on mobile only, hidden on desktop) -->
<div class="md:hidden bg-blue-600 text-white px-4 pt-3.5 pb-3 shadow-sm sticky top-7 z-30">
    <div class="flex items-center gap-3">
        <!-- Search Input -->
        <form action="{{ route('home') }}" method="GET" class="flex-1 relative">
            <div class="relative flex items-center">
                <i class="fa-solid fa-magnifying-glass absolute {{ ($isRtl ?? true) ? 'right-3' : 'left-3' }} text-slate-400 text-sm"></i>
                <input type="text" name="q" value="{{ request('q') }}" placeholder="{{ ($isRtl ?? true) ? 'ابحث في الكويت سوق...' : 'Search in KuwaitSouq...' }}"
                    class="w-full bg-white text-slate-800 {{ ($isRtl ?? true) ? 'pr-9 pl-3' : 'pl-9 pr-3' }} py-2 rounded-xl text-xs placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-300 shadow-inner">
            </div>
        </form>

        <!-- Share Icon -->
        <button type="button" onclick="navigator.share ? navigator.share({title: 'KuwaitSouq', url: window.location.href}) : alert('Share link copied!')" class="text-white hover:text-blue-100 p-1.5 transition">
            <i class="fa-solid fa-share-nodes text-lg"></i>
        </button>

        <!-- Notification Bell with Unread Badge -->
        <div class="relative">
            <button type="button" class="text-white hover:text-blue-100 p-1.5 transition">
                <i class="fa-solid fa-bell text-lg"></i>
            </button>
            <span class="absolute 0 top-0.5 {{ ($isRtl ?? true) ? 'left-0.5' : 'right-0.5' }} bg-red-500 text-white text-[10px] font-bold rounded-full w-4 h-4 flex items-center justify-center border-2 border-blue-600">1</span>
        </div>
    </div>
</div>

<!-- Category Title & City Filter Bar -->
<div class="bg-white px-4 py-3 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="flex items-center justify-between flex-wrap gap-3">
        <h1 class="text-lg md:text-xl font-extrabold text-slate-900 flex items-center gap-2">
            <span>{{ ($isRtl ?? true) ? 'جميع الإعلانات في ' . ($currentCountry->display_name ?? 'الخليج') : 'All Listings in ' . ($currentCountry->display_name ?? 'Gulf') }}</span>
            <span class="text-xs text-slate-400 font-normal">({{ $ads->total() }})</span>
        </h1>

        <!-- City Dropdown & Filter Actions -->
        <div class="flex items-center gap-2">
            <!-- City Dropdown -->
            <div class="relative">
                <select onchange="window.location.href='{{ route('home') }}?city_id=' + this.value" class="appearance-none bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-semibold py-2 {{ ($isRtl ?? true) ? 'pr-7 pl-3' : 'pl-7 pr-3' }} rounded-xl border-0 cursor-pointer focus:ring-0">
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
            <a href="{{ route('home', array_merge(request()->all(), ['sort' => request('sort') === 'price_asc' ? 'price_desc' : 'price_asc'])) }}" class="p-2 text-slate-600 hover:text-slate-900 bg-slate-100 rounded-xl text-xs" title="Sort">
                <i class="fa-solid fa-arrow-down-up-across-line"></i>
            </a>

            <!-- Country Switcher Button -->
            <button type="button" onclick="openCountryModal()" class="p-2 text-slate-600 hover:text-slate-900 bg-slate-100 rounded-xl text-xs flex items-center gap-1" title="Select Country">
                <span>{{ $currentCountry->flag ?? '🇰🇼' }}</span>
                <i class="fa-solid fa-sliders text-xs"></i>
            </button>
        </div>
    </div>
</div>

<!-- Main Categories Grid (Responsive: 2 cols on mobile, 3 on tablet, 6 on desktop) -->
<div class="bg-white p-4 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="flex items-center justify-between mb-3">
        <h2 class="text-sm font-extrabold text-slate-900">{{ ($isRtl ?? true) ? 'تصفح حسب الأقسام الرئيسية' : 'Browse by Categories' }}</h2>
    </div>
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
        @foreach($categories as $cat)
            <a href="{{ route('category.show', $cat->slug) }}" class="flex flex-col sm:flex-row items-center gap-2.5 p-3 bg-slate-50 hover:bg-blue-50 border border-slate-200/80 hover:border-blue-300 rounded-2xl transition group text-center sm:text-start">
                <div class="w-10 h-10 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center text-lg group-hover:scale-110 transition-transform flex-shrink-0">
                    @if($cat->slug === 'autos')
                        <i class="fa-solid fa-car"></i>
                    @elseif($cat->slug === 'real-estate')
                        <i class="fa-solid fa-building"></i>
                    @elseif($cat->slug === 'electronics')
                        <i class="fa-solid fa-mobile-screen"></i>
                    @elseif($cat->slug === 'jobs')
                        <i class="fa-solid fa-briefcase"></i>
                    @elseif($cat->slug === 'services')
                        <i class="fa-solid fa-screwdriver-wrench"></i>
                    @else
                        <i class="fa-solid fa-box"></i>
                    @endif
                </div>
                <div class="flex-1 min-w-0">
                    <span class="text-xs font-bold text-slate-800 truncate block group-hover:text-blue-600">{{ $cat->display_name }}</span>
                    <span class="text-[10px] text-slate-400 block">{{ $cat->ads_count }} {{ ($isRtl ?? true) ? 'إعلان' : 'ads' }}</span>
                </div>
            </a>
        @endforeach
    </div>
</div>

<!-- Seller Stories Carousel -->
<div class="bg-white px-4 py-3.5 sm:rounded-2xl border border-slate-200/80 mb-4 shadow-xs">
    <div class="flex items-center gap-4 overflow-x-auto hide-scrollbar pb-1">
        <!-- Add Story Button -->
        <a href="{{ route('ads.create') }}" class="flex flex-col items-center flex-shrink-0 group">
            <div class="w-16 h-16 rounded-full border-2 border-dashed border-amber-500 p-0.5 flex items-center justify-center relative bg-amber-50 group-hover:scale-105 transition">
                <div class="w-full h-full rounded-full bg-slate-200 overflow-hidden flex items-center justify-center">
                    <i class="fa-solid fa-camera text-slate-400 text-lg"></i>
                </div>
                <span class="absolute bottom-0 right-0 bg-blue-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs border-2 border-white font-bold">+</span>
            </div>
            <span class="text-[10px] font-medium text-slate-600 mt-1 truncate max-w-[64px]">{{ ($isRtl ?? true) ? 'قصتك' : 'Add Story' }}</span>
        </a>

        <!-- Active Seller Stories -->
        @foreach($stories as $story)
            <div class="flex flex-col items-center flex-shrink-0 cursor-pointer">
                <div class="w-16 h-16 rounded-full p-0.5 flex items-center justify-center relative hover:scale-105 transition
                    {{ $story->ring_color === 'green' ? 'bg-gradient-to-tr from-emerald-500 to-teal-400' : ($story->ring_color === 'blue' ? 'bg-gradient-to-tr from-blue-600 to-cyan-400' : 'bg-gradient-to-tr from-amber-500 to-orange-400') }}">
                    <div class="w-full h-full rounded-full bg-white p-0.5">
                        <img src="{{ $story->media_path }}" alt="{{ $story->user->name ?? 'Story' }}" class="w-full h-full rounded-full object-cover">
                    </div>
                </div>
                <span class="text-[10px] font-medium text-slate-700 mt-1 truncate max-w-[64px] text-center">
                    {{ Str::limit($story->user->name ?? 'Seller', 9) }}
                </span>
            </div>
        @endforeach
    </div>
</div>

<!-- Listings Feed (Responsive: 1 col on mobile, 2 on tablet, 3 on desktop) -->
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

                    <!-- Media Carousel / Preview Container -->
                    <div class="relative bg-slate-100 aspect-[16/10] overflow-hidden">
                        <a href="{{ route('ads.show', $ad->id) }}">
                            <img src="{{ $ad->media->first()?->file_path ?? 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800' }}" alt="{{ $ad->display_title }}" class="w-full h-full object-cover">
                        </a>

                        <!-- Media Badges: Photos & Video Counts (Bottom Left) -->
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

                        <!-- Rocket Boost Badge (Bottom Right) -->
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

                        <!-- Ad Title in Arabic & English -->
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

                <!-- Action CTA Buttons (Call, Chat, Favorite) -->
                <div class="p-4 pt-0">
                    <div class="flex items-center gap-2 pt-2 border-t border-slate-100">
                        <!-- Call Button (Blue Primary) -->
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
                <i class="fa-solid fa-box-open text-4xl text-slate-300 mb-3"></i>
                <h3 class="font-bold text-slate-700 text-base mb-1">{{ ($isRtl ?? true) ? 'لا توجد إعلانات حالياً في هذه الدولة' : 'No listings found in this country' }}</h3>
                <p class="text-xs text-slate-400 mb-4">{{ ($isRtl ?? true) ? 'كن أول من يضيف إعلاناً جديداً' : 'Be the first to post a listing' }}</p>
                <a href="{{ route('ads.create') }}" class="inline-block bg-blue-600 text-white font-bold text-xs px-5 py-2.5 rounded-xl shadow">
                    {{ ($isRtl ?? true) ? 'أضف إعلانك الآن' : 'Post an Ad Now' }}
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
