@extends('layouts.app')

@section('title', $ad->display_title)

@section('content')
<!-- Sticky Header on Scroll (Mobile / Compact) -->
<div id="stickyHeader" class="hidden md:hidden fixed top-7 left-0 right-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200 px-3 py-2 shadow-sm transition-all duration-300">
    <div class="flex items-center justify-between gap-2 mb-2">
        <div class="flex items-center gap-2 flex-1 min-w-0">
            <a href="javascript:history.back()" class="p-1.5 text-slate-700 hover:text-slate-900">
                <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-arrow-right' : 'fa-arrow-left' }} text-base"></i>
            </a>
            <div class="min-w-0 flex-1">
                <div class="text-xs font-black text-rose-600 truncate">{{ $ad->formatted_price }}</div>
                <div class="text-xs font-bold text-slate-800 truncate">{{ $ad->display_title }}</div>
            </div>
        </div>
        <div class="flex items-center gap-2">
            <button type="button" onclick="toggleFavorite({{ $ad->id }}, this)" class="text-slate-500 hover:text-rose-500 p-1.5">
                <i class="{{ $isFavorited ? 'fa-solid text-rose-500' : 'fa-regular' }} fa-heart text-lg"></i>
            </button>
            <button type="button" onclick="shareAd()" class="text-slate-500 hover:text-slate-900 p-1.5">
                <i class="fa-solid fa-arrow-up-from-bracket text-lg"></i>
            </button>
        </div>
    </div>
    <!-- Quick Call & Chat Mini Bar in Sticky Header -->
    <div class="flex items-center gap-2 pt-1 border-t border-slate-100">
        <a href="tel:{{ $ad->phone }}" class="flex-1 bg-blue-600 text-white font-bold py-1.5 rounded-lg text-xs flex items-center justify-center gap-1.5 shadow-xs">
            <i class="fa-solid fa-phone text-[10px]"></i>
            <span>{{ $ad->phone ?? '05048809XX' }}</span>
        </a>
        <a href="{{ route('chats.show', $ad->user_id ?? 1) }}" class="flex-1 bg-slate-50 border border-slate-200 text-slate-800 font-bold py-1.5 rounded-lg text-xs flex items-center justify-center gap-1.5">
            <i class="fa-brands fa-whatsapp text-emerald-500 text-sm"></i>
            <span>{{ ($isRtl ?? true) ? 'محادثة' : 'Chat' }}</span>
        </a>
    </div>
</div>

<!-- Desktop Breadcrumb -->
<div class="hidden md:flex items-center gap-2 text-xs text-slate-500 mb-4 px-1">
    <a href="{{ route('home') }}" class="hover:text-blue-600">{{ ($isRtl ?? true) ? 'الرئيسية' : 'Home' }}</a>
    <span>/</span>
    <a href="{{ route('category.show', $ad->category->slug) }}" class="hover:text-blue-600">{{ $ad->category->display_name }}</a>
    @if($ad->subCategory)
        <span>/</span>
        <a href="{{ route('category.show', $ad->subCategory->slug) }}" class="hover:text-blue-600">{{ $ad->subCategory->display_name }}</a>
    @endif
    <span>/</span>
    <span class="text-slate-800 font-bold truncate max-w-xs">{{ $ad->display_title }}</span>
</div>

