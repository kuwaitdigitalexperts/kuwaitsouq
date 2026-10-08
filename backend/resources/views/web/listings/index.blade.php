@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'إعلاناتي' : 'Listings')

@section('content')
<!-- Header matching Screenshot 12 -->
<div class="bg-white px-4 pt-4 pb-3 border-b border-slate-100 flex items-center justify-between sticky top-7 z-30 shadow-xs">
    <h1 class="text-xl font-black text-slate-900">
        {{ ($isRtl ?? true) ? 'إعلاناتي' : 'Listings' }}
    </h1>

    <div class="flex items-center gap-3">
        <!-- Notification Bell -->
        <button type="button" class="text-slate-700 hover:text-slate-900 relative">
            <i class="fa-solid fa-bell text-lg"></i>
            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-[9px] font-bold rounded-full w-3.5 h-3.5 flex items-center justify-center">1</span>
        </button>

        <!-- Customer Support Phone -->
        <a href="tel:+96599001122" class="text-slate-700 hover:text-slate-900">
            <i class="fa-solid fa-phone text-lg"></i>
        </a>
    </div>
</div>

<div class="p-4 space-y-4">
    <!-- 4-Card Summary Grid matching Screenshot 12 (Responsive: 2 on mobile, 4 on desktop) -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-4">
        <!-- Card 1: My Listings -->
        <a href="{{ route('listings', ['tab' => 'my_ads']) }}" class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs hover:border-blue-300 transition flex flex-col justify-between h-24">
            <div class="flex items-center justify-between">
                <i class="fa-solid fa-newspaper text-slate-700 text-lg"></i>
                <span class="text-xl font-black text-blue-600">{{ $myListingsCount }}</span>
            </div>
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'إعلاناتي' : 'My Listings' }}</span>
        </a>

        <!-- Card 2: Views -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs flex flex-col justify-between h-24">
            <div class="flex items-center justify-between">
                <i class="fa-regular fa-eye text-slate-700 text-lg"></i>
                <span class="text-xl font-black text-blue-600">{{ number_format($totalViews) }}</span>
            </div>
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'المشاهدات' : 'Views' }}</span>
        </div>

        <!-- Card 3: Add New Listing -->
        <a href="{{ route('ads.create') }}" class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs hover:border-amber-400 transition flex flex-col justify-between h-24 group">
            <div class="flex items-center justify-between">
                <div class="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center text-xs group-hover:scale-110 transition-transform">
                    <i class="fa-solid fa-camera"></i>
                </div>
                <i class="fa-solid fa-plus text-xs text-amber-500 font-bold"></i>
            </div>
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'أضف إعلان جديد' : 'Add New Listing' }}</span>
        </a>

        <!-- Card 4: Rating -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200/90 shadow-xs flex flex-col justify-between h-24">
            <div class="flex items-center justify-between">
                <i class="fa-solid fa-star text-amber-400 text-lg"></i>
                <span class="text-xl font-black text-blue-600">{{ number_format($userRating, 0) }}</span>
            </div>
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'التقييم' : 'Rating' }}</span>
        </div>
    </div>

    <!-- If tab is my_ads or favorites: show ad list -->
    @if($tab === 'my_ads' || $tab === 'favorites')
        <div class="bg-white rounded-2xl border border-slate-200 p-4">
            <div class="flex items-center justify-between mb-3">
                <h2 class="text-sm font-bold text-slate-900">
                    {{ $tab === 'my_ads' ? (($isRtl ?? true) ? 'قائمة إعلاناتي' : 'My Listings List') : (($isRtl ?? true) ? 'الإعلانات المفضلة' : 'Favorite Listings') }}
                </h2>
                <a href="{{ route('listings') }}" class="text-xs text-blue-600 font-semibold">{{ ($isRtl ?? true) ? 'إغلاق' : 'Close' }}</a>
            </div>

            <div class="space-y-3">
                @forelse($ads as $item)
                    <div class="flex items-center gap-3 p-2.5 rounded-xl border border-slate-100 bg-slate-50">
                        <img src="{{ $item->media->first()?->file_path ?? 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=200' }}" class="w-14 h-14 rounded-lg object-cover">
                        <div class="flex-1 min-w-0 text-start">
                            <a href="{{ route('ads.show', $item->id) }}" class="text-xs font-bold text-slate-900 truncate block hover:text-blue-600">
                                {{ $item->display_title }}
                            </a>
                            <div class="text-xs font-black text-rose-600">{{ $item->formatted_price }}</div>
                            <div class="text-[10px] text-slate-400">{{ $item->time_ago }} • {{ $item->city?->display_name }}</div>
                        </div>
                    </div>
                @empty
                    <div class="text-center py-6 text-xs text-slate-400">
                        {{ ($isRtl ?? true) ? 'لا توجد إعلانات في هذا القسم' : 'No listings here yet' }}
                    </div>
                @endforelse
            </div>
        </div>
    @endif

    <!-- Menu List matching Screenshot 12 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 overflow-hidden divide-y divide-slate-100 shadow-xs">
        <!-- Draft Listings -->
        <a href="#" onclick="alert('No draft listings found.'); return false;" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'مسودات الإعلانات' : 'Draft Listings' }}</span>
            <div class="flex items-center gap-2 text-xs font-bold text-blue-600">
                <span>{{ $draftCount }}</span>
                <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
            </div>
        </a>

        <!-- Favorite Listings -->
        <a href="{{ route('listings', ['tab' => 'favorites']) }}" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'الإعلانات المفضلة' : 'Favorite Listings' }}</span>
            <div class="flex items-center gap-2 text-xs font-bold text-blue-600">
                <span>{{ $favoriteCount }}</span>
                <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
            </div>
        </a>

        <!-- Saved Searches -->
        <a href="#" onclick="alert('You have {{ $savedSearchesCount }} saved search alerts.'); return false;" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'عمليات البحث المحفوظة' : 'Saved Searches' }}</span>
            <div class="flex items-center gap-2 text-xs font-bold text-blue-600">
                <span>{{ $savedSearchesCount }}</span>
                <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
            </div>
        </a>

        <!-- Recently Viewed -->
        <a href="{{ route('home') }}" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'شوهدت مؤخراً' : 'Recently Viewed' }}</span>
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
        </a>

        <!-- Recent Searches -->
        <a href="{{ route('home') }}" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'عمليات البحث الأخيرة' : 'Recent Searches' }}</span>
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
        </a>

        <!-- Following Listings -->
        <a href="#" onclick="alert('Following sellers feature is active.'); return false;" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'إعلانات أتابعها' : 'Following Listings' }}</span>
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
        </a>

        <!-- Job Applications -->
        <a href="{{ route('account') }}" class="flex items-center justify-between p-4 hover:bg-slate-50 transition">
            <span class="text-xs font-bold text-slate-800">{{ ($isRtl ?? true) ? 'طلبات التوظيف' : 'Job Applications' }}</span>
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-chevron-left' : 'fa-chevron-right' }} text-[10px] text-slate-400"></i>
        </a>
    </div>
</div>
@endsection
