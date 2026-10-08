@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'حسابي' : 'Account')

@section('content')
<!-- Header matching Screenshots 8 & 11 -->
<div class="bg-white px-4 pt-4 pb-3 border-b border-slate-100 flex items-center justify-between sticky top-7 z-30 shadow-xs">
    <h1 class="text-xl font-black text-slate-900">
        {{ ($isRtl ?? true) ? 'حسابي' : 'Account' }}
    </h1>

    <div class="flex items-center gap-3">
        <!-- Settings Gear -->
        <button type="button" onclick="alert('Account Settings')" class="text-slate-700 hover:text-slate-900">
            <i class="fa-solid fa-gear text-lg"></i>
        </button>

        <!-- Notification Bell with Badge -->
        <button type="button" class="text-slate-700 hover:text-slate-900 relative">
            <i class="fa-solid fa-bell text-lg"></i>
            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-[9px] font-bold rounded-full w-3.5 h-3.5 flex items-center justify-center">1</span>
        </button>

        <!-- Support Phone -->
        <a href="tel:+96599001122" class="text-slate-700 hover:text-slate-900">
            <i class="fa-solid fa-phone text-lg"></i>
        </a>
    </div>
</div>

<div class="max-w-4xl mx-auto p-4 space-y-4">
    <!-- Get Verified User Badge Banner matching Screenshot 11 -->
    <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200/80 rounded-2xl p-4 flex items-center justify-between shadow-xs">
        <div class="flex items-center gap-3.5">
            <div class="w-12 h-12 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-xl flex-shrink-0 relative">
                <i class="fa-solid fa-user-shield"></i>
                <span class="absolute -bottom-1 -right-1 bg-blue-600 text-white rounded-full w-4 h-4 flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-check"></i>
                </span>
            </div>
            <div>
                <h3 class="text-xs font-black text-slate-900">{{ ($isRtl ?? true) ? 'احصل على شارة الحساب الموثق' : 'Get Verified User Badge' }}</h3>
                <p class="text-[10px] text-slate-500 mt-0.5">{{ ($isRtl ?? true) ? 'ابنِ مصداقيتك . عزز ظهورك . اكسب الثقة' : 'Build Credibility . Boost Visibility . Gain Trust' }}</p>
                <a href="{{ route('demo.login', 'alghanim') }}" class="text-[11px] font-bold text-blue-600 hover:text-blue-800 flex items-center gap-1 mt-1">
                    <span>{{ ($isRtl ?? true) ? 'توثيق الحساب الآن' : 'Verify now' }}</span>
                    <span>&rarr;</span>
                </a>
            </div>
        </div>
    </div>

    <!-- User Profile Card matching Screenshots 8 & 11 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs">
        @if($isGuest)
            <!-- Guest State (Screenshot 8) -->
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h2 class="text-base font-extrabold text-slate-900">{{ ($isRtl ?? true) ? 'مرحباً بالزائر!' : 'Hello Guest!' }}</h2>
                    <a href="{{ route('login') }}" class="text-xs font-bold text-blue-600 hover:underline mt-1 inline-block">
                        {{ ($isRtl ?? true) ? 'تسجيل الدخول' : 'Login' }}
                    </a>
                </div>
                <div class="w-14 h-14 rounded-2xl bg-slate-200 text-slate-400 flex items-center justify-center text-2xl">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        @else
            <!-- Logged-in Seller State (Screenshot 11) -->
            <div class="flex items-start justify-between mb-3">
                <div class="flex-1">
                    <div class="flex items-center gap-2">
                        <h2 class="text-base font-black text-slate-900">{{ $profile['name'] }}</h2>
                        @if($profile['is_verified'])
                            <span class="text-blue-600 text-xs" title="Verified Badge"><i class="fa-solid fa-circle-check"></i></span>
                        @endif
                    </div>
                    <div class="text-[11px] text-slate-500 flex items-center gap-1.5 mt-1">
                        <i class="fa-regular fa-calendar text-slate-400"></i>
                        <span>{{ ($isRtl ?? true) ? 'عضو منذ' : 'Member since' }} {{ $profile['member_since'] }}</span>
                    </div>

                    <!-- Star Rating -->
                    <div class="flex items-center gap-1 mt-1 text-slate-300 text-xs">
                        <i class="fa-solid fa-star text-amber-400"></i>
                        <i class="fa-solid fa-star text-amber-400"></i>
                        <i class="fa-solid fa-star text-amber-400"></i>
                        <i class="fa-solid fa-star text-amber-400"></i>
                        <i class="fa-regular fa-star"></i>
                        <span class="text-blue-600 font-bold ml-1">({{ $profile['rating_count'] }})</span>
                    </div>
                </div>

                <!-- Business Logo / Avatar (Screenshot 11 - Al Ghanim Yellow Logo) -->
                <div class="w-14 h-14 rounded-2xl bg-lime-300 text-slate-900 flex flex-col items-center justify-center font-black p-1 shadow-xs border border-lime-400">
                    <span class="text-[9px] leading-tight">الغانم</span>
                    <span class="text-[8px] font-mono leading-tight">Al Ghanim</span>
                </div>
            </div>

            <!-- ID & Type Pills (Screenshot 11) -->
            <div class="flex items-center gap-2 mb-4">
                <div class="flex items-center gap-1.5 bg-slate-100 px-3 py-1.5 rounded-xl text-xs font-mono text-slate-700 font-semibold">
                    <span>ID: {{ $profile['member_id'] }}</span>
                    <button type="button" onclick="navigator.clipboard.writeText('{{ $profile['member_id'] }}'); alert('ID copied!')" class="text-slate-400 hover:text-slate-600">
                        <i class="fa-regular fa-copy text-[11px]"></i>
                    </button>
                </div>

                <a href="#" onclick="alert('Membership upgrade'); return false;" class="flex items-center gap-1.5 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-xl text-xs text-slate-700 font-semibold transition">
                    <span>Type: {{ $profile['member_type'] }}</span>
                    <i class="fa-solid fa-chevron-right text-[9px] text-slate-400"></i>
                </a>
            </div>

            <!-- Limit of Live Listings Slider (Screenshot 11) -->
            <div class="mb-4 bg-slate-50 p-3 rounded-xl border border-slate-100">
                <div class="flex items-center justify-between text-xs font-bold text-slate-800 mb-2">
                    <span>{{ ($isRtl ?? true) ? 'حد الإعلانات النشطة' : 'Limit of live listings' }}</span>
                    <span class="text-blue-600 font-black">{{ $profile['live_listings_limit'] }}</span>
                </div>
                <!-- Progress Line -->
                <div class="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
                    <div class="bg-blue-600 h-full rounded-full" style="width: {{ min(100, ($profile['live_listings_count'] / max($profile['live_listings_limit'], 1)) * 100) }}%"></div>
                </div>
                <div class="text-[10px] text-slate-400 mt-1 flex justify-between">
                    <span>{{ $profile['live_listings_count'] }} {{ ($isRtl ?? true) ? 'مستخدم' : 'used' }}</span>
                    <span>{{ $profile['live_listings_limit'] }} {{ ($isRtl ?? true) ? 'الحد الأقصى' : 'total' }}</span>
                </div>
            </div>
        @endif

        <!-- Action Buttons matching Screenshots 8 & 11 -->
        <div class="flex items-center gap-2.5">
            <a href="{{ $isGuest ? route('login') : '#' }}" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-xl text-center text-xs shadow-xs transition active:scale-95">
                {{ ($isRtl ?? true) ? 'إدارة الحساب' : 'Manage Account' }}
            </a>
            <a href="{{ route('ads.create') }}" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-xl text-center text-xs shadow-xs transition active:scale-95">
                {{ ($isRtl ?? true) ? 'احصل على المزيد من الإعلانات' : 'Get More Listings' }}
            </a>
        </div>
    </div>

    <!-- Share My Account and Listings matching Screenshots 8 & 11 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs">
        <h3 class="text-xs font-bold text-slate-900">{{ ($isRtl ?? true) ? 'مشاركة حسابي وإعلاناتي' : 'Share My Account and Listings' }}</h3>
        <p class="text-[11px] text-slate-400 mt-0.5 mb-3">{{ ($isRtl ?? true) ? 'شارك على منصات التواصل الاجتماعي' : 'Share on your social media' }}</p>

        <div class="flex items-center justify-between gap-2 pt-1">
            <!-- SMS / Chat -->
            <button type="button" onclick="alert('Share via SMS')" class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center text-sm shadow-xs hover:scale-105 transition">
                <i class="fa-solid fa-comment"></i>
            </button>
            <!-- WhatsApp -->
            <button type="button" onclick="window.open('https://api.whatsapp.com/send?text=' + encodeURIComponent(window.location.href))" class="w-10 h-10 rounded-full bg-emerald-500 text-white flex items-center justify-center text-lg shadow-xs hover:scale-105 transition">
                <i class="fa-brands fa-whatsapp"></i>
            </button>
            <!-- Email -->
            <button type="button" onclick="window.location.href='mailto:?subject=KuwaitSouq&body=' + encodeURIComponent(window.location.href)" class="w-10 h-10 rounded-full bg-teal-500 text-white flex items-center justify-center text-sm shadow-xs hover:scale-105 transition">
                <i class="fa-regular fa-envelope"></i>
            </button>
            <!-- X / Twitter -->
            <button type="button" onclick="window.open('https://twitter.com/intent/tweet?url=' + encodeURIComponent(window.location.href))" class="w-10 h-10 rounded-full bg-black text-white flex items-center justify-center text-sm shadow-xs hover:scale-105 transition">
                <i class="fa-brands fa-x-twitter"></i>
            </button>
            <!-- Facebook -->
            <button type="button" onclick="window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(window.location.href))" class="w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center text-sm shadow-xs hover:scale-105 transition">
                <i class="fa-brands fa-facebook-f"></i>
            </button>
            <!-- More -->
            <button type="button" onclick="navigator.share ? navigator.share({title: 'KuwaitSouq', url: window.location.href}) : alert('Share dialog')" class="w-10 h-10 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center text-sm shadow-xs hover:scale-105 transition">
                <i class="fa-solid fa-ellipsis"></i>
            </button>
        </div>
    </div>

    <!-- Wallet Card matching Screenshot 8 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs">
        <h3 class="text-xs font-bold text-slate-900 mb-3">{{ ($isRtl ?? true) ? 'المحفظة' : 'Wallet' }}</h3>

        <div class="grid grid-cols-2 gap-3 mb-3">
            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between">
                <div>
                    <div class="text-lg font-black text-slate-900">{{ $profile['listing_credits'] }}</div>
                    <div class="text-[10px] text-slate-500 font-semibold">{{ ($isRtl ?? true) ? 'رصيد إعلانات' : 'Listing Credits' }}</div>
                </div>
                <div class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
            </div>

            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between">
                <div>
                    <div class="text-lg font-black text-slate-900">{{ $profile['vas_credits'] }}</div>
                    <div class="text-[10px] text-slate-500 font-semibold">{{ ($isRtl ?? true) ? 'رصيد تمييز (صاروخ)' : 'VAS Credits' }}</div>
                </div>
                <div class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
            </div>
        </div>

        <!-- Add Credit Form Button -->
        <form action="{{ route('account.add-credit') }}" method="POST">
            @csrf
            <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-xl text-xs flex items-center justify-center gap-1.5 shadow-xs transition active:scale-95">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>{{ ($isRtl ?? true) ? 'إضافة رصيد' : 'Add Credit' }}</span>
            </button>
        </form>
    </div>

    <!-- "My CV" Job Portal Card matching Screenshot 9 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs">
        <h3 class="text-xs font-bold text-slate-900 mb-2">{{ ($isRtl ?? true) ? 'سيرتي الذاتية' : 'My CV' }}</h3>

        <!-- 50% completeness tip banner (Screenshot 9) -->
        <div class="p-3 bg-blue-50/70 border border-dashed border-blue-300 rounded-xl mb-3 flex items-start gap-2.5">
            <i class="fa-regular fa-lightbulb text-amber-500 text-sm mt-0.5"></i>
            <p class="text-[10px] text-blue-900 font-medium leading-relaxed">
                {{ ($isRtl ?? true) ? 'لا يمكن التقدم للوظائف إذا كانت نسبة اكتمال السيرة الذاتية أقل من 50%' : 'It is not possible to apply for a job if completeness score is less than 50%' }}
            </p>
        </div>

        <!-- Completeness meter -->
        <div class="mb-3">
            <div class="flex items-center justify-between text-[11px] font-bold text-slate-700 mb-1">
                <span>{{ ($isRtl ?? true) ? 'اكتمال السيرة الذاتية' : 'CV Completeness' }}</span>
                <span>{{ $profile['cv_completeness'] }}%</span>
            </div>
            <div class="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
                <div class="bg-blue-600 h-full rounded-full transition-all duration-500" style="width: {{ $profile['cv_completeness'] }}%"></div>
            </div>
        </div>

        <div class="grid grid-cols-2 gap-3 mb-3">
            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between">
                <div>
                    <div class="text-lg font-black text-slate-900">{{ $profile['cv_views'] }}</div>
                    <div class="text-[10px] text-slate-500 font-semibold">{{ ($isRtl ?? true) ? 'مشاهدات السيرة' : 'CV Views' }}</div>
                </div>
                <div class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
            </div>

            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between">
                <div>
                    <div class="text-lg font-black text-slate-900">{{ $profile['job_applications_count'] }}</div>
                    <div class="text-[10px] text-slate-500 font-semibold">{{ ($isRtl ?? true) ? 'طلبات التوظيف' : 'Job Applications' }}</div>
                </div>
                <div class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
            </div>
        </div>

        <form action="{{ route('account.update-cv') }}" method="POST">
            @csrf
            <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-xl text-xs shadow-xs transition active:scale-95">
                {{ ($isRtl ?? true) ? 'إدارة السيرة الذاتية' : 'Manage CV' }}
            </button>
        </form>
    </div>

    <!-- Stats Card matching Screenshot 9 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs">
        <h3 class="text-xs font-bold text-slate-900 mb-3">{{ ($isRtl ?? true) ? 'الإحصائيات' : 'Stats' }}</h3>

        <div class="grid grid-cols-2 gap-3">
            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between">
                <div>
                    <div class="text-lg font-black text-slate-900">{{ $profile['member_views'] }}</div>
                    <div class="text-[10px] text-slate-500 font-semibold">{{ ($isRtl ?? true) ? 'مشاهدات العضوية' : 'Member Views' }}</div>
                </div>
                <div class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
            </div>

            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between">
                <div>
                    <div class="text-lg font-black text-slate-900">{{ $profile['listing_views'] }}</div>
                    <div class="text-[10px] text-slate-500 font-semibold">{{ ($isRtl ?? true) ? 'مشاهدات الإعلانات' : 'Listing Views' }}</div>
                </div>
                <div class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px]">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Car Reports / CarFax Card matching Screenshot 10 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs flex items-center justify-between">
        <div>
            <h3 class="text-xs font-extrabold text-slate-900">{{ ($isRtl ?? true) ? 'تقارير فحص السيارات' : 'Car reports' }}</h3>
            <p class="text-[11px] text-slate-400">CarFax • فحص كاشف الحوادث</p>
            <a href="#" onclick="alert('Car history report system'); return false;" class="text-xs font-bold text-blue-600 hover:text-blue-800 flex items-center gap-1 mt-2">
                <span>{{ ($isRtl ?? true) ? 'شراء التقرير الآن' : 'Buy Now' }}</span>
                <i class="fa-solid fa-circle-chevron-right text-[10px]"></i>
            </a>
        </div>
        <div class="w-16 h-12 flex items-center justify-center text-red-500 text-3xl">
            <i class="fa-solid fa-car-burst"></i>
        </div>
    </div>

    <!-- Help & Support Card matching Screenshot 10 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-xs">
        <h3 class="text-xs font-bold text-slate-900">{{ ($isRtl ?? true) ? 'هل تحتاج إلى مساعدة؟' : 'Do you need help?' }}</h3>
        <p class="text-[11px] text-slate-400 mb-3">{{ ($isRtl ?? true) ? 'تواصل معنا الآن' : 'Contact us now' }}</p>

        <div class="space-y-2">
            <a href="tel:+96599001122" class="w-full bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-800 font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs transition">
                <i class="fa-solid fa-phone text-blue-600"></i>
                <span>{{ ($isRtl ?? true) ? 'اتصل بنا' : 'Contact Us' }}</span>
            </a>

            <a href="mailto:sales@kuwaitsouq.com" class="w-full bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-800 font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs transition">
                <i class="fa-solid fa-user-tie text-blue-600"></i>
                <span>{{ ($isRtl ?? true) ? 'فريق المبيعات' : 'Sales Team' }}</span>
            </a>

            <button type="button" onclick="alert('Thank you! Feature suggestion received.')" class="w-full bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-800 font-bold py-2.5 px-3 rounded-xl flex items-center justify-center gap-2 text-xs transition">
                <i class="fa-regular fa-square-plus text-blue-600"></i>
                <span>{{ ($isRtl ?? true) ? 'اقتراح ميزة جديدة' : 'Request Feature' }}</span>
            </button>
        </div>
    </div>

    <!-- Footer Information matching Screenshot 10 -->
    <div class="bg-white rounded-2xl border border-slate-200/90 p-4 text-center shadow-xs">
        <div class="flex items-center justify-center gap-2 mb-1">
            <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq" class="w-6 h-6 rounded-md">
            <span class="text-lg font-black text-slate-900">Kuwait<span class="text-blue-600">Souq</span></span>
            <span class="text-xs px-2 py-0.5 bg-blue-100 text-blue-800 rounded-md font-bold">v1.0.0</span>
        </div>
        <div class="text-[10px] text-slate-400 mb-2">{{ ($isRtl ?? true) ? 'رقم الإصدار' : 'Version Number' }}</div>
        <a href="{{ route('home') }}" class="text-xs font-bold text-blue-600 hover:underline flex items-center justify-center gap-1">
            <span>{{ ($isRtl ?? true) ? 'حول الكويت سوق' : 'About KuwaitSouq' }}</span>
            <span>&rarr;</span>
        </a>
    </div>

    @if(!$isGuest)
        <!-- Logout Button -->
        <form action="{{ route('logout') }}" method="POST">
            @csrf
            <button type="submit" class="w-full bg-rose-50 hover:bg-rose-100 text-rose-600 font-bold py-3 rounded-xl text-xs transition border border-rose-200">
                <i class="fa-solid fa-arrow-right-from-bracket ml-1"></i>
                <span>{{ ($isRtl ?? true) ? 'تسجيل الخروج' : 'Logout' }}</span>
            </button>
        </form>
    @endif
</div>
@endsection