<!-- Responsive Layout: 1 col on mobile, 2 columns on desktop (7/12 & 5/12) -->
<div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start mb-8">

    <!-- Left Column (Gallery + Description + Similar Ads) -->
    <div class="lg:col-span-7 space-y-4">
        <!-- Main Top Image Slider Container -->
        <div class="relative bg-black aspect-[4/3] sm:rounded-3xl overflow-hidden shadow-sm" id="galleryContainer">
            <!-- Back Button overlay (mobile only) -->
            <a href="javascript:history.back()" class="md:hidden absolute top-4 {{ ($isRtl ?? true) ? 'right-4' : 'left-4' }} z-20 w-10 h-10 rounded-full bg-white/80 backdrop-blur-md text-slate-800 flex items-center justify-center shadow-md hover:bg-white transition">
                <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-arrow-right' : 'fa-arrow-left' }} text-base"></i>
            </a>

            <!-- Slider Images -->
            <div id="sliderWrapper" class="flex h-full w-full transition-transform duration-300">
                @forelse($ad->media as $idx => $m)
                    <div class="min-w-full h-full relative flex items-center justify-center bg-slate-950">
                        @if($m->type === 'video')
                            <video src="{{ $m->file_path }}" controls class="max-h-full max-w-full object-contain"></video>
                        @else
                            <img src="{{ $m->file_path }}" alt="{{ $ad->display_title }}" class="w-full h-full object-cover">
                        @endif
                    </div>
                @empty
                    <div class="min-w-full h-full flex items-center justify-center bg-slate-900">
                        <img src="https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800" class="w-full h-full object-cover">
                    </div>
                @endforelse
            </div>

            <!-- Media Counters Overlay [📷 17] [📹 1] -->
            <div class="absolute bottom-3 {{ ($isRtl ?? true) ? 'right-3' : 'left-3' }} flex items-center gap-1.5 z-10">
                <span class="bg-black/75 backdrop-blur-sm text-white text-xs font-bold px-2.5 py-1 rounded-lg flex items-center gap-1.5 shadow">
                    <i class="fa-solid fa-camera text-[11px]"></i>
                    <span id="currentPhotoCount">{{ max($ad->photos_count, 1) }}</span>
                </span>
                @if($ad->videos_count > 0)
                    <span class="bg-black/75 backdrop-blur-sm text-white text-xs font-bold px-2.5 py-1 rounded-lg flex items-center gap-1.5 shadow">
                        <i class="fa-solid fa-video text-[11px]"></i>
                        <span>{{ $ad->videos_count }}</span>
                    </span>
                @endif
            </div>

            <!-- Pagination Dots Indicator -->
            <div class="absolute bottom-3 left-0 right-0 flex items-center justify-center gap-1.5 z-10 pointer-events-none">
                @for($i = 0; $i < min(max(count($ad->media), 1), 6); $i++)
                    <div class="w-2 h-2 rounded-full {{ $i === 0 ? 'bg-white scale-125' : 'bg-white/50' }} transition-all"></div>
                @endfor
            </div>

            <!-- Rocket Boost Badge -->
            @if($ad->is_boosted)
                <div class="absolute bottom-3 {{ ($isRtl ?? true) ? 'left-3' : 'right-3' }} z-10">
                    <span class="bg-white text-rose-600 w-10 h-10 rounded-full shadow-lg flex items-center justify-center text-lg border border-rose-100 animate-pulse">
                        🚀
                    </span>
                </div>
            @endif
        </div>

        <!-- Description Section -->
        <div class="bg-white p-5 sm:rounded-3xl border border-slate-200/80 shadow-xs">
            <h2 class="text-sm font-extrabold text-slate-900 mb-3">
                {{ ($isRtl ?? true) ? 'الوصف والتفاصيل' : 'Description' }}
            </h2>
            <div class="text-xs md:text-sm text-slate-700 leading-relaxed whitespace-pre-line bg-slate-50/70 p-4 rounded-2xl border border-slate-100">
                {{ $ad->display_description }}
            </div>
        </div>

        <!-- Similar Ads Section -->
        @if($similarAds->isNotEmpty())
        <div class="bg-white p-5 sm:rounded-3xl border border-slate-200/80 shadow-xs">
            <h2 class="text-sm font-extrabold text-slate-900 mb-3">
                {{ ($isRtl ?? true) ? 'إعلانات مشابهة قد تهمك' : 'Similar Listings' }}
            </h2>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                @foreach($similarAds as $sAd)
                    <a href="{{ route('ads.show', $sAd->id) }}" class="flex items-center gap-3 p-2.5 rounded-2xl hover:bg-slate-50 border border-slate-100 transition group">
                        <div class="w-16 h-16 rounded-xl bg-slate-100 overflow-hidden flex-shrink-0">
                            <img src="{{ $sAd->media->first()?->file_path ?? 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=300' }}" class="w-full h-full object-cover group-hover:scale-105 transition-transform">
                        </div>
                        <div class="flex-1 min-w-0 text-start">
                            <h3 class="text-xs font-bold text-slate-900 truncate mb-1">{{ $sAd->display_title }}</h3>
                            <div class="text-xs font-black text-rose-600 mb-1">{{ $sAd->formatted_price }}</div>
                            <div class="text-[10px] text-slate-400 flex items-center gap-1">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>{{ $sAd->city?->display_name ?? 'City' }}</span>
                            </div>
                        </div>
                    </a>
                @endforeach
            </div>
        </div>
        @endif
    </div>

    <!-- Right Column (Price Card + Actions + Specs Table + Seller Card) -->
    <div class="lg:col-span-5 space-y-4">
        <!-- Price, Title & Primary CTAs Card -->
        <div class="bg-white p-5 sm:rounded-3xl border border-slate-200/80 shadow-xs">
            <div class="flex items-center justify-between gap-2 mb-2">
                <div class="text-2xl md:text-3xl font-black text-rose-600">
                    {{ $ad->formatted_price }}
                </div>

                <button type="button" onclick="togglePriceDrop({{ $ad->id }}, this)" class="text-xs font-semibold text-blue-600 hover:text-blue-800 flex items-center gap-1 bg-blue-50 px-3 py-1.5 rounded-xl transition">
                    <i class="fa-regular fa-bell {{ $hasPriceAlert ? 'text-amber-500 fa-solid' : '' }}"></i>
                    <span>{{ $hasPriceAlert ? (($isRtl ?? true) ? 'تم تفعيل التنبيه' : 'Alert active') : (($isRtl ?? true) ? 'تنبيهي عند نزول السعر' : 'Notify price drop') }}</span>
                </button>
            </div>

            <h1 class="text-lg md:text-xl font-bold text-slate-900 leading-snug mb-3">
                {{ $ad->display_title }}
            </h1>

            @if($ad->condition)
                <div class="flex items-center gap-1.5 text-xs text-slate-600 mb-4">
                    <span class="w-4 h-4 rounded-sm bg-slate-200 flex items-center justify-center text-[10px]">
                        <i class="fa-solid fa-cube"></i>
                    </span>
                    <span class="font-bold text-slate-700 capitalize">{{ $ad->condition === 'used' ? (($isRtl ?? true) ? 'مستعمل' : 'Used') : (($isRtl ?? true) ? 'جديد' : 'New') }}</span>
                </div>
            @endif

            <!-- Primary CTAs -->
            <div class="space-y-2.5 mb-4">
                <a href="tel:{{ $ad->phone }}" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-extrabold py-3.5 px-4 rounded-2xl flex items-center justify-center gap-2 text-sm shadow-sm transition active:scale-98">
                    <i class="fa-solid fa-phone text-sm"></i>
                    <span>{{ $ad->phone ?? '05048809XX' }}</span>
                </a>

                <a href="{{ route('chats.show', $ad->user_id ?? 1) }}" class="w-full bg-white hover:bg-slate-50 border border-slate-200 text-slate-800 font-extrabold py-3.5 px-4 rounded-2xl flex items-center justify-center gap-2 text-sm shadow-sm transition active:scale-98">
                    <i class="fa-brands fa-whatsapp text-emerald-500 text-xl"></i>
                    <span>{{ ($isRtl ?? true) ? 'محادثة وتواصل' : 'Chat & WhatsApp' }}</span>
                </a>

                <div class="flex items-center gap-2 pt-1">
                    <button type="button" onclick="toggleFavorite({{ $ad->id }}, this)" class="flex-1 bg-white hover:bg-rose-50 border {{ $isFavorited ? 'border-rose-300 text-rose-600' : 'border-slate-200 text-slate-700' }} font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs shadow-2xs transition active:scale-95">
                        <i class="{{ $isFavorited ? 'fa-solid text-rose-500' : 'fa-regular' }} fa-heart text-sm"></i>
                        <span>{{ ($isRtl ?? true) ? 'المفضلة' : 'Favourite' }} (<span id="favCount">{{ $ad->favorites_count }}</span>)</span>
                    </button>

                    <button type="button" onclick="shareAd()" class="flex-1 bg-white hover:bg-slate-50 border border-slate-200 text-slate-700 font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs shadow-2xs transition active:scale-95">
                        <i class="fa-solid fa-arrow-up-from-bracket text-sm"></i>
                        <span>{{ ($isRtl ?? true) ? 'مشاركة' : 'Share' }}</span>
                    </button>
                </div>
            </div>

            <!-- Specs Table -->
            <div class="space-y-2 pt-3 border-t border-slate-100">
                <div class="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl text-xs">
                    <span class="text-slate-500 font-medium">{{ ($isRtl ?? true) ? 'رقم الإعلان' : 'Listing Id' }}</span>
                    <span class="font-bold text-slate-900 font-mono">{{ $ad->id . '79400' . $ad->id }}</span>
                </div>
                <div class="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl text-xs">
                    <span class="text-slate-500 font-medium">{{ ($isRtl ?? true) ? 'تاريخ النشر' : 'Published Date' }}</span>
                    <span class="font-bold text-slate-900">{{ $ad->time_ago }}</span>
                </div>
                <div class="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl text-xs">
                    <span class="text-slate-500 font-medium">{{ ($isRtl ?? true) ? 'المدينة' : 'City' }}</span>
                    <span class="font-bold text-slate-900">{{ $ad->city?->display_name }}</span>
                </div>
                @if($ad->neighborhood_name || $ad->neighborhood)
                    <div class="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl text-xs">
                        <span class="text-slate-500 font-medium">{{ ($isRtl ?? true) ? 'الحي' : 'Neighborhood' }}</span>
                        <span class="font-bold text-slate-900">{{ $ad->neighborhood_name ?? $ad->neighborhood?->display_name }}</span>
                    </div>
                @endif
                @if(!empty($ad->attributes) && is_array($ad->attributes))
                    @foreach($ad->attributes as $attrKey => $attrVal)
                        @if(!empty($attrVal) && !in_array($attrKey, ['condition']))
                            <div class="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl text-xs">
                                <span class="text-slate-500 font-medium capitalize">{{ str_replace('_', ' ', $attrKey) }}</span>
                                <span class="font-bold text-slate-900 capitalize">{{ is_array($attrVal) ? implode(', ', $attrVal) : $attrVal }}</span>
                            </div>
                        @endif
                    @endforeach
                @endif
            </div>
        </div>

        <!-- Lister Profile Card -->
        <div class="bg-white p-5 sm:rounded-3xl border border-slate-200/80 shadow-xs space-y-4">
            <div class="p-4 bg-slate-50 border border-slate-200 rounded-2xl">
                <div class="flex items-center justify-between mb-3">
                    <div>
                        <div class="text-xs text-slate-500 font-medium">{{ ($isRtl ?? true) ? 'تقييم المعلن' : 'Member Rating' }}</div>
                        <div class="flex items-center gap-1 mt-0.5">
                            <span class="text-sm font-bold text-slate-900">{{ number_format($ad->user->rating ?? 0.0, 1) }}</span>
                            <div class="flex text-amber-400 text-xs">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-regular fa-star"></i>
                            </div>
                            <span class="text-xs text-blue-600 font-bold">({{ $ad->user->rating_count ?? 0 }}) &gt;</span>
                        </div>
                    </div>

                    <div class="text-end">
                        <div class="text-xs text-slate-500 font-medium">{{ ($isRtl ?? true) ? 'عضو منذ' : 'Member since' }}</div>
                        <div class="text-xs font-bold text-slate-900 mt-0.5">
                            {{ $ad->user && $ad->user->member_since ? $ad->user->member_since->format('d-m-Y') : '17-08-2016' }}
                        </div>
                    </div>
                </div>

                <a href="{{ route('home') }}?user_id={{ $ad->user_id }}" class="text-xs font-bold text-blue-600 hover:text-blue-800 flex items-center justify-between pt-2 border-t border-slate-200">
                    <span>{{ ($isRtl ?? true) ? 'مشاهدة جميع إعلانات المعلن' : 'View all listings' }} ({{ $ad->user->active_ads_count ?? 1 }})</span>
                    <span>&gt;</span>
                </a>
            </div>

            <!-- Safety Tips -->
            <div class="p-4 bg-cyan-50/70 border border-cyan-100 rounded-2xl">
                <h3 class="text-xs font-bold text-cyan-900 mb-2 flex items-center gap-1.5">
                    <i class="fa-solid fa-shield-halved text-cyan-600"></i>
                    <span>{{ ($isRtl ?? true) ? 'نصائح عامة للأمان' : 'General Tips' }}</span>
                </h3>
                <ul class="text-[11px] text-cyan-800 space-y-1 list-disc {{ ($isRtl ?? true) ? 'pr-4' : 'pl-4' }}">
                    <li>{{ ($isRtl ?? true) ? 'الالتقاء فقط في الأماكن العامة' : 'Only meet in public places' }}</li>
                    <li>{{ ($isRtl ?? true) ? 'لا تقم أبداً بتحويل أموال مسبقاً' : 'Never pay or transfer money in advance' }}</li>
                    <li>{{ ($isRtl ?? true) ? 'افحص المنتج قبل إتمام الشراء' : 'Inspect product before buying' }}</li>
                </ul>
            </div>

            <!-- "Ask the Lister" Box -->
            <div class="p-4 bg-slate-50 border border-slate-200 rounded-2xl">
                <div class="flex items-center gap-2 text-xs font-bold text-slate-900 mb-3">
                    <i class="fa-regular fa-circle-question text-blue-600 text-sm"></i>
                    <span>{{ ($isRtl ?? true) ? 'اسأل المعلن' : 'Ask the Lister' }}</span>
                </div>

                <div class="grid grid-cols-2 gap-2 mb-3">
                    <button type="button" onclick="setQuickMessage(this.innerText.replace(' >', ''))" class="p-2 bg-blue-100/70 hover:bg-blue-200 text-blue-900 text-[11px] font-semibold rounded-xl text-start truncate transition">
                        {{ ($isRtl ?? true) ? 'أنا مهتم بهذا الإعلان' : "I'm interested" }} &gt;
                    </button>
                    <button type="button" onclick="setQuickMessage(this.innerText.replace(' >', ''))" class="p-2 bg-blue-100/70 hover:bg-blue-200 text-blue-900 text-[11px] font-semibold rounded-xl text-start truncate transition">
                        {{ ($isRtl ?? true) ? 'هل يمكن تخفيض السعر؟' : 'Can you lower price' }} &gt;
                    </button>
                    <button type="button" onclick="setQuickMessage(this.innerText.replace(' >', ''))" class="p-2 bg-blue-100/70 hover:bg-blue-200 text-blue-900 text-[11px] font-semibold rounded-xl text-start truncate transition">
                        {{ ($isRtl ?? true) ? 'أين يمكننا المعاينة؟' : 'Where can we meet' }} &gt;
                    </button>
                    <button type="button" onclick="setQuickMessage(this.innerText.replace(' >', ''))" class="p-2 bg-blue-100/70 hover:bg-blue-200 text-blue-900 text-[11px] font-semibold rounded-xl text-start truncate transition">
                        {{ ($isRtl ?? true) ? 'هل توفر التوصيل؟' : 'You do delivery' }} &gt;
                    </button>
                </div>

                <form onsubmit="sendQuickMsg(event)" class="space-y-2">
                    <div class="relative">
                        <input type="text" id="quickMsgInput" placeholder="{{ ($isRtl ?? true) ? 'اكتب رسالتك للمعلن...' : 'Text message...' }}"
                            class="w-full bg-white text-slate-800 py-2.5 px-3 rounded-xl border border-slate-300 text-xs placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-400">
                        <button type="submit" class="absolute {{ ($isRtl ?? true) ? 'left-2' : 'right-2' }} top-2 bg-blue-600 text-white rounded-lg px-2.5 py-1 text-[11px] font-bold shadow-xs hover:bg-blue-700">
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </div>
                    <div id="quickMsgStatus" class="text-[11px] font-semibold text-emerald-600 hidden"></div>
                </form>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
    // Sticky Header Scroll Listener
    window.addEventListener('scroll', function() {
        const sticky = document.getElementById('stickyHeader');
        if (window.scrollY > 350) {
            sticky.classList.remove('hidden');
        } else {
            sticky.classList.add('hidden');
        }
    });

    function setQuickMessage(text) {
        document.getElementById('quickMsgInput').value = text;
        document.getElementById('quickMsgInput').focus();
    }

    function sendQuickMsg(e) {
        e.preventDefault();
        const input = document.getElementById('quickMsgInput');
        const text = input.value.trim();
        if (!text) return;

        fetch('{{ route('ads.quick-message', $ad->id) }}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                'Accept': 'application/json'
            },
            body: JSON.stringify({ message: text })
        })
        .then(res => res.json())
        .then(data => {
            if (data.require_auth) {
                window.location.href = '{{ route('login') }}';
                return;
            }
            const status = document.getElementById('quickMsgStatus');
            status.textContent = data.message;
            status.classList.remove('hidden');
            input.value = '';
            setTimeout(() => status.classList.add('hidden'), 4000);
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
            const favCountSpan = document.getElementById('favCount');
            if (favCountSpan) favCountSpan.textContent = data.count;
            location.reload();
        });
    }

    function togglePriceDrop(adId, btn) {
        fetch(`/ads/${adId}/price-drop`, {
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
            alert(data.message);
            location.reload();
        });
    }

    function shareAd() {
        if (navigator.share) {
            navigator.share({
                title: '{{ $ad->display_title }}',
                text: '{{ $ad->formatted_price }} - {{ $ad->display_title }}',
                url: window.location.href
            });
        } else {
            navigator.clipboard.writeText(window.location.href);
            alert('Listing link copied to clipboard!');
        }
    }
</script>
@endpush
@endsection
